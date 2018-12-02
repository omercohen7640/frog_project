// game FSM
//temporary- one log instead of many.

//lose conditions -
//hit frog and log
//hit frog and waterfall
//hit frog and french
//
//win conditions-
//hit frog and end bank


module GameController(
	input logic clk, resetN,
	input	logic waterfall_draw_req, log_draw_req, frog_draw_req, endbank_draw_req, 
	output logic win, lose,
	output logic [7:0] select_mux // object select number defined by its place on the input raw when. example: waterfall is 1, frog is 2. backgrond is 0.
);

enum logic [2:0] {WIN, LOSE, PLAY} prState, nxtState;
 
localparam BACKGROUND = 0;
localparam WATERFALL = 1;
localparam LOG = 2;
localparam FROG = 3;
localparam ENDBANK = 4;
 
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  // Asynchronic reset
		prState <= LOSE;
   else 		// Synchronic logic FSM
		prState <= nxtState;
		
	end // always
	
always_comb // Update next state and outputs
	begin
	//defalut values
	nxtState = prState;
	select_mux = BACKGROUND; //default value is to draw background.
	win = 0;
	lose = 0;
	case (prState)
	PLAY: begin //waterfall > log > frog > bank
				if (waterfall_draw_req)
				begin
						select_mux = WATERFALL;
						if (frog_draw_req) //lose condition
						begin
							nxtState = LOSE;
						end
				end
				else if (log_draw_req)
						begin
							select_mux = LOG;
							if (frog_draw_req) //lose condition
							begin
								nxtState = LOSE;
							end
						end
						else if (frog_draw_req)
								begin
									select_mux = FROG;
									if (endbank_draw_req) //win condition
										begin
											nxtState = WIN;
										end
								end
								else if (endbank_draw_req)
										begin
											select_mux = ENDBANK;
										end
			end
	LOSE: begin
			lose = 1;
			win = 0;
			nxtState = PLAY;
			end
	WIN:	begin
			lose = 0 ;
			win = 1;
			nxtState = PLAY;
			end
	endcase
	end // always comb
	
endmodule
//simulate waveform2