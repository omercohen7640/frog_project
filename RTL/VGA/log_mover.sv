

module	log_mover	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input		logic	enable,
					input		logic	timer_done,
					input		logic	[8:0] start_offsetY,
					input		logic	[8:0] start_offsetX,
					input		logic	[3:0] random_0_15,
					output	logic	[10:0]	ObjectStartX,
					output	logic	[10:0]	ObjectStartY
					
					
);

//
localparam	y_frame	=	11'd479;
localparam	x_frame	=	11'd639;
localparam log_size = 20; //value for test
localparam current_speed = 1;
localparam bank_size = 80;
localparam NULL_X = 400 ; //null coordinates for a log, they are behind the endbank so the log won't show up if it's disabled
localparam NULL_Y = 0; //null coordinates for a log, they are behind the endbank so the log won't show up if it's disabled

logic [10:0] StartX ;
logic [10:0] StartY ;

assign StartX = x_frame + StartY +start_offsetX; //offset is used to delay the logs so they won't all overlap on beginning
assign StartY = bank_size + ((start_offsetY+random_0_15)%16)*log_size ; //offset is used  so the logs won't all overlap on beginning board



always_ff@(posedge CLK or negedge RESETn)
	begin
		if(!RESETn)
		begin
			ObjectStartX	<= StartX;
			ObjectStartY	<= StartY;
		end
		else if (enable)
			begin
				if (timer_done == 1'b1)
						begin
							if (ObjectStartX == 0 || ObjectStartY == NULL_Y) //we need to set the log in a new position
								begin
								ObjectStartX	<= StartX;//_nxt;
								ObjectStartY	<= StartY;//_nxt;
								end
							else
								begin
								ObjectStartX <= ObjectStartX - current_speed;
								end
						end
			end
		else //log is disabled
			begin
				ObjectStartX	<= NULL_X;
				ObjectStartY	<= NULL_Y;
			end
					
	end

//
endmodule
//
//simulate with waveform1