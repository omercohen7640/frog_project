// game FSM

module bomb
	(
	input logic clk, resetN
	
	input logic [256:0] logs_draw_req
	output logic 
   );

	enum logic [2:0] {} prState, nxtState;
 	
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  // Asynchronic reset
		prState <= IDLE;
   else 		// Synchronic logic FSM
		prState <= nxtState;
		
	end // always
	
always_comb // Update next state and outputs
	begin
		
	end // always comb
	
endmodule