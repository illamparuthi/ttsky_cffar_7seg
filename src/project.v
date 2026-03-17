`default_nettype none
module tt_um_cfar_nobuzzer (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire ena,
    input  wire clk,
    input  wire rst_n
);

    // Combine 14-bit ADC input
    wire [13:0] adc_data;
    assign adc_data = {uio_in[5:0], ui_in};

    // ✅ Prevent X propagation (GL-safe)
    wire [13:0] safe_signal;
    assign safe_signal = (ena && rst_n) ? adc_data : 14'd0;

    // Set bidirectional pins as input
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    wire detect;
    wire [3:0] bcd;
    wire [6:0] seg;

    // CFAR core
    cfar_core cfar_inst (
        .clk(clk),
        .rst_n(rst_n),
        .signal(safe_signal),
        .detect(detect),
        .bcd_out(bcd)
    );

    // 7-segment decoder
    bcd_to_7seg seg_inst (
        .bcd(bcd),
        .seg(seg)
    );

    // Output assignment (GL-safe reset behavior)
    assign uo_out = rst_n ? {detect, seg} : 8'b0;

endmodule
