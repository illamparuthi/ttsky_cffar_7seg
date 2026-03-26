`default_nettype none

module cfar_core (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [13:0] signal,
    output reg         detect,
    output reg  [3:0]  bcd_out
);
    reg [13:0] threshold;
    reg [22:0] stretch_timer; // 23 bits to hold up to 5,000,000

    localparam [3:0] GAIN = 4'd2; 
    
    // 5,000,000 cycles at 50MHz = ~0.1 seconds of LED on-time
    localparam [22:0] STRETCH_CYCLES = 23'd5_000_000; 

    always @(posedge clk) begin
        if (!rst_n) begin
            threshold     <= 14'd100;
            detect        <= 1'b0;
            bcd_out       <= 4'd0;
            stretch_timer <= 23'd0;
        end else begin
            
            // 1. Detection & Pulse Stretching Logic
            if (signal > (threshold * GAIN)) begin
                // Target detected: Turn ON display and reset the timer
                detect        <= 1'b1;
                bcd_out       <= 4'd1;
                stretch_timer <= STRETCH_CYCLES;
            end else if (stretch_timer > 0) begin
                // Target gone, but keep display ON for human visibility
                stretch_timer <= stretch_timer - 1'b1;
                detect        <= 1'b1;
                bcd_out       <= 4'd1;
            end else begin
                // Timer expired: Turn OFF display
                detect        <= 1'b0;
                bcd_out       <= 4'd0;
            end

            // 2. Threshold Freeze Logic
            // Only update the noise floor if the RAW signal is not a target
            if (signal <= (threshold * GAIN)) begin
                threshold <= (threshold + signal) >> 1;
            end
            
        end
    end
endmodule
