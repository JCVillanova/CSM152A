
`timescale 1ns / 1ps

module clock_divider(
    input wire clk,
    input wire rst,
    output reg tick_scan,
    output reg tick_1hz,
    output reg tick_2hz
);

    // Counters for the 100 MHz input clock
    reg [16:0] scan_count;
    reg [26:0] count_1hz;
    reg [25:0] count_2hz;

    always @(posedge clk) begin
        if (rst) begin
            scan_count <= 0;
            count_1hz <= 0;
            count_2hz <= 0;

            tick_scan <= 0;
            tick_1hz <= 0;
            tick_2hz <= 0;
        end
        else begin

            // Display scan: pulse every 1 ms
            if (scan_count == 17'd99999) begin
                scan_count <= 0;
                tick_scan <= 1'b1;
            end
            else begin
                scan_count <= scan_count + 1'b1;
                tick_scan <= 1'b0;
            end

            // Normal stopwatch count: pulse every 1 second
            if (count_1hz == 27'd99999999) begin
                count_1hz <= 0;
                tick_1hz <= 1'b1;
            end
            else begin
                count_1hz <= count_1hz + 1'b1;
                tick_1hz <= 1'b0;
            end

            // Adjustment: pulse every 0.5 seconds (2 Hz)
            if (count_2hz == 26'd49999999) begin
                count_2hz <= 0;
                tick_2hz <= 1'b1;
            end
            else begin
                count_2hz <= count_2hz + 1'b1;
                tick_2hz <= 1'b0;
            end

        end
    end

endmodule
