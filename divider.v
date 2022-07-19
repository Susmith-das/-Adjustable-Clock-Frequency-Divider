`include "reg_size.v"

module N_divider(
    input ref_clk,			// reference clock
	input enable,			// enable module
	input [`SIZE-1:0] N,	// the number to be divided by
	input reset,			// asynchronous reset
	output div_clk			// divided output clock
    );
	
	wire clk;				// gated clock
	wire out_odd;			// output of odd divider
	wire out_even;			// output of even divider
	wire exception;			// signal to find divide by 0 or 1 case
	wire enable_even;		// enable of even divider
	wire enable_odd;		// enable of odd divider
	reg q_en;				// latched enable

	assign clk = ref_clk & q_en;	// clock gating

	assign exception = ~| N[`SIZE-1:1];	

	assign div_clk = (enable)? ( (exception)? ref_clk : ( N[0] ? out_odd : out_even ) ) : 1'hz; //tristated output

	assign enable_odd  =  N[0] & !exception;
	assign enable_even = ~N[0] & !exception;

	even_divider E(clk, N, reset, enable_even, out_even);  //Even divider
	odd_divider  O(clk, N, reset, enable_odd, out_odd);   // Odd divider

	always@(negedge ref_clk or posedge reset)  // latching enable
	begin
	   q_en <= (reset)? 1'b0 : enable ;
	end
	
endmodule