//the module output is the background's color for a said pixel from the VGA conroller.
module	back_ground_draw	(	
					input		logic	CLK,
					input		logic	RESETn,
					input 	logic	[10:0]	oCoord_X,
					input 	logic	[10:0]	oCoord_Y,

					output	logic	[7:0]	mVGA_RGB,
					output	logic [8:0] bank_width
					
);

const int	x_frame	=	639;
const int	y_frame	=	479;
const int	int_bank_width =	80; //we are dividing the screen into a grid of 24 rows and 32 columns,
											//while using 16 of the rows for the river, thererefore the width of a bank is 4*480/24 = 80 pixels

logic [2:0] mVGA_R;
logic [2:0] mVGA_G;
logic [1:0] mVGA_B;


assign mVGA_RGB =  {mVGA_R , mVGA_G , mVGA_B} ;
assign bank_width = int_bank_width;

always_comb
begin

		if (oCoord_Y < int_bank_width || oCoord_Y > y_frame-int_bank_width) begin //banks
					mVGA_R <= 3'b010 ;	
					mVGA_G <= 3'b001  ;	
					mVGA_B <= 2'b00 ;				
					end
		else begin //water
					mVGA_R <= 3'b000 ;	
					mVGA_G <= 3'b000  ;	
					mVGA_B <= 2'b11 ;	

		end;  
		
end 


endmodule

