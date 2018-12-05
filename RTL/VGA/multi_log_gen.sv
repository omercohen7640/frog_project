//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018


module	multi_log_gen(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input		logic	[14:0] enable,
					input		logic	timer_done,
					input		logic	[8:0] start_offsetY [14:0],
					input		logic	[8:0] start_offsetX [14:0],
					input		logic	[3:0] random_0_15,
					input		logic	[10:0] oCoord_X,
					input		logic	[10:0] oCoord_Y,
					output	logic	drawing_request,
					output	logic	[7:0]		mVGA_RGB
					
					
);

localparam NUM_OF_LOGS = 15;
logic [10:0] ObjectStartX_wire [NUM_OF_LOGS-1:0];
logic [10:0] ObjectStartY_wire [NUM_OF_LOGS-1:0];

//for (int i ; i < NUM_OF_LOGS-1 ; i++) begin: 
log_mover log_mover_inst[NUM_OF_LOGS-1:0] (
						.CLK(CLK),
						.RESETn(RESETn),
						.enable(enable),
						.timer_done(timer_done),
						.start_offsetY(start_offsetY),
						.start_offsetX(start_offsetX),
						.random_0_15 (random_0_15),
						.ObjectStartX(ObjectStartX_wire),
						.ObjectStartY(ObjectStartY_wire)
						);
//						end


//for (int j =0; j< NUM_OF_LOGS-1 ; j++) begin
	log_draw	log_draw_ins(	
	//		--////////////////////	Clock Input	 	////////////////////	
						.CLK(CLK),
						.RESETn(RESETn),
						.oCoord_X(oCoord_X),
						.oCoord_Y(oCoord_Y),
						.ObjectStartX(ObjectStartX_wire),
						.ObjectStartY(ObjectStartY_wire),
						.drawing_request(drawing_request),
						.mVGA_RGB(mVGA_RGB)
				);
//				end
						
//
endmodule
//
