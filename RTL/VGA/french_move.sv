//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018


module	french_move	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input		logic	timer_done,
//					input		logic	X_direction,
//					input		logic	y_direction,
					input 	logic [3:0] random,
					output	logic	[10:0]	ObjectStartX,
					output	logic	[10:0]	ObjectStartY
					
);

//
logic [10:0] StartX = 200;// right to the waterfall
logic [10:0] StartY = 250;//under the endbank
const int	y_frame	=	479;
const int	french_size = 26;
const int	x_frame 	= 	639;


localparam french_speed = 3;
localparam start_counter = 4;

localparam LEFT = 0;
localparam RIGHT = 1;
localparam UP = 2;
localparam DOWN = 3;

localparam limit_left = 45;
localparam limit_right = 635;
localparam limit_up = 85;
localparam limit_down = 393;

logic [1:0] direction;
logic [2:0] move_x;
logic [2:0] move_y;
logic [1:0] counter;




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
			counter <= 0;
			move_x <= 0;
			move_y <= 0;
			direction <= RIGHT;
		end
	else if (timer_done == 1'b1) 
	begin
		if (counter == 0)
		begin
			counter = start_counter;
			if ((random >= 4'd0) && (random <= 4'd3))// move up
			begin
				move_x <= 0;
				move_y <= french_speed;
				direction <= UP;
			end
			if ((random >= 4'd4) && (random <= 4'd7))//move down
			begin
				move_x <= 0;
				move_y <= french_speed;
				direction <= DOWN;
			end
			if ((random >= 4'd8) && (random <= 4'd11))//move right
			begin
				move_x <= french_speed;
				move_y <= 0;
				direction <= RIGHT;
			end
			if ((random >= 4'd12) && (random <= 4'd15))// move left
			begin
				move_x <= french_speed;
				move_y <= 0;
				direction <= LEFT;
			end
		end
		else 
		begin
			counter <= counter - 1;
		end
		if (direction == UP) begin
			if (ObjectStartY >= limit_up)
				begin
					ObjectStartX <= ObjectStartX - move_x;
					ObjectStartY <= ObjectStartY - move_y;
				end
			end
		if (direction == DOWN) begin
			if (ObjectStartY + french_size <= limit_down)
				begin
					ObjectStartX <= ObjectStartX + move_x;
					ObjectStartY <= ObjectStartY + move_y;
				end
			end
		if (direction == RIGHT) begin
			if (ObjectStartX + french_size <= limit_right)
				begin
					ObjectStartX <= ObjectStartX + move_x;
					ObjectStartY <= ObjectStartY + move_y;					
				end
			end
		if (direction == LEFT) begin
			if (ObjectStartX >= limit_left)
				begin
					ObjectStartX <= ObjectStartX - move_x;
					ObjectStartY <= ObjectStartY - move_y;
				end
			end
		end
	end
//
endmodule
//
