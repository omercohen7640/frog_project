//the input for this module is the coordinates(X and Y) of the start of the french in the game, 
//and the current pixel which the VGA is requesting a color vector for
//the module calculates whtether said pixel is within the french and if so it outputs 
//the correct color vector and creates a drawing request.
module french_draw (
	   	input   logic   CLK,
		input   logic   RESETn,
		input   logic [10:0] oCoord_X,
		input   logic [10:0] oCoord_Y,
		input   logic [10:0] ObjectStartX,
		input   logic [10:0] ObjectStartY,
		output  logic   drawing_request,
		output  logic [7:0] mVGA_RGB 
);

localparam int object_X_size = 32;
localparam int object_Y_size = 32;

// 8 bit - color definition : "RRRGGGBB"  
bit [0:object_Y_size-1] [0:object_X_size-1] [7:0] object_colors = { 
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFB, 8'hFB, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hB6, 8'hFF, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hB6, 8'h8D, 8'h69, 8'h49, 8'h44, 8'h48, 8'h49, 8'h69, 8'h92, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'h92, 8'h6D, 8'hFB, 8'hFB, 8'hD6, 8'h8D, 8'h48, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h48, 8'hB6, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'h49, 8'h44, 8'h48, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'hD6, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hD6, 8'h24, 8'h44, 8'h48, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h24, 8'h44, 8'h44, 8'h24, 8'hB2, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hDB, 8'h69, 8'h44, 8'h44, 8'h44, 8'h44, 8'h68, 8'h8D, 8'hB1, 8'hD6, 8'hD6, 8'hD6, 8'hB1, 8'h44, 8'h24, 8'h69, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hD6, 8'hB1, 8'hAD, 8'hB1, 8'hD2, 8'hF6, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFF, 8'hD6, 8'h69, 8'hFA, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hD6, 8'hD6, 8'hF6, 8'hF6, 8'hFA, 8'hF6, 8'hFA, 8'hF6, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFB, 8'hFB, 8'hFB, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFB, 8'hD6, 8'hF6, 8'hFA, 8'hF6, 8'hF6, 8'hFA, 8'hF6, 8'hF6, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFB, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hD6, 8'hD6, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hF6, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFB, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFB, 8'hD6, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hF6, 8'hFA, 8'hF6, 8'hFA, 8'hFA, 8'hFB, 8'hFB, 8'hFB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hDB, 8'hB6, 8'hB2, 8'hB2, 8'hB2, 8'hD6, 8'hF6, 8'hFA, 8'hFA, 8'hFA, 8'hFB, 8'hFB, 8'hFB, 8'hFB, 8'hDB, 8'hB6, 8'h91, 8'h8D, 8'h6D, 8'h8D, 8'hB2, 8'hFB, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'hDB, 8'h6E, 8'h49, 8'h20, 8'h00, 8'h6D, 8'hB2, 8'hB2, 8'hB2, 8'h69, 8'h88, 8'h89, 8'h8D, 8'h91, 8'h91, 8'h6D, 8'h45, 8'h00, 8'h49, 8'hB6, 8'hB2, 8'hB2, 8'h64, 8'h40, 8'h20, 8'h24, 8'h92, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h6D, 8'h00, 8'h00, 8'h01, 8'h05, 8'hDB, 8'hFF, 8'hFF, 8'hFB, 8'hAD, 8'hA9, 8'h40, 8'h20, 8'h00, 8'h00, 8'h00, 8'h01, 8'h05, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hD2, 8'hCE, 8'h89, 8'h20, 8'h20, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'hB7, 8'h00, 8'h05, 8'h2A, 8'h26, 8'hBB, 8'hFF, 8'hFF, 8'hF7, 8'hA9, 8'hA9, 8'hA9, 8'h20, 8'h69, 8'h24, 8'h00, 8'h2A, 8'h26, 8'h93, 8'hFF, 8'hFF, 8'hFF, 8'hCD, 8'hA9, 8'hAD, 8'h20, 8'hB2, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h49, 8'h05, 8'h2A, 8'h2A, 8'hBB, 8'hFF, 8'hFF, 8'hF7, 8'hA9, 8'hC9, 8'h88, 8'h44, 8'hFF, 8'h92, 8'h05, 8'h2A, 8'h06, 8'h93, 8'hFF, 8'hFF, 8'hFF, 8'hCD, 8'hC9, 8'hA9, 8'h40, 8'hFB, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h92, 8'h01, 8'h2A, 8'h05, 8'hBB, 8'hFF, 8'hFF, 8'hF7, 8'hA9, 8'hA9, 8'h40, 8'h8D, 8'hFB, 8'hD7, 8'h00, 8'h06, 8'h06, 8'h73, 8'hFF, 8'hFF, 8'hFF, 8'hCD, 8'hA9, 8'h64, 8'h64, 8'hFF, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'hDB, 8'h01, 8'h25, 8'h05, 8'hBB, 8'hFF, 8'hFF, 8'hF7, 8'h89, 8'h85, 8'h40, 8'hF6, 8'hFA, 8'hFF, 8'h6D, 8'h01, 8'h05, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hA9, 8'hA9, 8'h60, 8'hAE, 8'hFF, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'h49, 8'h01, 8'h25, 8'hDB, 8'hFF, 8'hFF, 8'hFB, 8'h89, 8'h20, 8'h44, 8'hD2, 8'hFA, 8'hFB, 8'h6D, 8'h00, 8'h00, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'h64, 8'h40, 8'hFB, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'h49, 8'h00, 8'h92, 8'hDB, 8'hB6, 8'h69, 8'h20, 8'h44, 8'h44, 8'h44, 8'hFA, 8'hB2, 8'h24, 8'h45, 8'h00, 8'h45, 8'hB2, 8'hB6, 8'hB2, 8'h44, 8'h64, 8'hD6, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hB2, 8'h24, 8'h00, 8'h00, 8'h00, 8'h20, 8'h44, 8'h44, 8'h44, 8'h44, 8'h64, 8'h44, 8'h44, 8'h44, 8'h44, 8'h24, 8'h00, 8'h20, 8'h20, 8'h20, 8'hB2, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'h49, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h45, 8'h44, 8'h44, 8'hDB, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'hDA, 8'h24, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h69, 8'hF6, 8'hB1, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h24, 8'hB2, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'hB6, 8'h24, 8'h44, 8'h44, 8'h44, 8'h68, 8'h44, 8'h68, 8'hB1, 8'hD6, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hD6, 8'hB1, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h24, 8'hB2, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'hDB, 8'h6D, 8'h44, 8'h44, 8'h69, 8'h44, 8'h44, 8'hD6, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFB, 8'hFA, 8'hFB, 8'h69, 8'h44, 8'h44, 8'h44, 8'h44, 8'h24, 8'h6D, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00},
{8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h44, 8'h49, 8'h44, 8'h44, 8'h8D, 8'hFB, 8'hD6, 8'hD6, 8'hD6, 8'hFA, 8'hFA, 8'hFA, 8'hDA, 8'hFB, 8'hB6, 8'h24, 8'h44, 8'h44, 8'h44, 8'h44, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00},
{8'hDB, 8'h92, 8'hB2, 8'h6D, 8'h69, 8'h44, 8'h48, 8'h44, 8'h44, 8'h44, 8'hFF, 8'hFF, 8'hFB, 8'hFB, 8'hDA, 8'hDA, 8'hFB, 8'hFB, 8'hFF, 8'hFF, 8'hFF, 8'h91, 8'h24, 8'h44, 8'h44, 8'h48, 8'h44, 8'h8D, 8'hB6, 8'h8E, 8'h8E, 8'h00},
{8'hFF, 8'hB6, 8'h24, 8'h24, 8'h24, 8'h44, 8'h44, 8'h24, 8'h44, 8'hD6, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'h24, 8'h44, 8'h44, 8'h44, 8'h20, 8'h24, 8'h24, 8'hB6, 8'h00},
{8'h00, 8'hFF, 8'hDB, 8'h92, 8'h92, 8'h6D, 8'h49, 8'h92, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hD6, 8'h69, 8'h44, 8'h49, 8'h8D, 8'hB6, 8'hFF, 8'hFF, 8'h00},
{8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00},
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00}
};

