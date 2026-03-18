module bcd_to_7seg (
    input [3:0] bcd,
    output reg [6:0] seg
);
    always @(*) begin
        case (bcd)
            4'd0:    seg = 7'b1000000; // Displays '0' 
            4'd1:    seg = 7'b1111001; // Displays '1' [cite: 3]
            default: seg = 7'b1111111; // All OFF
        endcase
    end
endmodule
