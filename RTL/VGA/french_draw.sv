//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018



module	french_object	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input 	logic	[10:0]	oCoord_X,
					input 	logic	[10:0]	oCoord_Y,
					input 	logic	[10:0]	ObjectStartX,
					input 	logic	[10:0]	ObjectStartY,
					output	logic				drawing_request,
					output	logic	[7:0]		mVGA_RGB
					
);

localparam  int object_X_size = 26;
localparam  int object_Y_size = 26;


bit [0:object_Y_size-1] [0:object_Y_size-1] [7:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD5, 8'hD0, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hD0, 8'hD5, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD5, 8'hD0, 8'hD4, 8'h64, 8'h8C, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h64, 8'hAC, 8'hD0, 8'hD5, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF}, 
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD0, 8'hD4, 8'hD9, 8'h8C, 8'hD9, 8'hFF, 8'hD9, 8'hD9, 8'hD9, 8'hD9, 8'hD9, 8'hFF, 8'hD5, 8'hD5, 8'hD4, 8'hD0, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF}, 
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD0, 8'hD4, 8'hD9, 8'hD9, 8'hFF, 8'hD9, 8'hD9, 8'hD9, 8'hD9, 8'hD9, 8'hD9, 8'hD9, 8'hD9, 8'hD9, 8'hD9, 8'hD9, 8'hD9, 8'hD0, 8'hFF, 8'hFF, 8'hFF, 8'hFF}, 
{8'hFF, 8'hFF, 8'hFF, 8'hD0, 8'hD4, 8'hD9, 8'hD9, 8'hD5, 8'hD4, 8'h88, 8'h6C, 8'hD4, 8'hD9, 8'hD9, 8'hD9, 8'hD9, 8'hB0, 8'hD5, 8'hD9, 8'hD9, 8'hD9, 8'hD9, 8'hCC, 8'hFF, 8'hFF, 8'hFF}, 
{8'hFF, 8'hFF, 8'hD0, 8'hD4, 8'hD9, 8'hD5, 8'hD4, 8'h40, 8'h04, 8'h9B, 8'h9B, 8'h96, 8'hD4, 8'hD9, 8'hD9, 8'hB1, 8'h9B, 8'h72, 8'h24, 8'h8C, 8'hD9, 8'hD9, 8'hD4, 8'hD0, 8'hFF, 8'hFF}, 
{8'hFF, 8'hB6, 8'hD0, 8'hD9, 8'hD5, 8'hD9, 8'h40, 8'h29, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'hD9, 8'hD4, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h24, 8'h8C, 8'hD5, 8'hD9, 8'hD0, 8'hD5, 8'hFF}, 
{8'hFF, 8'hD0, 8'hD4, 8'hD9, 8'hB0, 8'h44, 8'h44, 8'hFF, 8'h96, 8'h0A, 8'h92, 8'hFF, 8'hFF, 8'hD0, 8'hB6, 8'hFF, 8'h4E, 8'h0A, 8'hFF, 8'hFF, 8'h44, 8'hB4, 8'hD8, 8'hD4, 8'hD0, 8'hFF}, 
{8'hFF, 8'hD0, 8'hD4, 8'hD8, 8'hD8, 8'hD0, 8'h71, 8'hBA, 8'hFF, 8'h00, 8'h32, 8'hFF, 8'hFF, 8'hD4, 8'hBA, 8'hFF, 8'h68, 8'h2D, 8'h72, 8'hFF, 8'hD0, 8'hD8, 8'hD4, 8'hD4, 8'hD0, 8'hFF}, 
{8'hD5, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hB6, 8'h76, 8'h00, 8'h00, 8'h56, 8'hFF, 8'hFF, 8'hD4, 8'hBA, 8'h56, 8'h00, 8'h72, 8'h52, 8'hFF, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hD5}, 
{8'hD5, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hB6, 8'h9B, 8'h32, 8'h52, 8'h52, 8'hFF, 8'hFF, 8'hD4, 8'hD5, 8'h76, 8'h2D, 8'h76, 8'h96, 8'hFF, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hD5}, 
{8'hD4, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hD9, 8'h72, 8'h4E, 8'hFF, 8'hFF, 8'h92, 8'hD9, 8'hD8, 8'h9B, 8'h72, 8'h72, 8'hFF, 8'hB0, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hD4}, 
{8'hD4, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hD0, 8'hBA, 8'h9B, 8'h76, 8'hD4, 8'hD9, 8'hD9, 8'hD4, 8'hB6, 8'hB6, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hD5}, 
{8'hD5, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hD0, 8'hD0, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD9, 8'hD9, 8'hD8, 8'hD8, 8'hD8, 8'hD0, 8'hD0, 8'hD0, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hD5}, 
{8'hD5, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hD0, 8'hD0, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hD5}, 
{8'hFF, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD8, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hFF}, 
{8'hFF, 8'hD0, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD8, 8'hD4, 8'hD0, 8'hD0, 8'hD0, 8'hD0, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hFF}, 
{8'hFF, 8'hD5, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD8, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hD5, 8'hFF}, 
{8'hFF, 8'hFF, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hD0, 8'hFF, 8'hFF}, 
{8'hFF, 8'hFF, 8'hFF, 8'hD0, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hFF, 8'hFF, 8'hFF}, 
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD0, 8'hD8, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hFF, 8'hFF, 8'hFF, 8'hFF}, 
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD0, 8'hD9, 8'hD9, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hD0, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF}, 
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD5, 8'hD4, 8'hD9, 8'hD9, 8'hD9, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hD0, 8'hD5, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF}, 
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD5, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD4, 8'hD0, 8'hD0, 8'hD5, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF}, 
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF}
};

//-- one bit mask  0 - off 1 dispaly 

bit [0:object_Y_size-1] [0:object_X_size-1] object_mask = {
{26'b00000000000000000000000001},
{26'b10000000000000000000000010},
{26'b01000000000000000000000100},
{26'b00100000000000000000001000},
{26'b00010000000000000000010000},
{26'b00001000000000000000100000},
{26'b00000100000000000001000000},
{26'b00000010000000000010000000},
{26'b00000001000000000100000000},
{26'b00000000100000001000000000},
{26'b00000000010000010000000000},
{26'b00000000001000100000000000},
{26'b00000000000101000000000000},
{26'b00000000000010000000000000},
{26'b00000000000101000000000000},
{26'b00000000001000100000000000},
{26'b00000000010000010000000000},
{26'b00000000100000001000000000},
{26'b00000001000000000100000000},
{26'b00000010000000000010000000},
{26'b00000100000000000001000000},
{26'b00001000000000000000100000},
{26'b00010000000000000000010000},
{26'b00100000000000000000001000},
{26'b01000000000000000000000100},
{26'b10000000000000000000000010}
};                     
                 

int bCoord_X ;// offset from start position 
int bCoord_Y ;

logic drawing_X ;  /* synthesis keep */
logic drawing_Y ; /* synthesis keep */
logic mask_bit	; /* synthesis keep */

int objectEndX ;
int objectEndY ;



// Calculate object end boundaries
assign objectEndX	= (object_X_size + ObjectStartX);
assign objectEndY	= (object_Y_size + ObjectStartY);
//
//-- Signals drawing_X[Y] are active when obects coordinates are being crossed
//
//-- test if ooCoord is in the rectangle defined by Start and End 

assign drawing_X	= ((oCoord_X  >= ObjectStartX) &&  (oCoord_X < objectEndX)) ? 1 : 0;
assign drawing_Y	= ((oCoord_Y  >= ObjectStartY) &&  (oCoord_Y < objectEndY)) ? 1 : 0;

assign bCoord_X	= (drawing_X == 1 &&  drawing_Y == 1  )  ? (oCoord_X - ObjectStartX): 0;
assign bCoord_Y	= (drawing_X == 1 &&  drawing_Y == 1  )  ? (oCoord_Y - ObjectStartY): 0;



always_ff@(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		mVGA_RGB				<=	8'b0;
		drawing_request	<=	1'b0;
		mask_bit				<=	1'b0;
	end
	else
	begin
		mVGA_RGB				<= object_colors[object_Y_size-1 - bCoord_Y ][ bCoord_X];	//get from colors table 
		drawing_request	<= object_mask[bCoord_Y][bCoord_X] && drawing_X && drawing_Y ; // get from mask table if inside rectangle  
		mask_bit				<= object_mask[bCoord_Y][bCoord_X];
	end
end



endmodule