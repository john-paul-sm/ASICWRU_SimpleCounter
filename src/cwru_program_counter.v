module cwru_program_counter (
    input wire clk,
    input wire [31:0] pc_in,
    output reg [31:0] pc_out
);

    always @(posedge clk) begin
    pc_out <= pc_in;
    end

endmodule
