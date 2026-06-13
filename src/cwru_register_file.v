module cwru_register_file # (
    parameter WIDTH = 32
)(
    input wire clk,
    input wire rst_n,
    input wire [4:0]        rd_addr1,
    input wire [4:0]        rd_addr2,
    output wire [WIDTH-1:0] rd_data1,
    output wire [WIDTH-1:0] rd_data2,
    input wire [4:0]        wr_addr,
    input wire              reg_write,
    input wire [WIDTH-1:0]  wr_data
);
    reg [WIDTH-1:0] r1,r2,r3,r4,r5,r6,r7,r8,
                    r9,r10,r11,r12,r13,r14,r15,r16,
                    r17,r18,r19,r20,r21,r22,r23,r24,
                    r25,r26,r27,r28,r29,r30,r31;
    wire we = reg_write && (wr_addr != 5'b0);
    always @(posedge clk) begin
        if (!rst_n) begin
            r1<=0; r2<=0; r3<=0; r4<=0;
            r5<=0; r6<=0; r7<=0; r8<=0;
            r9<=0; r10<=0; r11<=0; r12<=0;
            r13<=0; r14<=0; r15<=0; r16<=0;
            r17<=0; r18<=0; r19<=0; r20<=0;
            r21<=0; r22<=0; r23<=0; r24<=0;
            r25<=0; r26<=0; r27<=0; r28<=0;
            r29<=0; r30<=0; r31<=0;
        end else if (we) begin
            case (wr_addr)
                5'd1:  r1<=wr_data;  5'd2:  r2<=wr_data;
                5'd3:  r3<=wr_data;  5'd4:  r4<=wr_data;
                5'd5:  r5<=wr_data;  5'd6:  r6<=wr_data;
                5'd7:  r7<=wr_data;  5'd8:  r8<=wr_data;
                5'd9:  r9<=wr_data;  5'd10: r10<=wr_data;
                5'd11: r11<=wr_data; 5'd12: r12<=wr_data;
                5'd13: r13<=wr_data; 5'd14: r14<=wr_data;
                5'd15: r15<=wr_data; 5'd16: r16<=wr_data;
                5'd17: r17<=wr_data; 5'd18: r18<=wr_data;
                5'd19: r19<=wr_data; 5'd20: r20<=wr_data;
                5'd21: r21<=wr_data; 5'd22: r22<=wr_data;
                5'd23: r23<=wr_data; 5'd24: r24<=wr_data;
                5'd25: r25<=wr_data; 5'd26: r26<=wr_data;
                5'd27: r27<=wr_data; 5'd28: r28<=wr_data;
                5'd29: r29<=wr_data; 5'd30: r30<=wr_data;
                5'd31: r31<=wr_data;
                default: ;
            endcase
        end
    end
    function [WIDTH-1:0] read_reg;
        input [4:0] addr;
        case (addr)
            5'd1:  read_reg=r1;  5'd2:  read_reg=r2;
            5'd3:  read_reg=r3;  5'd4:  read_reg=r4;
            5'd5:  read_reg=r5;  5'd6:  read_reg=r6;
            5'd7:  read_reg=r7;  5'd8:  read_reg=r8;
            5'd9:  read_reg=r9;  5'd10: read_reg=r10;
            5'd11: read_reg=r11; 5'd12: read_reg=r12;
            5'd13: read_reg=r13; 5'd14: read_reg=r14;
            5'd15: read_reg=r15; 5'd16: read_reg=r16;
            5'd17: read_reg=r17; 5'd18: read_reg=r18;
            5'd19: read_reg=r19; 5'd20: read_reg=r20;
            5'd21: read_reg=r21; 5'd22: read_reg=r22;
            5'd23: read_reg=r23; 5'd24: read_reg=r24;
            5'd25: read_reg=r25; 5'd26: read_reg=r26;
            5'd27: read_reg=r27; 5'd28: read_reg=r28;
            5'd29: read_reg=r29; 5'd30: read_reg=r30;
            5'd31: read_reg=r31;
            default: read_reg=32'b0;
        endcase
    endfunction
    assign rd_data1 = read_reg(rd_addr1);
    assign rd_data2 = read_reg(rd_addr2);
endmodule