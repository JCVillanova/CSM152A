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
    output reg [5:0] seconds,
    output reg [5:0] minutes
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
            seconds <= 6'd0;
            minutes <= 6'd0;
        end
        else if (adj) begin
            // Adjustment mode: sel=0 adjusts minutes,
            // sel=1 adjusts seconds.
            if (tick_2hz) begin
                if (sel) begin
                    if (seconds == 6'd59)
                        seconds <= 6'd0;
                    else
                        seconds <= seconds + 1'b1;
                end
                else begin
                    if (minutes == 6'd59)
                        minutes <= 6'd0;
                    else
                        minutes <= minutes + 1'b1;
                end
            end
        end
        else if (!paused && tick_1hz) begin
            // Normal stopwatch mode.
            if (seconds == 6'd59) begin
                seconds <= 6'd0;

                if (minutes == 6'd59)
                    minutes <= 6'd0;
                else
                    minutes <= minutes + 1'b1;
            end
            else begin
                seconds <= seconds + 1'b1;
            end
        end
    end

endmodule
