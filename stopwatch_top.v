`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2026 01:22:20 PM
// Design Name: 
// Module Name: stopwatch_top
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

module stopwatch_top(
    input wire clk,           // 100 MHz Basys 3 clock
    input wire btnC,          // Reset button
    input wire btnU,          // Pause button
    input wire [1:0] sw,       // sw[0] = SEL, sw[1] = ADJ
    output wire [6:0] seg,     // Seven-segment outputs
    output wire [3:0] an       // Four digit anodes
);

    // Internal signals
    wire tick_scan;
    wire tick_1hz;
    wire tick_2hz;
    wire [5:0] minutes;
    wire [5:0] seconds;

    wire [15:0] display_value;
    wire [6:0] seg0, seg1, seg2, seg3;

    // Map switches to control signals
    wire sel = sw[0];
    wire adj = sw[1];

    // --------------------------------------------------
    // 1. Generate the 1 ms display scan pulse
    // --------------------------------------------------
    clock_divider u_clock_divider (
        .clk(clk),
        .rst(btnC),
        .tick_scan(tick_scan),
        .tick_1hz(tick_1hz),
        .tick_2hz(tick_2hz)
    );

    // --------------------------------------------------
    // 2. Stopwatch counter
    // --------------------------------------------------
    stopwatch_counter u_stopwatch_counter (
        .clk(clk),
        .rst(btnC),
        .tick_1hz(tick_1hz),
        .tick_2hz(tick_2hz),
        .adj(adj),
        .sel(sel),
        .pause(btnU),
        .seconds(seconds),
        .minutes(minutes)
    );

    // --------------------------------------------------
    // 3. Convert MMSS into a decimal number
    // Example: 12 minutes, 34 seconds -> 1234
    // --------------------------------------------------
    assign display_value = (minutes * 16'd100) + seconds;

    bin_to_7seg u_bin_to_7seg (
        .binary_in(display_value),
        .seg0(seg0),
        .seg1(seg1),
        .seg2(seg2),
        .seg3(seg3)
    );

    // --------------------------------------------------
    // 4. Multiplex the four seven-segment digits
    // --------------------------------------------------
    seven_segment u_seven_segment (
        .clk(clk),
        .rst(btnC),
        .seg0(seg0),
        .seg1(seg1),
        .seg2(seg2),
        .seg3(seg3),
        .tick_scan(tick_scan),
        .Anode_activate(an),
        .LED_out(seg)
    );

endmodule
