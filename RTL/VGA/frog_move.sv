//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018


module	frog_move	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input		logic	timer_done,
					input		logic	reset_position,
//					input		logic	X_direction,
//					input		logic	y_direction,
					input 	logic left,
					input 	logic right,
					input 	logic up,
					input 	logic down,
					input		logic [8:0]	bank_width,
					output	logic	[10:0]	ObjectStartX,
					output	logic	[10:0]	ObjectStartY
					
);

//
const int StartX = 320;
const int StartY = 440;
int directionX;
int directionY;
int t;
localparam frog_speed = 2;
localparam current_speed = 1;
const int	y_frame	=	479;
//

//
//
//assign directionX = (X_direction ) ? -1 : 1;
//assign directionY = (y_direction ) ? -1 : 1;

always_ff@(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		ObjectStartX	<= StartX;
		ObjectStartY	<= StartY;
		t = StartY;
	end
		else if (reset_position)
			begin
				ObjectStartX	<= StartX;
				ObjectStartY	<= StartY;
				t = StartY;
			end
		
		else if (timer_done == 1'b1) begin
					if (ObjectStartY < y_frame - bank_width) begin
						ObjectStartX = ObjectStartX - current_speed;
					end
					if (left)  begin
						ObjectStartX = ObjectStartX + frog_speed;
					end
					if (right)  begin
						ObjectStartX = ObjectStartX - frog_speed;
					end
					if (up)  begin
						ObjectStartY = ObjectStartY + frog_speed;
					end
					if (down)  begin
						ObjectStartY = ObjectStartY - frog_speed;
					end
		end
end

//
endmodule
//