// one bit mask  0 - off 1 dispaly 
bit [0:object_Y_size-1] [0:object_X_size-1] object_mask = {
{32'b00000000000000000000000000000000},
{32'b00000000000001111110000000000000},
{32'b00001110001111111111110000000000},
{32'b00001111111111111111111000000000},
{32'b00000111111111111111111100000000},
{32'b00000111111111111111111100000000},
{32'b00000011111111111111111100000000},
{32'b00000001111111111111111100000000},
{32'b00000011111111111111111110000000},
{32'b00000111111111111111111111000000},
{32'b00000111111111111111111111000000},
{32'b00001111111111111111111111100000},
{32'b00001111111111111111111111100000},
{32'b00111101111111111110111111111000},
{32'b00100111111111100011111111111000},
{32'b00101111111111111011111111111000},
{32'b00011111111111111111111111111000},
{32'b00011111111111111011111111111000},
{32'b00011111111111111111111111111000},
{32'b00001111111111111100111111110000},
{32'b00001101111111111110111111110000},
{32'b00000110001111111111101111110000},
{32'b00001111111111111111111111110000},
{32'b00001111111111111111111111110000},
{32'b00001111111111111111111111110000},
{32'b00001111111111111111111111110000},
{32'b00111111111111111111111111111100},
{32'b11111111111111111111111111111110},
{32'b11111111110000000000001111111110},
{32'b01111111110000000000001111111110},
{32'b00111111000000000000000111111100},
{32'b00000000000000000000000000000000}
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
