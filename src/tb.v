`default_nettype none
`timescale 1ns / 1ps

module tb ();

  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
    #1;
  end

  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  initial clk = 0;
  always #5 clk = ~clk;

  tt_um_cwru_cpu user_project (
      .ui_in  (ui_in),
      .uo_out (uo_out),
      .uio_in (uio_in),
      .uio_out(uio_out),
      .uio_oe (uio_oe),
      .ena    (ena),
      .clk    (clk),
      .rst_n  (rst_n)
  );

  // decode common-anode seg code to digit character
  task automatic decode_seg;
    input [6:0] seg;
    output reg [7:0] ch; // ASCII character
    begin
      case (seg)
        7'b1111110: ch = "0";
        7'b0110000: ch = "1";
        7'b1101101: ch = "2";
        7'b1111001: ch = "3";
        7'b0110011: ch = "4";
        7'b1011011: ch = "5";
        7'b1011111: ch = "6";
        7'b1110000: ch = "7";
        7'b1111111: ch = "8";
        7'b1111011: ch = "9";
        7'b0000000: ch = " "; // blank
        default:    ch = "?";
      endcase
    end
  endtask

  task automatic print_display;
    reg [6:0] seg;
    reg [3:0] ade;
    reg [7:0] ch;
    integer   digit_pos;
    begin
      seg = user_project.uo_out[6:0];
      ade = user_project.uio_out[3:0];

      decode_seg(seg, ch);

      case (ade)
        4'b1110: digit_pos = 0; // rightmost
        4'b1101: digit_pos = 1;
        4'b1011: digit_pos = 2;
        4'b0111: digit_pos = 3; // leftmost
        default: digit_pos = -1;
      endcase

      $display(">>> SEG at t=%0t  seg=7'b%b  digit=%s  anode_pos=%0d",
        $time, seg, ch, digit_pos);
    end
  endtask

  initial begin
    ena    = 1;
    ui_in  = 8'h00;
    uio_in = 8'h00;
    rst_n  = 0;

    repeat(4) @(posedge clk);
    rst_n = 1;

    repeat(500) @(posedge clk);
    $finish;
  end

  initial $display("time\t\tpc\t\tinstr\t\tx1\t\tx2\t\tx3\t\tx4");

  always @(posedge clk) begin
    if (rst_n) begin
      $display("%0t\t\t%h\t\t%h\t\t%h\t\t%h\t\t%h\t\t%h",
        $time,
        user_project.pc_out,
        user_project.current_instruction,
        user_project.rf.registers[1],
        user_project.rf.registers[2],
        user_project.rf.registers[3],
        user_project.rf.registers[4]
      );
    end
  end

  always @(posedge clk) begin
    if (rst_n && user_project.current_instruction[6:0] == 7'h7F) begin
      $display(">>> PRINT at t=%0t  x1 = %0d", $time, user_project.rf.registers[1]);
      print_display();
    end
  end

  always @(posedge clk) begin
    if (rst_n && user_project.current_instruction[6:0] == 7'h63) begin
      $display("BRANCH: pc=%h imm=%h pc_branch=%h branch_eq=%b zero=%b taken=%b",
        user_project.pc_out,
        user_project.immediate,
        user_project.pc_branch,
        user_project.branch_eq,
        user_project.zero_flag,
        user_project.branch_taken
      );
    end
  end

  // log any seg change outside of print instructions
  always @(uo_out or uio_out) begin
    if (rst_n) begin
      print_display();
    end
  end

endmodule