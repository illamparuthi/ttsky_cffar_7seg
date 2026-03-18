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

    // Internal wires
    wire [13:0] adc_data;
    wire detect_val;
    wire [3:0] bcd_val;
    wire [6:0] segments;

    // 14-bit ADC reconstruction: {uio_in[5:0], ui_in[7:0]}
    assign adc_data = {uio_in[5:0], ui_in}; [cite: 13]

    // Core CFAR Instance
    cfar_core cfar_inst (
        .clk(clk),
        .rst_n(rst_n),
        .signal(adc_data),
        .detect(detect_val),
        .bcd_out(bcd_val)
    );

    // BCD to Display Instance
    bcd_to_7seg display_inst (
        .bcd(bcd_val),
        .seg(segments)
    );

    // Outputs
    assign uo_out  = {detect_val, segments}; [cite: 17]
    assign uio_out = 8'b0; [cite: 19]
    assign uio_oe  = 8'b0; [cite: 19]

endmodule
