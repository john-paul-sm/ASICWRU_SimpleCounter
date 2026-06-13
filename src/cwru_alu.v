module cwru_alu # (
    parameter WIDTH = 32
)(
    input wire[WIDTH-1:0] op1,
    input wire[WIDTH-1:0] op2,
    input wire[WIDTH-1:0] pc,
    input wire[3:0] alu_cont,
    output reg[WIDTH-1:0] res,
    output wire zero_flag
);
    localparam reg [3:0] ALU_ADD = 4'b0000;
    localparam reg [3:0] ALU_SUB = 4'b1000;
    localparam reg [3:0] ALU_AND = 4'b0111;
    localparam reg [3:0] ALU_OR  = 4'b0110;
    localparam reg [3:0] ALU_XOR = 4'b0100;
    localparam reg [3:0] ALU_SLL = 4'b0001;
    localparam reg [3:0] ALU_SRL = 4'b1001;
    localparam reg [3:0] ALU_SLT = 4'b0010;
    localparam reg [3:0] ALU_LUI = 4'b1110;
    localparam reg [3:0] ALU_AUIPC = 4'b1101;

    always @(*) begin
        case (alu_cont)
            ALU_ADD: res = op1 + op2; // add
            ALU_SUB: res = op1 - op2; // sub
            ALU_AND: res = op1 & op2; // and
            ALU_OR: res = op1 | op2; // or
            ALU_XOR: res = op1 ^ op2; // xor
            ALU_SLT: res = ($signed(op1) < $signed(op2)) ? 1 : 0; // slt (set on less than)
            ALU_SLL: res = op1 << op2[4:0]; // sll (shift left logical)
            ALU_SRL: res = op1 >> op2[4:0]; // srl (shift right logical)
            ALU_LUI: res = op2; // load upper immediate
            ALU_AUIPC: res = pc + op2; // add upper immediate to pc

            default: res = {WIDTH{1'b0}}; // default case
        endcase
    end
    assign zero_flag = (res == 32'b0);
endmodule