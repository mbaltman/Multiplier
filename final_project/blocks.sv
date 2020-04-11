module blocks
(
	input Clk, Reset,
	input [9:0] DrawX, DrawY,
	output logic [2:0] colorIndex,
	output logic drawBlock
);

	parameter [9:0] Block_x = 10'd0;  // Center position on the X axis
	parameter [9:0] Block_y = 10'd0;  // Center position on the Y axis

	logic [9:0] address = 10'd0;

	frameRAM blockMemeory(.read_address(address), .Clk(Clk), .data_Out(colorIndex));

	always_comb
	begin
		if((DrawX > Block_x) & (DrawX < (Block_x + 10'd20)) & (DrawX > Block_y) & (DrawY < Block_y + 10'd20))
		begin
			address = 20*(DrawX-Block_x) + (DrawY-Block_y);
			drawBlock = 1'b1;
		end
		else
		begin
			drawBlock = 1'b0;
			address = 10'd0;
		end
	end
endmodule