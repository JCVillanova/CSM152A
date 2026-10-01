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
     
         
       reg [7:0] char_list [31:0]; // Array to store up to 8 characters
         integer char_idx = 0;       // Index tracker for the array
              // 8-bit shift register for received data
         
         always @(negedge RX) begin
             // Wait for the middle of the start bit (0.5 bit time)
             #(0.5 * bittime); 
             
             rxData = 8'h00;
             
             // Loop 8 times to sample the 8 data bits
             repeat (8) begin
                 #bittime;                         // Wait for the next bit center
                 -> evBit;                         // Trigger a "bit sampled" event
                 rxData = {RX, rxData[7:1]};       // Shift RX bit in from the MSB side
             end
             
             -> evByte;                            // Trigger a "byte completed" event
             
             // Check if the received byte is a Carriage Return (\r or 0x0D)
             if (rxData == 8'h0D) begin
                 $display("[%0d] Received byte: 0x%02x (%c) at time %0t", char_idx, rxData, char_line, $stime);
                 char_idx = 0;                     // Reset index on Carriage Return
                 // Optional: clear char_list here if needed
             end 
             // Check if the received byte is a Line Feed (\n or 0x0A)
             else if (rxData == 8'h0A) begin
                 // Store the Line Feed (or append logic)
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
