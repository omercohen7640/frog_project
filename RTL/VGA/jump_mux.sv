//this mux chooses for the frog the correct gate's coordinates.
module	jump_mux	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input		logic	control,
					input		logic	[10:0]	Gate_A_X,
					input		logic	[10:0]	Gate_A_Y,
					input		logic	[10:0]	Gate_B_X,
					input		logic	[10:0]	Gate_B_Y,
					output	logic	[10:0]	jumptoX,
					output	logic	[10:0]	jumptoY
					
);


localparam GATE_A = 0;
localparam GATE_B= 1;


always_ff@(posedge CLK or negedge RESETn)
begin
		if(!RESETn)
		begin
			jumptoX <= Gate_A_X;
			jumptoY <= Gate_A_Y;
		end
		else if (control == GATE_B)
				begin
					jumptoX <= Gate_B_X;
					jumptoY <= Gate_B_Y;
				end
				else if (control == GATE_A)
					begin
						jumptoX <= Gate_A_X;
						jumptoY <= Gate_A_Y;
					end
end
endmodule

//simulate with waveform


