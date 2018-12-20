//the input for this module is the coordinates(X and Y) of the start of the gate in the game, 
//and the current pixel which the VGA is requesting a color vector for
//the module calculates whtether said pixel is within a gate and if so it outputs 
//the correct color vector and creates a drawing request.
module gate_B_draw (
	   	input   logic   CLK,
		input   logic   RESETn,
		input   logic [10:0] oCoord_Y,
		input   logic [10:0] oCoord_X,
		input   logic [10:0] ObjectStartX,
		input   logic [10:0] ObjectStartY,
		output  logic   gateB_draw_req,
		output  logic [7:0] mVGA_RGB 
);

localparam int object_X_size = 20;
localparam int object_Y_size = 20;

// 8 bit - color definition : "RRRGGGBB"  
bit [0:object_Y_size-1] [0:object_X_size-1] [7:0] object_colors = { 
{8'h0C, 8'h0C, 8'h0C, 8'h10, 8'h10, 8'h10, 8'h10, 8'h10, 8'h10, 8'h10, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h10},
{8'h0C, 8'h10, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h14},
{8'h0C, 8'h10, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h10},
{8'h0C, 8'h10, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h10},
{8'h0C, 8'h10, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h10},
{8'h2C, 8'h10, 8'h0C, 8'h10, 8'h10, 8'h10, 8'h10, 8'h10, 8'h10, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h30},
{8'hFF, 8'hFF, 8'h51, 8'h0C, 8'h10, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h18, 8'h18, 8'h18, 8'h14, 8'h18, 8'h14, 8'h55, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'h51, 8'h0C, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h55, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'h51, 8'h0C, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h55, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'h51, 8'h0C, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h55, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'h51, 8'h0C, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h55, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'h51, 8'h0C, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h55, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'h51, 8'h0C, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h55, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'h51, 8'h0C, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h55, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'h51, 8'h0C, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h55, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'h51, 8'h0C, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h55, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'h51, 8'h0C, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h55, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'h51, 8'h0C, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h55, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'h51, 8'h0C, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h55, 8'hFF, 8'hFF},
{8'hFF, 8'hFF, 8'h51, 8'h0C, 8'h0C, 8'h10, 8'h10, 8'h10, 8'h10, 8'h10, 8'h10, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h14, 8'h51, 8'hFF, 8'hFF}
};

// one bit mask  0 - off 1 dispaly 
bit [0:object_Y_size-1] [0:object_X_size-1] object_mask = {
{20'b11111111111111111111},
{20'b11111111111111111111},
{20'b11111111111111111111},
{20'b11111111111111111111},
{20'b11111111111111111111},
{20'b11111111111111111111},
{20'b00111111111111111100},
{20'b00111111111111111100},
{20'b00111111111111111100},
{20'b00111111111111111100},
{20'b00111111111111111100},
{20'b00111111111111111100},
{20'b00111111111111111100},
{20'b00111111111111111100},
{20'b00111111111111111100},
{20'b00111111111111111100},
{20'b00111111111111111100},
{20'b00111111111111111100},
{20'b00111111111111111100},
{20'b00111111111111111100}
};

int bCoord_X;// offset from start position 
int bCoord_Y;

logic drawing_X;
logic drawing_Y; // synthesis keep
logic mask_bit;

int objectEndX;
int objectEndY;



// Calculate object end boundaries
assign objectEndX    = (object_X_size + ObjectStartX);
assign objectEndY    = (object_Y_size + ObjectStartY);

// Signals drawing_X[Y] are active when obects coordinates are being crossed

// test if oCoord is in the rectangle defined by Start and End 
assign drawing_X  = ((oCoord_X  >= ObjectStartX) &&  (oCoord_X < objectEndX)) ? 1 : 0;
assign drawing_Y = ((oCoord_Y  >= ObjectStartY) &&  (oCoord_Y < objectEndY)) ? 1 : 0;

// calculate offset from start corner 
assign bCoord_X	= (drawing_X == 1 &&  drawing_Y == 1)  ? (oCoord_X - ObjectStartX): 0;
assign bCoord_Y	= (drawing_X == 1 &&  drawing_Y == 1  )  ? (oCoord_Y - ObjectStartY): 0; 


always_ff@ (posedge CLK, negedge RESETn)
begin
    if(!RESETn)
   begin
         mVGA_RGB	<= 8'b0;
         gateB_draw_req     <= 1'b0;
         mask_bit	<=  1'b0;
    end
   else
  begin
			mVGA_RGB	<=  object_colors[bCoord_Y][bCoord_X];	//get from colors table 
			gateB_draw_req	<= object_mask[bCoord_Y][bCoord_X] && drawing_X && drawing_Y ; // get from mask table if inside rectangle 
			mask_bit	<= object_mask[bCoord_Y][bCoord_X]; 
	end
end

endmodule		

//generated with PNGtoSV tool by Ben Wellingstein
