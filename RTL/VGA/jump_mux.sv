
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


always_comb
begin
		case (control)
				GATE_A:	begin
							jumptoX <= Gate_A_X;
							jumptoY <= Gate_A_Y;
							end
				GATE_B: 	begin
							jumptoX <= Gate_B_X;
							jumptoY <= Gate_B_Y;
							end
				default:	begin //should never happen
							jumptoX <= Gate_A_X-30;
							jumptoY <= Gate_A_Y-30;
							end
		endcase 
end
endmodule

//simulate with waveform


