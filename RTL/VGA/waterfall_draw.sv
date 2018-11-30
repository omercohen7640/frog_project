//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018



module	waterfall_object	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input 	logic	[10:0]	oCoord_X,
					input 	logic	[10:0]	oCoord_Y,
					output	logic				drawing_request,
					output	logic	[7:0]		mVGA_RGB //bit format: rrrgggbb
					
);
localparam waterfall_width = 40;

always_ff@(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		mVGA_RGB				<=	8'b0;
		drawing_request	<=	1'b0;
	end
	else if ((oCoord_X > 0) && (oCoord_X < waterfall_width))
		begin
		mVGA_RGB <= 8'b00100111;
		drawing_request	<= 1;
		end
	else
		begin
		mVGA_RGB <= 8'b00000000; //default color
		drawing_request	<= 0;
		end
end



endmodule