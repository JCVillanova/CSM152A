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
                    Exponent = 3'b111;
                end
                12'b001????????? : begin
                    Leading_Zeros = 4'b0010;
                    Exponent = 3'b110;
                end
                12'b0001???????? : begin
                    Leading_Zeros = 4'b0011;
                    Exponent = 3'b100;
                end
                12'b00001??????? : begin
                    Leading_Zeros = 4'b0100;
                    Exponent = 3'b011;
                end
                12'b000001?????? : begin
                    Leading_Zeros = 4'b0101;
                    Exponent = 3'b010;
                end
                12'b0000001????? : begin
                    Leading_Zeros = 4'b0110;
                    Exponent = 3'b001;
                end
                default          : begin
                    Leading_Zeros = 4'b0111;
                    Exponent = 3'b000;
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
    wire [11:0] mag;
    assign S = D[11];
    assign mag = S ? (~D + 1'b1) : D;
    
    //TO DO: Edge case when D = -2048 
    
    
    
    
    
    //Step 2: Leading Zero Count & Initial Extraction
    wire [3:0] l_zeros;
    count_leading_zeros count (
        .Input (mag),
        .Leading_Zeros (l_zeros),
        .Exponent (E)
    );
    
    
    
    
    
    //Step 3: Bit Shifting and window extraction 
    wire [11:0] shifted_mag = mag << l_zeros;
    wire fifth_bit = mag[7];
    assign F = shifted_mag[11:8];
    
    assign F = fifth_bit ? (F+1'b1) : F;
    
        
    //edge case overflow
    assign E = (F == 4'b0000) ? (E + 1'b1) : E;
    assign E = (E == 3'
    assign F = (F == 4'b0000) ? 4'b1000 : F;
    
    
    
endmodule





