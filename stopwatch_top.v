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

    // --------------------------------------------------
    // 0. Synchronize and Debounce Inputs
    // --------------------------------------------------
    reg [1:0] rst_sync;
    reg [3:0] pause_shf, sel_shf, adj_shf;
    reg pause_deb, sel_deb, adj_deb;

    // Basic 2-stage synchronizer for reset to prevent metastability
    always @(posedge clk) begin
        rst_sync <= {rst_sync[0], btnC};
    end
    wire rst_clean = rst_sync[1];

    // Shift registers for debouncing, sampled at the tick_scan rate
    always @(posedge clk) begin
        if (rst_clean) begin
            pause_shf <= 4'd0; sel_shf <= 4'd0; adj_shf <= 4'd0;
            pause_deb <= 1'b0; sel_deb <= 1'b0; adj_deb <= 1'b0;
        end else if (tick_scan) begin
            pause_shf <= {pause_shf[2:0], btnU};
            sel_shf   <= {sel_shf[2:0], sw[0]};
            adj_shf   <= {adj_shf[2:0], sw[1]};
            
            // Only register a change if all samples match (stable signal)
            if (pause_shf == 4'b1111) pause_deb <= 1'b1; else if (pause_shf == 4'b0000) pause_deb <= 1'b0;
            if (sel_shf == 4'b1111) sel_deb <= 1'b1; else if (sel_shf == 4'b0000) sel_deb <= 1'b0;
            if (adj_shf == 4'b1111) adj_deb <= 1'b1; else if (adj_shf == 4'b0000) adj_deb <= 1'b0;
        end
    end

    // Internal signals
    wire tick_scan;
    wire tick_1hz;
    wire tick_2hz;
    wire tick_blink;
    wire [3:0] sec_ones, sec_tens, min_ones, min_tens;
    wire [6:0] seg0, seg1, seg2, seg3;

    // --------------------------------------------------
    // 1. Generate the 1 ms display scan pulse
    // --------------------------------------------------
    clock_divider u_clock_divider (
        .clk(clk),
        .rst(rst_clean),
        .tick_scan(tick_scan),
        .tick_1hz(tick_1hz),
        .tick_2hz(tick_2hz),
        .tick_blink(tick_blink)
    );

    // --------------------------------------------------
    // 2. Stopwatch counter
    // --------------------------------------------------
    stopwatch_counter u_stopwatch_counter (
        .clk(clk),
        .rst(rst_clean),
        .tick_1hz(tick_1hz),
        .tick_2hz(tick_2hz),
        .adj(adj_deb),
        .sel(sel_deb),
        .pause(pause_deb),
        .sec_ones(sec_ones),
        .sec_tens(sec_tens),
        .min_ones(min_ones),
        .min_tens(min_tens)
    );

    // --------------------------------------------------
    // 3. Convert BCD digits to seven-segment patterns
    // --------------------------------------------------
    bin_to_7seg u_bin_to_7seg (
        .digit0(sec_ones),
        .digit1(sec_tens),
        .digit2(min_ones),
        .digit3(min_tens),
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
        .rst(rst_clean),
        .seg0(seg0),
        .seg1(seg1),
        .seg2(seg2),
        .seg3(seg3),
        .tick_scan(tick_scan),
        .tick_blink(tick_blink),
        .adj(adj_deb),
        .sel(sel_deb),
        .Anode_activate(an),
        .LED_out(seg)
    );

endmodule