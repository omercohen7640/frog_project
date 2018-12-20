//this module's output is the coordinate at which the topleft corner of the frog object is at.
//the output is determined by keystrokes(up,down,left,right) and through game incidents (such as losing/winning, magic gates).
//these incidents are all inserted tto the module through control signals.

module	frog_move	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input		logic	timer_done, // the VGA finished scanning all the pixels on a full screen, and starts a new cycle.
					input		logic	reset_position,
					input 	logic left,
					input 	logic right,
					input 	logic up,
					input 	logic down,
					input		logic [8:0]	bank_width,
					input		logic	jump,
					input		logic	[10:0]	jumptoX, //coordinates to jump to if control "jump" is 1
					input		logic	[10:0]	jumptoY, //coordinates to jump to if control "jump" is 1
					output	logic	[10:0]	ObjectStartX,
					output	logic	[10:0]	ObjectStartY
					
);

//
const int	y_frame	=	479;//screen frame borders
const int	x_frame 	= 	639;

const int StartX = 320; //default start location after frog's postion is reset/
const int StartY = 440;

localparam frog_speed = 2;
localparam current_speed = 1;
localparam frog_size = 20;

int directionX;
int directionY;

//these logics are used to determine whether the frog is about to exit the screen thorugh every side of the screen.
logic in_frame_up = 1;
logic in_frame_down = 1;
logic in_frame_left = 1;
logic in_frame_right = 1;

assign in_frame_down = (ObjectStartY > 0);
assign in_frame_up = (ObjectStartY <= y_frame - frog_size);
assign in_frame_right = (ObjectStartX > 0);
assign in_frame_left = (ObjectStartX <= x_frame - frog_size);



always_ff@(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		ObjectStartX	<= StartX;
		ObjectStartY	<= StartY;
	end
		else if (reset_position)
			begin
				ObjectStartX	<= StartX;
				ObjectStartY	<= StartY;
			end
		else if (jump) begin 
					ObjectStartX	<= jumptoX;
					ObjectStartY	<= jumptoY;
					end
		else if (timer_done == 1'b1) begin
					if (ObjectStartY < y_frame - bank_width-frog_size) begin //we're withing screen limits
						ObjectStartX = ObjectStartX - current_speed;
					end
					if (left && in_frame_left)  begin
						ObjectStartX = ObjectStartX + frog_speed;
					end
					if (right && in_frame_right)  begin
						ObjectStartX = ObjectStartX - frog_speed;
					end
					if (up && in_frame_up)  begin
						ObjectStartY = ObjectStartY + frog_speed;
					end
					if (down && in_frame_down)  begin
						ObjectStartY = ObjectStartY - frog_speed;
					end
		end
end

//
endmodule
//
