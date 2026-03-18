`default_nettype none

module cfar_core (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [13:0] signal,
    output reg         detect,
    output reg  [3:0]  bcd_out
);
    reg [13:0] threshold;
    localparam [3:0] GAIN = 4'd2; 

    always @(posedge clk) begin
        if (!rst_n) begin
            threshold <= 14'd100;
            detect    <= 1'b0;
            bcd_out   <= 4'd0;
        end else begin
            threshold <= (threshold + signal) >> 1;

            if (signal > (threshold * GAIN)) begin
                detect  <= 1'b1;
                bcd_out <= 4'd1;
            end else begin
                detect  <= 1'b0;
                bcd_out <= 4'd0;
            end
        end
    end
endmodule
