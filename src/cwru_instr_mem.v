module cwru_instr_mem # (
    parameter WIDTH = 32,
    parameter DEPTH = 16
)(
    input wire[WIDTH-1:0] pc,
    output reg[WIDTH-1:0] instr
);

   reg [WIDTH-1:0] mem [0:DEPTH-1];
   integer i;
   
   initial begin
       mem[0]  = 32'h00000093;
       mem[1]  = 32'h00100113;
       mem[2]  = 32'h0000807F;
       mem[3]  = 32'h002080B3;
       mem[4]  = 32'hFF9FF06F;
        
       for (i = 5; i < DEPTH; i = i + 1)
           mem[i] = 32'h00000000;
   end
    
   always @(*) begin
        instr = mem[pc[7:2]];
    end

endmodule