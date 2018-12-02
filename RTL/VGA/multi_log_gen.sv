//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018


module	log_mover	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input		logic	timer_done,
					output	logic	[10:0]	ObjectStartX,
					output	logic	[10:0]	ObjectStartY
					
					
);

//
const int	y_frame	=	479;
localparam	x_frame	=	639;
localparam log_size = 20; //value for test
localparam random = 5; //value for test
localparam StartX = x_frame;
localparam StartY = random*log_size;
localparam current_speed = 1;



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
