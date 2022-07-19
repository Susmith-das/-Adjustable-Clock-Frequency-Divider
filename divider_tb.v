`timescale 1ns/1ns
`include "reg_size.v"

module divider_testbench;

reg clk,rst,en;
wire div_clk;

reg[`SIZE-1:0] N;

N_divider DIV(.ref_clk(clk), .enable(en), .N(N), .reset(rst), .div_clk(div_clk));

initial 
begin
  rst=0;
  #2 rst=1;
  #2 rst=0;
end

initial
begin
  clk=0;
  forever #5 clk=~clk;
end  

initial
begin
 /* N=0;en=1;
  #50 N=1;
  #1 rst=1;
  #2 rst=0;
  #50 N=2;
  #1 rst=1;
  #2 rst=0;
  #100 N=3;
  #1 rst=1; en=0;
  #2 rst=0;
  #150 N=4;
  #1 rst=1; en=1;
  #2 rst=0;
  #200 N=5;
  #1 rst=1;
  #2 rst=0;
  #250 N=6;
  #1 rst=1; en=0;
  #2 rst=0;
  #300 N=7;
  #1 rst=1;
  #2 rst=0;
  #350 N=8;
  #1 rst=1; en=1;
  #2 rst=0;
  #400 N=9;
  #1 rst=1;
  #2 rst=0;
  #450 N=10;
  #1 rst=1;
  #2 rst=0;*/
 
      N=1;
  #1  en=1;
  #50 N=2; rst=1; en=0;
  #2  rst=0; en=1;
  #100 N=3; rst=1; en=0;
  #2  rst=0; en=1;
  #150 $finish;
end

initial
begin
  $dumpfile("graph.vcd");
  $dumpvars(0,divider_testbench);
end
endmodule