`timescale 1ns / 1ps

module model_uart(/*AUTOARG*/
   // Outputs
   TX,
   // Inputs
   RX
   );

   output TX;
   input  RX;

   parameter baud    = 115200;
   parameter bittime = 1000000000/baud;
   parameter name    = "UART0";
   
   reg [7:0] rxData;
   event     evBit;
   event     evByte;
   event     evTxBit;
   event     evTxByte;
   reg       TX;

   initial
     begin
        TX = 1'b1;
     end
     
reg char_list [31:0]; // Added [7:0] bit-width for bytes
     integer char_idx = 0;
     
     // Named events must be declared if 
     
     always @ (negedge RX)
     begin
         rxData[7:0] = 8'h0;
         #(0.5 * bittime);
         
         repeat (8)
         begin
             #bittime ->evBit;
             rxData[7:0] = {RX, rxData[7:1]}; // Correct LSB-first UART shift
         end
         
         ->evByte;
         
        always @ (negedge RX)
         begin
             rxData[7:0] = 8'h0;
             #(0.5 * bittime);
             
             repeat (8)
             begin
                 #bittime ->evBit;
                 rxData[7:0] = {RX, rxData[7:1]}; // Correct LSB-first UART shift
             end
             
             ->evByte;
             
             if (rxData == 8'h0d) begin
                 // Removed the extra %s mismatch; printing time and the hex byte
                 $display("%0t: Received Carriage Return byte %02x", $time, rxData);
                 char_idx = 0;
             end else begin
                 // Bound check to prevent array index out-of-bounds
                 if (char_idx < 32) begin
                     char_list[char_idx] = rxData;
                     char_idx = char_idx + 1;
                 end
             end
   
   task tskRxData;
      output [7:0] data;
      begin
         @(evByte);
         data = rxData;
      end
   endtask // for
      
   task tskTxData;
      input [7:0] data;
      reg [9:0]   tmp;
      integer     i;
      begin
         tmp = {1'b1, data[7:0], 1'b0};
         for (i=0;i<10;i=i+1)
           begin
              TX = tmp[i];
              #bittime;
              ->evTxBit;
           end
         ->evTxByte;
      end
   endtask // tskTxData
   
endmodule // model_uart
