module tt_um_cfar_nobuzzer (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // Combine inputs
    wire [13:0] adc_data;
    assign adc_data = {uio_in[5:0], ui_in};

    // Safe input (no X propagation)
    wire [13:0] safe_signal;
    assign safe_signal = (ena && rst_n) ? adc_data : 14'd0;

    // Simple detection logic
    wire detect;
    assign detect = (safe_signal > 14'd100);

    // Example output (you can customize)
    wire [7:0] out_internal;
    assign out_internal = {detect, 7'b0000000};

    // 🚨 CRITICAL FIX: ALWAYS DRIVE OUTPUT
    assign uo_out = (ena && rst_n) ? out_internal : 8'b0;

    // No bidirectional usage
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
