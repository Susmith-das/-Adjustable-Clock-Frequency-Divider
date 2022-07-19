`include "reg_size.v"

module odd_divider(
    input clk,					// fast input clock
	input [`SIZE-1:0] N,		// divide clock by factor 'N'
	input reset,				// asynchronous reset
	input enable,				// enable the odd divider
    output out					// slow divided clock
    );
	
    wire[`SIZE-2:0] ton;
    wire[`SIZE-2:0] toff;
	reg [`SIZE-2:0] counter;	 
	reg posedge_count;			// positive edge triggered counter
	reg negedge_count;			// negative edge triggered counter
    reg round_robin_counter;

	assign out = (enable) ? (posedge_count | negedge_count) : 1'hz; // or to generate 50% duty, half-period

	assign ton  = N[`SIZE-1:1]; // on period of pulse  [(N-1)/2]
	assign toff = ton+1'b1;		// off period of pulse [(N+1)/2]
    
	// odd counter with duty cycle less than 50%
	always @(posedge reset or posedge clk)
	begin
		if(reset)						 // asynch. reset the counter at system reset
		begin
			counter				<= 1;
            round_robin_counter <= 1'b0;
			posedge_count       <= 1'b0;
		end
		else if(enable)					// only use switching power if enabled
		begin
			if(counter == 1)			// divide after counter has reached bottom
			begin						// of interval 'N' which will be value '1'
				counter 			 <= (round_robin_counter)? toff: ton;
				round_robin_counter  <= ~round_robin_counter;
				posedge_count 	 	 <= ~posedge_count;
			end
            else
                counter <= counter-1;
		end
	end

	//delay FF with negative edge clock.
	always @(negedge clk or posedge reset)
	begin
		if(reset)								// asynch. reset the counter at system reset
		begin										
			negedge_count <= 0;
		end
		else if(enable)
		begin
			negedge_count <= posedge_count;
		end
	end

endmodule
