module cfar_core (
    input wire clk,
    input wire rst_n,
    input wire [13:0] signal,
    output reg detect,
    output reg [3:0] bcd_out
);
    reg [13:0] threshold;
    localparam [3:0] GAIN = 4'd2; 

    always @(posedge clk) begin
        if (!rst_n) begin
            threshold <= 14'd100; [cite: 5, 6]
            detect    <= 1'b0; [cite: 6]
            bcd_out   <= 4'd0; [cite: 7]
        end else begin
            // Adaptive threshold update
            threshold <= (threshold + signal) >> 1; [cite: 7]

            // Comparison logic
            if (signal > (threshold * GAIN)) begin
                detect  <= 1'b1; [cite: 8]
                bcd_out <= 4'd1; [cite: 9]
            end else begin
                detect  <= 1'b0; [cite: 9]
                bcd_out <= 4'd0; [cite: 10]
            end
        end
    end
endmodule
