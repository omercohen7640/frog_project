


module	gate_A_draw	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input 	logic	[10:0]	oCoord_Y,
					input 	logic	[10:0]	oCoord_X,
					input		logic [10:0]	ObjectStartX,
					input		logic [10:0]	ObjectStartY,
					output	logic	gateA_draw_req,
					output	logic	[7:0]		mVGA_RGB
					
);

localparam  int object_X_size = 9;
localparam  int object_Y_size = 9;


bit [0:object_Y_size-1] [0:object_X_size-1] [7:0] object_colors = {
 {8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E},
 {8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E},
 {8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E},
 {8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E},
 {8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E},
 {8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E},
 {8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E},
 {8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E},
 {8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E},
 {8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E, 8'h3E}
};

//-- one bit mask  0 - 1 dispaly 

bit [0:object_Y_size-1] [0:object_X_size-1] object_mask = {
{9'b111111111},
{9'b111111111},
{9'b111111111},
{9'b111111111},
{9'b111111111},
{9'b111111111},
{9'b111111111},
{9'b111111111},
{9'b111111111}
};                                       



				  
int bCoord_X;// offset from start position 
int bCoord_Y;

logic drawing_X;  /* synthesis keep */
logic drawing_Y; /* synthesis keep */
logic mask_bit	; /* synthesis keep */

int objectEndX ;
int objectEndY ;


// Calculate object end boundaries
assign objectEndX	= (object_X_size + ObjectStartX);
assign objectEndY	= (object_Y_size + ObjectStartY);
//
//-- Signals drawing_X[Y] are active when object's coordinates are being crossed


assign drawing_X	= ((oCoord_X  >= ObjectStartX) &&  (oCoord_X < objectEndX)) ? 1 : 0;
assign drawing_Y	= ((oCoord_Y  >= ObjectStartY) &&  (oCoord_Y < objectEndY)) ? 1 : 0;

//-- test if ooCoord is in the rectangle defined by Start and End 

assign bCoord_X	= (drawing_X == 1 &&  drawing_Y == 1  )  ? (oCoord_X - ObjectStartX): 0;
assign bCoord_Y	= (drawing_X == 1 &&  drawing_Y == 1  )  ? (oCoord_Y - ObjectStartY): 0;



always_ff@(posedge CLK or negedge RESETn)
	begin
		if(!RESETn)
		begin
			mVGA_RGB				<=	8'b0;
			gateA_draw_req 	<=	1'b0;
			mask_bit				<=	1'b0;
		end
		else
			begin
					mVGA_RGB				<= object_colors[object_Y_size-1 - bCoord_Y ][ bCoord_X];	//get from colors table 
					gateA_draw_req 	<= object_mask[bCoord_Y][bCoord_X] && drawing_X && drawing_Y ; // get from mask table if inside rectangle  
					mask_bit				<= object_mask[bCoord_Y][bCoord_X];
			end
	end
endmodule 