`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2026 01:42:48 PM
// Design Name: 
// Module Name: stopwatch_counter
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



`timescale 1ns / 1ps

module stopwatch_counter(
    input wire clk,
    input wire rst,
    input wire tick_1hz,
    input wire tick_2hz,
    input wire adj,
    input wire sel,
    input wire pause,
    output reg [3:0] sec_ones,
    output reg [3:0] sec_tens,
    output reg [3:0] min_ones,
    output reg [3:0] min_tens
);

    reg paused;
    reg pause_prev;

    // Detect a new press of the pause button.
    always @(posedge clk) begin
        if (rst) begin
            paused    <= 1'b0;
            pause_prev <= 1'b0;
        end
        else begin
            pause_prev <= pause;

            if (pause && !pause_prev)
                paused <= ~paused;
        end
    end

    // Stopwatch counting and adjustment.
    always @(posedge clk) begin
        if (rst) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end
        else if (adj) begin
            // Adjustment mode: sel=0 adjusts minutes,
            // sel=1 adjusts seconds.
            if (tick_2hz) begin
                if (sel) begin
                    if (sec_ones == 4'd9) begin
                        sec_ones <= 4'd0;
                        if (sec_tens == 4'd5) sec_tens <= 4'd0;
                        else sec_tens <= sec_tens + 1'b1;
                    end else begin
                        sec_ones <= sec_ones + 1'b1;
                    end
                end
                else begin
                    if (min_ones == 4'd9) begin
                        min_ones <= 4'd0;
                        if (min_tens == 4'd5) min_tens <= 4'd0;
                        else min_tens <= min_tens + 1'b1;
                    end else begin
                        min_ones <= min_ones + 1'b1;
                    end
                end
            end
        end
        else if (!paused && tick_1hz) begin
            // Normal stopwatch mode.
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                
                if (sec_tens == 4'd5) begin
                    sec_tens <= 4'd0;
                    
                    if (min_ones == 4'd9) begin
                        min_ones <= 4'd0;
                        
                        if (min_tens == 4'd5) min_tens <= 4'd0;
                        else min_tens <= min_tens + 1'b1;
                        
                    end else begin
                        min_ones <= min_ones + 1'b1;
                    end
                    
                end else begin
                    sec_tens <= sec_tens + 1'b1;
                end
            end
            else begin
                sec_ones <= sec_ones + 1'b1;
            end
        end
    end

endmodule
