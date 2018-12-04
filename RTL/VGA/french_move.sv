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
					input 	logic [15:0] random,
					input		logic [8:0]	bank_width,
					output	logic	[10:0]	ObjectStartX,
					output	logic	[10:0]	ObjectStartY
					
);

//
const int StartX = 45;// right to the waterfall
const int StartY = 85;//under the endbank
const int	y_frame	=	479;


localparam french_speed = 1;
localparam current_speed = 1;
localparam start_counter = 4;

localparam LEFT = 00;
localparam RIGHT = 01;
localparam UP = 10;
localparam DOWN = 11;

localparam limit_left = 45;
localparam limit_right = 635;
localparam limit_up = 85;
localparam limit_down = 400;

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
		end
	else
		begin
			if (timer_done == 1'b1)
				begin
					counter = counter - 1;
					if (counter == 0)
						begin
							if (random >=0 && random <=3) begin //move left
								move_x = -french_speed;
								move_y = 0;
								direction = LEFT;
								end
							if (random >=4 && random <=7) begin //move right
								move_x = french_speed;
								move_y = 0;
								direction = RIGHT;
								end
							if (random >=8 && random <=11) begin //move up
								move_x = 0;
								move_y = french_speed;
								direction = UP;
								end
							if (random >=12 && random <=15) begin //move dowb
								move_x = 0;
								move_y = -french_speed;
								direction = DOWN;
								end
							counter = start_counter;	
						end
					//skip if make the french go out of limits
					if (!(((ObjectStartX <= limit_left) && direction == LEFT)||((ObjectStartX <= limit_right) && direction == RIGHT)||((ObjectStartY <= limit_up) && direction == UP )||((ObjectStartY >= limit_down) && direction == DOWN )))
					begin
						ObjectStartX	= ObjectStartX + move_x;
						ObjectStartY	= ObjectStartX + move_x;
					end
				end
		end
end

//
endmodule
//
