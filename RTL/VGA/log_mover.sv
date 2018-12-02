//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018


module	log_mover	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input		logic	timer_done,
					input		logic	[3:0] random_1_12,
					output	logic	[10:0]	ObjectStartX,
					output	logic	[10:0]	ObjectStartY
					
					
);

//
const int	y_frame	=	479;
localparam	x_frame	=	639;
localparam log_size = 20; //value for test
localparam StartX = x_frame;
localparam current_speed = 1;

logic [10:0] StartY = 100;

assign StartY = random_1_12*log_size;



always_ff@(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		ObjectStartX	<= StartX;
		ObjectStartY	<= StartY;
	end
		else if (timer_done == 1'b1) begin
						if (ObjectStartX == 0) begin
							ObjectStartX	<= StartX;
							ObjectStartY	<= StartY;
						end
						else begin
						ObjectStartX = ObjectStartX - current_speed;
						end
		end
					
end

//
endmodule
//
