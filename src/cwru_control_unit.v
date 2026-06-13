module cwru_control_unit (
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,

    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg branch_eq,
    output reg mem_to_reg,
    output reg alu_src,
    output reg [3:0] alu_cont,
    output reg jump,
    output reg display
);

    // local parameters in binary for the different instruction types, functions
    // and ALU values for simplification


    localparam OPCODE_R_TYPE = 7'b0110011;
    localparam OPCODE_I_ALU = 7'b0010011;
    localparam OPCODE_I_JALR = 7'b1100111;
    localparam OPCODE_I_LOAD = 7'b0000011;
    localparam OPCODE_S_TYPE = 7'b0100011;
    localparam OPCODE_B_TYPE = 7'b1100011;
    localparam OPCODE_U_LUI = 7'b0110111;
    localparam OPCODE_U_AUIPC = 7'b0010111;
    localparam OPCODE_J_TYPE = 7'b1101111;
    localparam OPCODE_PRINT = 7'b1111111;

    localparam FUNCT3_ADD_SUB = 3'b000;
    localparam FUNCT3_SLL = 3'b001;
    localparam FUNCT3_SRL = 3'b101;
    localparam FUNCT3_SLT = 3'b010;
    localparam FUNCT3_AND = 3'b111;
    localparam FUNCT3_OR = 3'b110;
    localparam FUNCT3_XOR = 3'b100;

    localparam FUNCT7_ADD = 7'b0000000;
    localparam FUNCT7_SUB = 7'b0100000;
    
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
        
        // default values; all asserted to low (0) and ALU asserted to ALU_ADD 
        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        branch_eq = 1'b0;
        mem_to_reg = 1'b0;
        alu_src = 1'b0;
        alu_cont = ALU_ADD;
        jump = 1'b0;
        display = 1'b0;

        case (opcode)
        // R-Type
        OPCODE_R_TYPE: begin
            reg_write = 1'b1;
            case (funct3)
                FUNCT3_ADD_SUB: begin // add or sub
                    case (funct7) 
                        FUNCT7_ADD: alu_cont = ALU_ADD;// add
                        FUNCT7_SUB: alu_cont = ALU_SUB; // sub
                        default: alu_cont = ALU_ADD; // add
                    endcase
                end
                FUNCT3_AND: alu_cont = ALU_AND; // and
                FUNCT3_OR: alu_cont = ALU_OR; // or
                FUNCT3_XOR: alu_cont = ALU_XOR; // xor
                FUNCT3_SLL: alu_cont = ALU_SLL; // sll
                FUNCT3_SRL: alu_cont = ALU_SRL; // srl
                FUNCT3_SLT: alu_cont = ALU_SLT; // slt
                default: alu_cont = ALU_ADD;
            endcase
        end

        // I-Type (ALU)
        OPCODE_I_ALU: begin
            reg_write = 1'b1;
            alu_src = 1'b1;
            case (funct3)
                FUNCT3_ADD_SUB: alu_cont = ALU_ADD; // addi
                FUNCT3_AND: alu_cont = ALU_AND; // andi
                FUNCT3_OR: alu_cont = ALU_OR; // ori
                FUNCT3_XOR: alu_cont = ALU_XOR; // xori
                FUNCT3_SLL: alu_cont = ALU_SLL; // slli
                FUNCT3_SLT: alu_cont = ALU_SLT; // slti
                default: alu_cont = ALU_ADD;
            endcase
        end

        // I-Type (Load)
        OPCODE_I_LOAD: begin
            reg_write = 1'b1;
            alu_src = 1'b1;
            mem_read = 1'b1;
            mem_to_reg = 1'b1;
            alu_cont = ALU_ADD;
        end

        // I-Type (Jump and Link)
        OPCODE_I_JALR: begin
            reg_write = 1'b1;
            alu_src = 1'b1;
            jump = 1'b1;
            alu_cont = ALU_ADD;
        end

        // S-Type
        OPCODE_S_TYPE: begin
            alu_src = 1'b1;
            mem_write = 1'b1;
            alu_cont = ALU_ADD;
        end

        // B-Type
        OPCODE_B_TYPE: begin
            branch_eq = 1'b1;
            alu_cont = ALU_SUB;
        end

        // U-Type (Load Upper Immediate)
        OPCODE_U_LUI: begin
            reg_write = 1'b1;
            alu_src = 1'b1;
            alu_cont = ALU_LUI;
        end

        // U-Type (Add Upper Immediate to Program Counter)
        OPCODE_U_AUIPC: begin
            reg_write = 1'b1;
            alu_src = 1'b1;
            alu_cont = ALU_AUIPC;
        end

        // J-Type
        OPCODE_J_TYPE: begin
            reg_write = 1'b1;
            jump = 1'b1;
        end

        // Custom-defined print opcode
        OPCODE_PRINT: begin
            display = 1'b1;
        end
        
        default: begin
        // keeps default values, all asserted to 0 and ALU asserted to ALU_ADD 
        end
        endcase
    end
endmodule