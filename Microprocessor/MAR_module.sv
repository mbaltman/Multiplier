module MAR_module (logic input [15:0] data , logic input ld, clk, reset, logic output [15:0] marout );


always_ff @ (posedge clk)
	begin
		if(reset)
			marout <= 16'h0;
		else if(ld)
			marout <= data;
	end

endmodule
