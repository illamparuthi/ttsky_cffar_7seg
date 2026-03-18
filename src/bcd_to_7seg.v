`default_nettype none

module bcd_to_7seg (
    input  wire [3:0] bcd,
    output reg  [6:0] seg
);
    always @(*) begin
        case (bcd)
            4'd0:    seg = 7'b1000000; 
            4'd1:    seg = 7'b1111001; 
            default: seg = 7'b1111111; 
        endcase
    end
endmodule
