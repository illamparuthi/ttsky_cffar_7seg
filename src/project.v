`default_nettype none

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

    wire [13:0] adc_data;
    wire        detect_val;
    wire [3:0]  bcd_val;
    wire [6:0]  segments;

    assign adc_data = {uio_in[5:0], ui_in};

    cfar_core cfar_inst (
        .clk(clk),
        .rst_n(rst_n),
        .signal(adc_data),
        .detect(detect_val),
        .bcd_out(bcd_val)
    );

    bcd_to_7seg display_inst (
        .bcd(bcd_val),
        .seg(segments)
    );

    assign uo_out  = {detect_val, segments};
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
