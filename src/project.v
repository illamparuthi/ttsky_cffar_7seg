module tt_um_cfar_nobuzzer (
    input  wire [7:0] ui_in,    // ADC bits [7:0] [cite: 12]
    output wire [7:0] uo_out,   // [7]: Detect, [6:0]: 7-seg [cite: 12]
    input  wire [7:0] uio_in,   // uio_in[5:0]: ADC bits [13:8] [cite: 12]
    output wire [7:0] uio_out,  // Unused [cite: 12]
    output wire [7:0] uio_oe,   // Set to 0 for input mode [cite: 12]
    input  wire       ena,      // Power enable [cite: 12]
    input  wire       clk,      // System clock [cite: 12]
    input  wire       rst_n     // Active low reset [cite: 12]
);

    // 1. Reconstruct 14-bit Signal [cite: 13]
    wire [13:0] adc_raw = {uio_in[5:0], ui_in[7:0]};
    
    // 2. Internal Wires
    wire detect_signal;
    wire [3:0] bcd_signal;
    wire [6:0] seg_signal;

    // 3. Instantiate Core Logic
    cfar_core cfar_inst (
        .clk(clk),
        .rst_n(rst_n),
        .signal(adc_raw),
        .detect(detect_signal),
        .bcd_out(bcd_signal)
    );

    // 4. Instantiate Display Decoder
    bcd_to_7seg display_inst (
        .bcd(bcd_signal),
        .seg(seg_signal)
    );

    // 5. Assign Outputs [cite: 17, 18]
    // uo_out[7]   = Detect Flag
    // uo_out[6:0] = 7-Segment (a-g)
    assign uo_out = {detect_signal, seg_signal};

    // 6. Configure Bidirectional Pins as Inputs [cite: 19]
    assign uio_oe  = 8'b00000000; 
    assign uio_out = 8'b00000000;

endmodule
