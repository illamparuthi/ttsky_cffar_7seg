module cfar_core (
    input clk,
    input rst_n,
    input [13:0] signal,
    output reg detect,
    output reg [3:0] bcd_out
);

    reg [13:0] threshold;

    always @(posedge clk) begin
        if (!rst_n) begin
            threshold <= 14'd50;   // smaller safe value
            detect    <= 1'b0;
            bcd_out   <= 4'd0;
        end else begin
            threshold <= (threshold + signal) >> 1;

            if (signal > threshold) begin
                detect  <= 1'b1;
                bcd_out <= 4'd1;
            end else begin
                detect  <= 1'b0;
                bcd_out <= 4'd0;
            end
        end
    end

endmodule
