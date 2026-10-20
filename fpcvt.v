`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2026 12:38:56 PM
// Design Name: 
// Module Name: fpcvt
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

   module count_leading_zeros(
    input wire [11:0] Input, 
    output reg [3:0] Leading_Zeros,
    output reg [2:0] Exponent);
    
        always @(*) begin
            casex (Input)
                12'b01?????????? : begin
                    Leading_Zeros = 4'b0001;
                    Exponent = 3'd7;
                end
                12'b001????????? : begin
                    Leading_Zeros = 4'b0010;
                    Exponent = 3'd6;
                end
                12'b0001???????? : begin
                    Leading_Zeros = 4'b0011;
                    Exponent = 3'd5;
                end
                12'b00001??????? : begin
                    Leading_Zeros = 4'b0100;
                    Exponent = 3'd4;
                end
                12'b000001?????? : begin
                    Leading_Zeros = 4'b0101;
                    Exponent = 3'd3;
                end
                12'b0000001????? : begin
                    Leading_Zeros = 4'b0110;
                    Exponent = 3'd2;
                end
                12'b00000001???? : begin
                    Leading_Zeros = 4'b0111;
                    Exponent = 3'd1;
                end
                default          : begin
                    Leading_Zeros = 4'b1000;
                    Exponent = 3'd0;
                end
            endcase
        end
    
    
    
    endmodule







module fpcvt(
    input  wire [11:0] D,
    output wire        S,
    output wire [2:0]  E,
    output wire [3:0]  F
    );
    
    
    // Step 1: Sign-Magnitude Conversion
    
    //000110100110
    wire [11:0] mag_raw;
    wire [11:0] mag;
    wire [2:0] E_base;
    assign S = D[11];
    assign mag_raw = S ? (~D + 1'b1) : D;
    assign mag = mag_raw[11] ? 12'b011111111111 : mag_raw;
    
    //TO DO: Edge case when D = -2048 
    
    
    
    
    
    //Step 2: Leading Zero Count & Initial Extraction
    wire [3:0] l_zeros;
    count_leading_zeros count (
        .Input (mag),
        .Leading_Zeros (l_zeros),
        .Exponent (E_base) 
    );
    
    
    
    
    
    //Step 3: Bit Shifting and window extraction 
    // Step 3: Bit Shifting and Window Extraction
    wire [11:0] shifted_mag = mag << l_zeros;
    
    wire [3:0] frac_raw = shifted_mag[11:8];
    wire round_bit = shifted_mag[7];
    
    wire [4:0] frac_rounded = {1'b0, frac_raw} + round_bit;
    
    // Step 4: Rounding, Exponent Overflow, and Saturation
    
    // Detect whether rounding caused the 4-bit fraction to overflow

    wire round_overflow = frac_rounded[4];
    
    // Increment the base exponent if the fraction rounding overflows.
    // Use 4 bits to detect when the exponent exceeds its maximum value of 7.
    wire [3:0] E_next = {1'b0, E_base} + round_overflow;
    
    // If the exponent exceeds 7, clamp it to the maximum 3-bit value.
    // Otherwise, use the calculated exponent.
    
    assign E = (E_next > 4'd7) ? 3'b111 : E_next[2:0];
    
    // If the exponent overflows, saturate the fraction to 1111.
    // If only the fraction overflows due to rounding, use 1000.
    // Otherwise, use the rounded fraction normally.
    assign F = (E_next > 4'd7) ? 4'b1111 :
               round_overflow ? 4'b1000 :
                                frac_rounded[3:0];
    
    
endmodule





