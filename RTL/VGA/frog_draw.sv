//the input for this module is the X and Y coordinate of the start of the frog in the game, 
//and the current pixel which the VGA is requesting a color vector for
//the module calculates whtether said pixel is within a frog and if so it outputs 
//the correct color vector and creates a drawing request.
module frog_draw (
	   	input   logic   CLK,
		input   logic   RESETn,
		input   logic [10:0] oCoord_X,
		input   logic [10:0] oCoord_Y,
		input   logic [10:0] ObjectStartX,
		input   logic [10:0] ObjectStartY,
		output  logic   drawing_request,
		output  logic [7:0] mVGA_RGB 
);

localparam int object_X_size = 26;
localparam int object_Y_size = 26;

// 8 bit - color definition : "RRRGGGBB"  
bit [0:object_Y_size-1] [0:object_X_size-1] [7:0] object_colors = { 
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h2C, 8'h00, 8'h00, 8'h4C, 8'h71, 8'h4C, 8'h04, 8'h4D, 8'h71, 8'h71, 8'h4C, 8'h04, 8'hFF, 8'h2C, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h50, 8'h00, 8'h72, 8'hDF, 8'hFF, 8'hFF, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hDF, 8'h6D, 8'h04, 8'h71, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'hFE, 8'h92, 8'h50, 8'h6D, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'hB6, 8'hFF, 8'hDB, 8'h00, 8'h50, 8'h00, 8'hFE, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h4C, 8'hDD, 8'h6D, 8'h50, 8'h49, 8'hFF, 8'hFF, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hB6, 8'hFF, 8'h96, 8'h08, 8'h50, 8'h2C, 8'hDD, 8'h50, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h28, 8'h2C, 8'h2C, 8'h00, 8'h28, 8'h50, 8'h75, 8'hDB, 8'hFF, 8'hDA, 8'h95, 8'hDB, 8'hFF, 8'hFF, 8'hB6, 8'h54, 8'h54, 8'h28, 8'h24, 8'h2C, 8'h50, 8'h28, 8'h00, 8'h00},
{8'h00, 8'h04, 8'h28, 8'h28, 8'h00, 8'h00, 8'h50, 8'h74, 8'h54, 8'h54, 8'h54, 8'h50, 8'h54, 8'h50, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h50, 8'h04, 8'h00, 8'h2C, 8'h28, 8'h00, 8'h00},
{8'h00, 8'h04, 8'h28, 8'h79, 8'h00, 8'h4C, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h50, 8'h00, 8'h74, 8'h08, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h50, 8'h00, 8'h50, 8'h54, 8'h54, 8'h50, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h50, 8'h54, 8'h54, 8'h54, 8'h4C, 8'h50, 8'h54, 8'h00, 8'h00},
{8'h00, 8'h04, 8'h50, 8'h00, 8'h50, 8'h30, 8'h54, 8'h54, 8'h50, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h50, 8'h50, 8'h54, 8'h54, 8'h30, 8'h50, 8'h00, 8'h04, 8'h04, 8'h00},
{8'h00, 8'h04, 8'h79, 8'h00, 8'h50, 8'h54, 8'h54, 8'h54, 8'h54, 8'h50, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h50, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h50, 8'h00, 8'h74, 8'h00, 8'h00},
{8'h00, 8'h24, 8'h2C, 8'h00, 8'h28, 8'h50, 8'h54, 8'h54, 8'h54, 8'h54, 8'h50, 8'h50, 8'h50, 8'h50, 8'h50, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h50, 8'h24, 8'h79, 8'h2C, 8'h04, 8'h00},
{8'h00, 8'h04, 8'h74, 8'h2C, 8'h2C, 8'h28, 8'h50, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h50, 8'h04, 8'h28, 8'h2C, 8'h50, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h74, 8'h50, 8'h50, 8'h28, 8'h2C, 8'h50, 8'h50, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h50, 8'h50, 8'h28, 8'h04, 8'h2C, 8'h2C, 8'h50, 8'h00, 8'h00},
{8'h00, 8'h28, 8'h2C, 8'h50, 8'h50, 8'h04, 8'h50, 8'h74, 8'h54, 8'h50, 8'h50, 8'h50, 8'h50, 8'h50, 8'h50, 8'h50, 8'h50, 8'h54, 8'h74, 8'h50, 8'h00, 8'h50, 8'h2C, 8'h28, 8'h00, 8'h28},
{8'h2C, 8'h00, 8'h2C, 8'h54, 8'h50, 8'h2C, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h2C, 8'h50, 8'h50, 8'h24, 8'h54, 8'h28},
{8'h2C, 8'h00, 8'h2C, 8'h50, 8'h2C, 8'h50, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h50, 8'h2C, 8'h2C, 8'h04, 8'h54, 8'h24},
{8'h28, 8'h50, 8'h54, 8'h54, 8'h50, 8'h50, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h50, 8'h50, 8'h54, 8'h50, 8'h2C, 8'h00},
{8'h2C, 8'h54, 8'h54, 8'h54, 8'h50, 8'h50, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h50, 8'h54, 8'h74, 8'h50, 8'h00},
{8'h28, 8'h54, 8'h54, 8'h54, 8'h50, 8'h30, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h54, 8'h50, 8'h50, 8'h54, 8'h54, 8'h50, 8'h00},
{8'h00, 8'h50, 8'h54, 8'h54, 8'h50, 8'h50, 8'h54, 8'h54, 8'h50, 8'h54, 8'h54, 8'h50, 8'h54, 8'h54, 8'h54, 8'h50, 8'h54, 8'h54, 8'h50, 8'h54, 8'h50, 8'h50, 8'h74, 8'h54, 8'h2C, 8'h54},
{8'h50, 8'hFF, 8'h50, 8'h54, 8'h54, 8'h50, 8'h74, 8'h54, 8'h50, 8'h54, 8'h54, 8'h50, 8'h54, 8'h54, 8'h54, 8'h50, 8'h54, 8'h54, 8'h50, 8'h54, 8'h54, 8'h50, 8'h54, 8'h4C, 8'h9D, 8'h50},
{8'h2C, 8'h50, 8'h2C, 8'h50, 8'h74, 8'h50, 8'h54, 8'h54, 8'h50, 8'h54, 8'h54, 8'h50, 8'h54, 8'h54, 8'h54, 8'h50, 8'h54, 8'h54, 8'h50, 8'h54, 8'h50, 8'h74, 8'h50, 8'h2C, 8'h50, 8'h2C},
{8'h2C, 8'h50, 8'h54, 8'h54, 8'h54, 8'h50, 8'h2C, 8'h50, 8'h50, 8'h54, 8'h54, 8'h50, 8'h74, 8'h54, 8'h74, 8'h50, 8'h54, 8'h74, 8'h50, 8'h2C, 8'h50, 8'h50, 8'h54, 8'h54, 8'h50, 8'h2C},
{8'h00, 8'h50, 8'h50, 8'h2C, 8'h04, 8'h00, 8'h79, 8'h00, 8'h50, 8'h54, 8'h54, 8'h50, 8'h54, 8'h54, 8'h54, 8'h50, 8'h54, 8'h54, 8'h50, 8'h00, 8'h74, 8'h00, 8'h2C, 8'h50, 8'h50, 8'h28},
{8'h00, 8'h00, 8'hFF, 8'h50, 8'h00, 8'hFF, 8'h2C, 8'h50, 8'h4C, 8'h54, 8'h50, 8'h50, 8'h2C, 8'h28, 8'h28, 8'h50, 8'h50, 8'h54, 8'h2C, 8'h50, 8'h2C, 8'h00, 8'h2C, 8'h7D, 8'hFF, 8'h28},
{8'h28, 8'h00, 8'hFF, 8'h50, 8'h2C, 8'h04, 8'h28, 8'h4C, 8'h00, 8'h50, 8'h2C, 8'h28, 8'h2C, 8'h28, 8'h2C, 8'h2C, 8'h28, 8'h50, 8'h00, 8'h2C, 8'h2C, 8'h04, 8'h4C, 8'h7D, 8'hFF, 8'h50}
};

// one bit mask  0 - off 1 dispaly 
bit [0:object_Y_size-1] [0:object_X_size-1] object_mask = {
{26'b00000110011111111111000000},
{26'b00000010111111111111000000},
{26'b00001111111111111101010000},
{26'b00011111111111111111111000},
{26'b00111011111111111111111100},
{26'b01110011111111111111101100},
{26'b01110111111111111111101100},
{26'b00101111111111111111111100},
{26'b01101111111111111111110110},
{26'b01101111111111111111110100},
{26'b01101111111111111111111110},
{26'b01111111111111111111111100},
{26'b00111111111111111111111100},
{26'b01111111111111111111011101},
{26'b10111111111111111111111111},
{26'b10111111111111111111111111},
{26'b11111111111111111111111110},
{26'b11111111111111111111111110},
{26'b11111111111111111111111110},
{26'b01111111111111111111111111},
{26'b11111111111111111111111111},
{26'b11111111111111111111111111},
{26'b11111111111111111111111111},
{26'b01111010111111111110101111},
{26'b00110111111111111111101111},
{26'b10111111011111111101111111}
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
         drawing_request     <= 1'b0;
         mask_bit	<=  1'b0;
    end
   else
  begin
			mVGA_RGB	<=  object_colors[bCoord_Y][bCoord_X];	//get from colors table 
			drawing_request	<= object_mask[bCoord_Y][bCoord_X] && drawing_X && drawing_Y ; // get from mask table if inside rectangle 
			mask_bit	<= object_mask[bCoord_Y][bCoord_X]; 
	end
end

endmodule		

//generated with PNGtoSV tool by Ben Wellingstein
