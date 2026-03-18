module cfar_core (
    input clk,
    input rst_n,
    input [13:0] signal,
    output reg detect,
    output reg [3:0] bcd_out
);
    reg [13:0] threshold;
    
    // Using a parameter for detection scaling
    localparam [3:0] GAIN = 4'd2; 

    always @(posedge clk) begin
        if (!rst_n) begin
            threshold <= 14'd100;
            detect    <= 1'b0;
            bcd_out   <= 4'd0;
        end else begin
            // Update threshold (Running average)
            threshold <= (threshold + signal) >> 1; [cite: 7]

            // Detection logic
            if (signal > (threshold * GAIN)) begin [cite: 8]
                detect  <= 1'b1; [cite: 9]
                bcd_out <= 4'd1;
            end else begin
                detect  <= 1'b0; [cite: 10]
                bcd_out <= 4'd0;
            end
        end
    end
endmodule
