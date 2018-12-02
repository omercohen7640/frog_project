//// game FSM
////temporary- one log instead of many.
//
////lose conditions -
////hit frog and log
////hit frog and waterfall
////hit frog and french
////
////win conditions-
////hit frog and end bank
//
//
//int const int N = 3;//log(number of objects)
//module controller
//	(
//	input logic clk, resetN, waterfall_draw_req, frog_draw_req, gateA_draw_req, gateB_draw_req, french_draw_req, endbank_draw_req, log_draw_req, tank_draw_req //tank- air tank that helps the frog to dive
//	output logic win, lose, play, dive;
//	output logic [N-1:1] select_mux // object select number defined by its place on the input raw when. example: waterfall is 0, frog is 1.
//   );
//
//	enum logic [2:0] {WIN, LOSE, DIVE, PLAY} prState, nxtState;
// 	
//always @(posedge clk or negedge resetN)
//   begin
//	   
//   if ( !resetN )  // Asynchronic reset
//		prState <= IDLE;
//   else 		// Synchronic logic FSM
//		prState <= nxtState;
//		
//	end // always
//	
//always_comb // Update next state and outputs
//	begin
//	//defalut values
//	nxtState = prState;
//	
//	case (prState)
//	PLAY: begin
//				if (frog_draw_req)
//				begin
//					if (endbank_draw_req) //check for hit by end bank and frog (win)
//						begin
//						mux_select = 
//						nxtState = WIN;
//						end
//						else if (log_draw_req ||  french_draw_req ||  waterfall_draw_req)  //check for lose conditions
//								begin
//								nxtState = LOSE;
//								end
//								else if (tank_draw_req)
//										begin
//										nxtState = DIVE;
//										end
//				end
//				else if (waterfall_draw_req)
//						begin
//						select_mux = 0;
//						end
//						else if (endbank_draw_req)
//								begin
//								select_mux = 5;
//								end
//			end
//	LOSE: begin
//			lose = 1;
//			win = 0;
//			dive = 0;
//			nxtState = PLAY;
//			end
//	WIN:	begin
//			lose = 0 ;
//			win = 1;
//			dive = 0;
//			end
//	end // always comb
//	
//endmodule
