`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2026 12:27:37 PM
// Design Name: 
// Module Name: bin_to_7seg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module bin_to_7seg(
    input [3:0] digit0,
    input [3:0] digit1,
    input [3:0] digit2,
    input [3:0] digit3,
    output reg  [6:0] seg0,
    output reg  [6:0] seg1,
    output reg  [6:0] seg2,
    output reg  [6:0] seg3
    );
    
    always @(*) begin
      
          // Digit 0: Ones
          case (digit0)
              4'd0: seg0 = 7'b0000001;
              4'd1: seg0 = 7'b1001111;
              4'd2: seg0 = 7'b0010010;
              4'd3: seg0 = 7'b0000110;
              4'd4: seg0 = 7'b1001100;
              4'd5: seg0 = 7'b0100100;
              4'd6: seg0 = 7'b0100000;
              4'd7: seg0 = 7'b0001111;
              4'd8: seg0 = 7'b0000000;
              4'd9: seg0 = 7'b0000100;
              default: seg0 = 7'b1111111;
          endcase
      
          // Digit 1: Tens
          case (digit1)
              4'd0: seg1 = 7'b0000001;
              4'd1: seg1 = 7'b1001111;
              4'd2: seg1 = 7'b0010010;
              4'd3: seg1 = 7'b0000110;
              4'd4: seg1 = 7'b1001100;
              4'd5: seg1 = 7'b0100100;
              4'd6: seg1 = 7'b0100000;
              4'd7: seg1 = 7'b0001111;
              4'd8: seg1 = 7'b0000000;
              4'd9: seg1 = 7'b0000100;
              default: seg1 = 7'b1111111;
          endcase
      
          // Digit 2: Hundreds
          case (digit2)
              4'd0: seg2 = 7'b0000001;
              4'd1: seg2 = 7'b1001111;
              4'd2: seg2 = 7'b0010010;
              4'd3: seg2 = 7'b0000110;
              4'd4: seg2 = 7'b1001100;
              4'd5: seg2 = 7'b0100100;
              4'd6: seg2 = 7'b0100000;
              4'd7: seg2 = 7'b0001111;
              4'd8: seg2 = 7'b0000000;
              4'd9: seg2 = 7'b0000100;
              default: seg2 = 7'b1111111;
          endcase
      
          // Digit 3: Thousands
          case (digit3)
              4'd0: seg3 = 7'b0000001;
              4'd1: seg3 = 7'b1001111;
              4'd2: seg3 = 7'b0010010;
              4'd3: seg3 = 7'b0000110;
              4'd4: seg3 = 7'b1001100;
              4'd5: seg3 = 7'b0100100;
              4'd6: seg3 = 7'b0100000;
              4'd7: seg3 = 7'b0001111;
              4'd8: seg3 = 7'b0000000;
              4'd9: seg3 = 7'b0000100;
              default: seg3 = 7'b1111111;
          endcase
      
      end

endmodule