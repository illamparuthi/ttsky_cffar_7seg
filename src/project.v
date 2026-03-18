module tt_um_cfar_nobuzzer (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire       ena,      
    input  wire       clk,      
    input  wire       rst_n     
);

    // Combine inputs to form 14-bit ADC data [cite: 13]
    wire [13:0] adc_data;
    assign adc_data = {uio_in[5:0], ui_in}; 
    
    wire detect_val;
    wire [3:0] bcd_val;
    wire [6:0] segments;

    // Instantiate CFAR Core
    cfar_core cfar_inst (
        .clk(clk),
        .rst_n(rst_n),
        .signal(adc_data),
        .detect(detect_val),
        .bcd_out(bcd_val)
    );

    // Instantiate BCD to 7-Segment Decoder
    bcd_to_7seg display_inst (
        .bcd(bcd_val),
        .seg(segments)
    );

    // Map outputs: [7] is detection, [6:0] are segments
    assign uo_out = {detect_val, segments}; [cite: 18]

    // Configure uio as inputs
    assign uio_out = 8'b0; [cite: 19]
    assign uio_oe  = 8'b0; 

endmodule
