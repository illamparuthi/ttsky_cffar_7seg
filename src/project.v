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

    wire [13:0] adc_data;
    assign adc_data = {uio_in[5:0], ui_in};

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    wire detect;
    wire [3:0] bcd;

    // Optional: gate logic using ena (recommended)
    wire [13:0] signal = ena ? adc_data : 14'd0;

    cfar_core cfar_inst (
        .clk(clk),
        .rst_n(rst_n),
        .signal(signal),
        .detect(detect),
        .bcd_out(bcd)
    );

    bcd_to_7seg seg_inst (
        .bcd(bcd),
        .seg(uo_out[6:0])
    );

    assign uo_out[7] = detect;

endmodule
