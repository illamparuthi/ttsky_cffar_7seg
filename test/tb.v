`timescale 1ns/1ps

module tb;

    // Signal Declarations
    reg clk;
    reg rst_n;
    reg [7:0] ui_in;
    reg [7:0] uio_in;
    reg ena;

    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    // Instantiate the Top Module
    tt_um_cfar_nobuzzer dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock Generation
    always begin
        #5 clk = ~clk;
    end

    // Initialization Block
    initial begin
        // Initialize all inputs
        clk    = 1'b0;
        rst_n  = 1'b0;
        ena    = 1'b1;
        ui_in  = 8'd0;
        uio_in = 8'd0;

        // Hold reset for a while
        #20;
        rst_n = 1'b1;
    end

    // Waveform Dumping
    initial begin
        $dumpfile("wave.vcd"); // Change to "tb.fst" if your Makefile expects FST
        $dumpvars(0, tb);
    end

endmodule
