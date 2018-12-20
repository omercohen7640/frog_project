//the input for this module is the coordinates(X and Y) of the start of every Log in the game, 
//and the current pixel which the VGA is requesting a color vector for
//the module calculates whtether said pixel is within a log and if so it outputs 
//the correct color vector and creates a drawing request.


module	log_draw	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input 	logic	[10:0]	oCoord_X,
					input 	logic	[10:0]	oCoord_Y,
					input 	logic	[10:0] ObjectStartX [99:0],//11*NUM_OF_LOGS
					input 	logic	[10:0] ObjectStartY [99:0],//11*NUM_OF_LOGS
					output	logic			drawing_request,
					output	logic	[7:0]		mVGA_RGB
					
);

localparam	NUM_OF_LOGS = 100;
localparam  int object_X_size = 40;
localparam  int object_Y_size = 10;


bit [0:object_Y_size-1] [0:object_X_size-1] [7:0] object_colors = {
{8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8D, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD},
{8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8C, 8'h8C, 8'h8D, 8'h8D, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8D, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD},
{8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD},
{8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD},
{8'hAD, 8'hAD, 8'h8D, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8D, 8'h8C, 8'h8C, 8'h8C, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hAD, 8'hAD},
{8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'hAD, 8'h8D, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8C, 8'h8D, 8'h8D, 8'hAD, 8'hAD, 8'hAD},
{8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8D, 8'h88, 8'h88, 8'h8C, 8'h8C, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD},
{8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D},
{8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D},
{8'hAD, 8'hAD, 8'h8D, 8'h8C, 8'h8C, 8'h8C, 8'h8D, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8C, 8'h8D, 8'h8D, 8'h8D, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8C, 8'h88, 8'h8C, 8'h8D, 8'h8D, 8'h8D, 8'h8C}
};

//-- one bit mask  0 - off 1 dispaly 

bit [0:object_Y_size-1] [0:object_X_size-1] object_mask = {
{40'b0111111111111111111111111111111111111111},
{40'b1111111111111111111111111111111111111111},
{40'b1111111111111111111111111111111111111111},
{40'b1111111111111111111111111111111111111111},
{40'b1111111111111111111111111111111111111111},
{40'b1111111111111111111111111111111111111111},
{40'b1111111111111111111111111111111111111111},
{40'b1111111111111111111111111111111111111111},
{40'b1111111111111111111111111111111111111111},
{40'b1111111111111111111111111111111111111111}
};
                                         
                 

int bCoord_X = 0;// offset from start position 
int bCoord_Y = 0;

logic [NUM_OF_LOGS-1:0] drawing_X = 0;  /* synthesis keep */
logic [NUM_OF_LOGS-1:0] drawing_Y = 0; /* synthesis keep */
logic mask_bit	; /* synthesis keep */

logic [10:0] objectEndX [NUM_OF_LOGS-1:0];
logic [10:0] objectEndY [NUM_OF_LOGS-1:0];
always_comb
	begin
	//default values
	drawing_X = 0;
	drawing_Y = 0;
	bCoord_X = 0;
	bCoord_Y = 0;
		for (int i = 0; i< NUM_OF_LOGS; i++)
				begin
					// Calculate object end boundaries
					objectEndX[i]	= (object_X_size + ObjectStartX[i]);
					objectEndY[i]	= (object_Y_size + ObjectStartY[i]);
					//-- test if oCoord is in the rectangle defined by Start and End 
					drawing_X[i]	= ((oCoord_X  >= ObjectStartX[i]) &&  (oCoord_X < objectEndX[i])) ? 1 : 0;
					drawing_Y[i]	= ((oCoord_Y  >= ObjectStartY[i]) &&  (oCoord_Y < objectEndY[i])) ? 1 : 0;
				end

// test if both X and Y require drawing, and if so - calculate the relative coordinates of the pixel inside the bitmap 				
		for (int k = 0; k<NUM_OF_LOGS; k++) 
				begin
					if (drawing_X[k] == 1 &&  drawing_Y[k] == 1)
						begin
							bCoord_X = oCoord_X - ObjectStartX[k];
							bCoord_Y = oCoord_Y - ObjectStartY[k];
							break;
						end
					else
						begin
							bCoord_X = 0;
							bCoord_Y = 0;
						end
				end
	end


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