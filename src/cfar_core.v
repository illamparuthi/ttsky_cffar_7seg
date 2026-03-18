module cfar_core (
    input clk,
    input rst_n,
    input [13:0] signal,
    output reg detect,
    output reg [3:0] bcd_out
);
    reg [13:0] threshold;
    
    // CFAR parameters
    localparam [3:0] GAIN = 4'd2; // Signal must be > 2x average to detect

    always @(posedge clk) begin
        if (!rst_n) begin
            threshold <= 14'd100; // Initial noise floor [cite: 5, 15]
            detect    <= 1'b0; [cite: 6]
            bcd_out   <= 4'd0; [cite: 7]
        end else begin
            // Simplified Cell Averaging (CA-CFAR)
            // threshold = (previous_threshold + current_signal) / 2
            threshold <= (threshold + signal) >> 1; [cite: 7]

            // Detection logic with scaling
            // Multiplying average by GAIN to create a gap above the noise
            if (signal > (threshold * GAIN)) begin [cite: 8]
                detect  <= 1'b1; [cite: 8]
                bcd_out <= 4'd1; // Display '1' on 7-seg [cite: 9]
            end else begin
                detect  <= 1'b0; [cite: 10]
                bcd_out <= 4'd0; // Display '0' on 7-seg [cite: 10]
            end
        end
    end
endmodule
