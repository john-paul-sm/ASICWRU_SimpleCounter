module cwru_imm_gen # (
    parameter WIDTH = 32
)(
    input wire[WIDTH-1:0] instruction,
    output reg[WIDTH-1:0] immediate
);
    // define your logic starting here
    wire[6:0] opcode;
    
    // determine opcode of current instruction
    assign opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            // I-type
            7'b0010011,
            7'b0000011,
            7'b1100111:
                immediate <= {{20{instruction[31]}}, instruction[31:20]};
            // S-type: SW
            7'b0100011:
                immediate <= {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            
            // B-type
            7'b1100011:
            immediate <= {{19{instruction[31]}},
                        instruction[31],
                        instruction[7],
                        instruction[30:25],
                        instruction[11:8],
                        1'b0};

            // U-type 
            7'b0110111, 
            7'b0010111: 
                immediate <= {instruction[31:12], 12'b0};
    
            // J-type
            7'b1101111:
                immediate <= {{11{instruction[31]}},
                            instruction[31],
                            instruction[19:12],
                            instruction[20],
                            instruction[30:21],
                            1'b0}; 
            default:
                immediate <= 32'b0;
        endcase
    end

endmodule