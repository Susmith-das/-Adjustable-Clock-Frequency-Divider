`include "reg_size.v"

module even_divider(
    input clk,				// fast input clock
	input [`SIZE-1:0] N,	// divide clock by factor 'N'
	input reset,			// asynchronous reset
	input enable,			// enable the even divider
    output out  			// slower divided clock
    );

	wire[`SIZE-2:0] divN_2;
	reg [`SIZE-2:0] counter;
	reg out_count;

	assign out 	  = (enable) ? out_count : 1'hz;
	assign divN_2 = N[`SIZE-1:1];

	// simple flip-flop even divider
	always @(posedge reset or posedge clk)
	begin
		if(reset)						// asynch. reset
		begin
			counter   <= 1;
			out_count <= 1'b0;
		end
		else if(enable)			// only use switching power if enabled
		begin
			if(counter == 1)			// divide after counter has reached bottom
			begin						// of interval 'N' which will be value '1'
				counter <= divN_2;
				out_count <= ~out_count;
			end
			else
			begin						// decrement the counter and wait
				counter <= counter-1;	// to start next trasition.
			end
		end
	end

endmodule 