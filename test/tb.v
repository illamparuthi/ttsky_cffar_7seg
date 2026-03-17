`timescale 1ns/1ps

module tb;

reg clk = 0;
reg rst_n = 0;

reg [7:0] ui_in;
reg [7:0] uio_in;

wire [7:0] uo_out;
wire [7:0] uio_out;
wire [7:0] uio_oe;

tt_um_cfar_nobuzzer dut (
    .ui_in(ui_in),
    .uo_out(uo_out),
    .uio_in(uio_in),
    .uio_out(uio_out),
    .uio_oe(uio_oe),
    .clk(clk),
    .rst_n(rst_n)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb);

    rst_n = 0;
    #20;
    rst_n = 1;

    // Low signal
    ui_in = 8'd10;
    uio_in = 8'd0;
    #50;

    // High signal (should detect)
    ui_in = 8'd200;
    uio_in = 8'd0;
    #50;

    $finish;
end

endmodule
