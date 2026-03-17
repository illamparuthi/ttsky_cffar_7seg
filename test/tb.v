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
    .ena(1'b1),
    .clk(clk),
    .rst_n(rst_n)
);

// Clock
always #5 clk = ~clk;

// ✅ KEY FIX: initialize inputs
initial begin
    ui_in  = 8'd0;
    uio_in = 8'd0;
    rst_n  = 1'b0;

    #20;
    rst_n = 1'b1;
end

// Dump waves
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb);
end

endmodule
