module cwru_data_mem # (
    parameter WIDTH = 32,
    parameter DEPTH = 256
)(
    input wire clk,
    input wire rst_n,
    input wire[WIDTH-1:0] addr,
    input wire[WIDTH-1:0] wr_data,

    // control flags
    input mem_read,
    input mem_write,

    // output res
    output[WIDTH-1:0] mem_data
);

    // define your logic starting her
    // 256 words of memory, each word is 32 bits wide
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (integer i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {WIDTH{1'b0}};
        end
        else begin
            if (mem_write) begin
                mem[addr[9:2]] <= wr_data;
            end
        end
    end
    assign mem_data = (mem_read) ? mem[addr[9:2]] : {WIDTH{1'b0}};
endmodule