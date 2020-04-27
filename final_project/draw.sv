module draw
(
	input  logic        Clk,
	input  logic        drawBlock,
	input  logic [9:0]  DrawX, DrawY, PosX, PosY,
	output logic [3:0]  colorindex_draw,
	input  logic [15:0] blockstate,
	input  logic [5:0]  spriteindex
);

	logic [15:0] address;
	logic [3:0]  blockstateindex;
	logic[3:0] colorindex;

	spriteRAM blockMemory1 (.read_address(address), .Clk(Clk), .data_Out(colorindex));

	always_comb
	begin
		address = 15'b0;
		blockstateindex = 4'b0;
		colorindex_draw = 4'h8;

		if (drawBlock)
		begin
			blockstateindex = ((DrawY - PosY)/10'd20)*4 + ((DrawX - PosX)/10'd20);
			colorindex_draw = colorindex;
			if(blockstate[blockstateindex])
			begin
				address = ((DrawY - PosY)%10'd20 * 16'd20) + DrawX%10'd20 + spriteindex * 16'd400;
			end
			else
				address = ((DrawY % 10'd20) * 10'd20) + ((DrawX % 10'd20) + 16'd37 * 16'd400);
		end
		else if( DrawX < 10'd200)
		begin
			address = ((DrawY % 10'd20) * 10'd20) + ((DrawX % 10'd20) + 16'd37 * 16'd400);
			colorindex_draw = colorindex;
		end
		
	end
endmodule
