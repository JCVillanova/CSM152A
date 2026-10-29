`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2026 01:03:42 PM
// Design Name: 
// Module Name: seven_segment
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


module seven_segment(
    input clk,
    input rst,
    input wire [6:0] seg0,seg1, seg2, seg3,
    input wire tick_scan,
    input wire tick_blink,
    input wire adj,
    input wire sel,
    output reg [3:0] Anode_activate,
    output reg [6:0] LED_out
    );
    
    // Chooses which of the four digits is currently active.
    reg [1:0] digit_select;
    reg [6:0] selected_seg;
    
    // Keeps track of the blink on/off phase
    reg blink_state;

    always @(posedge clk) begin
        if (rst)
            blink_state <= 1'b0;
        else if (tick_blink)
            blink_state <= ~blink_state;
    end

    // Advance to the next digit whenever tick_scan pulses.
    always @(posedge clk) begin
        if (rst)
            digit_select <= 2'd0;
        else if (tick_scan)
            digit_select <= digit_select + 1'b1;
    end

    // Basys 3 anodes are active-low:
    // 0 = digit enabled, 1 = digit disabled.
    always @(*) begin
        // Default: blank all digits.
        Anode_activate = 4'b1111;
        selected_seg = 7'b1111111;

        case (digit_select)
            2'd0: begin
                // Blank the seconds digits (0 and 1) when adj=1, sel=1, and blink_state=1
                Anode_activate = (adj && sel && blink_state) ? 4'b1111 : 4'b1110;
                selected_seg = seg0;
            end

            2'd1: begin
                Anode_activate = (adj && sel && blink_state) ? 4'b1111 : 4'b1101;
                selected_seg = seg1;
            end

            2'd2: begin
                // Blank the minutes digits (2 and 3) when adj=1, sel=0, and blink_state=1
                Anode_activate = (adj && !sel && blink_state) ? 4'b1111 : 4'b1011;
                selected_seg = seg2;
            end

            2'd3: begin
                Anode_activate = (adj && !sel && blink_state) ? 4'b1111 : 4'b0111;
                selected_seg = seg3;
            end

            default: begin
                Anode_activate = 4'b1111;
                selected_seg = 7'b1111111;
            end
        endcase

        // Reverse bit order to match the supplied Basys 3 XDC:
        // seg[0] maps to segment A, seg[1] to B, ... seg[6] to G.
        LED_out = {
            selected_seg[0],
            selected_seg[1],
            selected_seg[2],
            selected_seg[3],
            selected_seg[4],
            selected_seg[5],
            selected_seg[6]
        };
    end
endmodule