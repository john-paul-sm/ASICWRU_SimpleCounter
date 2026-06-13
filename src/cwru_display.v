module cwru_display (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        display,
    input  wire [31:0] val,
    output reg  [6:0]  seg,
    output reg         ade
);
    always @(posedge clk) begin
        if (~rst_n || !display) begin
            seg <= 7'b0000001;
            ade <= 1'b1;
        end else begin
            case (val % 10)
                4'd0: seg <= 7'b1111110;
                4'd1: seg <= 7'b0110000;
                4'd2: seg <= 7'b1101101;
                4'd3: seg <= 7'b1111001;
                4'd4: seg <= 7'b0110011;
                4'd5: seg <= 7'b1011011;
                4'd6: seg <= 7'b1011111;
                4'd7: seg <= 7'b1110000;
                4'd8: seg <= 7'b1111111;
                default: seg <= 7'b1111011;
            endcase
            ade <= 1'b1;
        end
    end
endmodule