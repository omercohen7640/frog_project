//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018



module	endbank_draw	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input 	logic	[10:0]	oCoord_Y,
					output	logic				drawing_request,
					output	logic	[7:0]		mVGA_RGB //bit format: rrrgggbb
					
);

localparam	int_bank_width =	80;

always_ff@(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		mVGA_RGB				=	8'b0;
		drawing_request	=	1'b0;
	end
	else if (oCoord_Y < int_bank_width)
		begin

			mVGA_RGB = 8'b01000100;
			drawing_request = 1'b1;
		end
			else
					begin
						mVGA_RGB = 8'b0;
						drawing_request = 1'b0;
					end
end



endmodule