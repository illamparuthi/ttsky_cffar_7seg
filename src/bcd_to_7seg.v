module bcd_to_7seg (
    input [3:0] bcd,
    output reg [6:0] seg // {g,f,e,d,c,b,a}
);
    always @(*) begin
        case (bcd)
            // Segments: g f e d c b a
            4'd0: seg = 7'b1000000; // Displays '0' [cite: 2]
            4'd1: seg = 7'b1111001; // Displays '1' [cite: 3]
            default: seg = 7'b1111111; // All OFF [cite: 3]
        endcase
    end
endmodule
