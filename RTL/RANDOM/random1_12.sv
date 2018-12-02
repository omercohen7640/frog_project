// outputs a psuedo random number between 1-12, uses keystrokes to randomize the number.


module random1_12
	(
	input logic clk, 
	input logic resetN,
	input logic up, down, right, left,
	output logic [3:0] random
   );

	enum logic [4:0] {ONE,TWO,THREE,FOUR,FIVE,SIX,SEVEN,EIGHT,NINE,TEN,ELEVEN,TWELVE} prState, nxtState;
 	
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  // Asynchronic reset
		prState <= ONE;
   else 		// Synchronic logic FSM
		prState <= nxtState;
		
	end // always
	
always_comb // Update next state and outputs
	begin
	//defalut values
		nxtState = prState;
		
		case (prState)
		
			ONE:	begin
					random = 4'd1;
					if 		(right) 	nxtState = THREE; //right = +2
					else if 	(left) 	nxtState = ELEVEN;//left = -2
					else if 	(up)		nxtState	= TWO;	//up = +1
					else if	(down)	nxtState = TWELVE;//down = -1
					else nxtState = TWO;
					end
			TWO :	begin
					random = 4'd2;
					if 		(right) 	nxtState = FOUR;
					else if 	(left) 	nxtState = TWELVE;
					else if 	(up)		nxtState	= THREE;
					else if	(down)	nxtState = ONE;
					else nxtState = THREE;
					end
			THREE:begin
					random = 4'd3;
					if 		(right) 	nxtState = FIVE;
					else if 	(left) 	nxtState = ONE;
					else if 	(up)		nxtState	= FOUR;
					else if	(down)	nxtState = TWO;
					else nxtState = FOUR;
					end
			FOUR:	begin
					random = 4'd4;
					if 		(right) 	nxtState = SIX;
					else if 	(left) 	nxtState = TWO;
					else if 	(up)		nxtState	= FIVE;
					else if	(down)	nxtState = THREE;
					else nxtState = FIVE;
					end
			FIVE:	begin
					random = 4'd5;
					if 		(right) 	nxtState = SEVEN;
					else if 	(left) 	nxtState = THREE;
					else if 	(up)		nxtState	= SIX;
					else if	(down)	nxtState = FOUR;
					else nxtState = SIX;
					end
			SIX:	begin
					random = 4'd6;
					if 		(right) 	nxtState = EIGHT;
					else if 	(left) 	nxtState = FOUR;
					else if 	(up)		nxtState	= SEVEN;
					else if	(down)	nxtState = FIVE;
					else nxtState = SEVEN;
					end
			SEVEN:begin
					random = 4'd7;
					if 		(right) 	nxtState = NINE;
					else if 	(left) 	nxtState = FIVE;
					else if 	(up)		nxtState	= EIGHT;
					else if	(down)	nxtState = SIX;
					else nxtState = EIGHT;
					end
			EIGHT:begin
					random = 4'd8;
					if 		(right) 	nxtState = TEN;
					else if 	(left) 	nxtState = SIX;
					else if 	(up)		nxtState	= NINE;
					else if	(down)	nxtState = SEVEN;
					else nxtState = NINE;
					end
			NINE:	begin
					random = 4'd9;
					if 		(right) 	nxtState = ELEVEN;
					else if 	(left) 	nxtState = SEVEN;
					else if 	(up)		nxtState	= TEN;
					else if	(down)	nxtState = EIGHT;
					else nxtState = TEN;
					end
			TEN:	begin
					random = 4'd10;
					if 		(right) 	nxtState = TWELVE;
					else if 	(left) 	nxtState = EIGHT;
					else if 	(up)		nxtState	= ELEVEN;
					else if	(down)	nxtState = NINE;
					else nxtState = ELEVEN;
					end
			ELEVEN:begin
					random = 4'd11;
					if 		(right) 	nxtState = ONE;
					else if 	(left) 	nxtState = NINE;
					else if 	(up)		nxtState	= TWELVE;
					else if	(down)	nxtState = TEN;
					else nxtState = TWELVE;
					end
			TWELVE:begin
					random = 4'd12;
					if 		(right) 	nxtState = TWO;
					else if 	(left) 	nxtState = TEN;
					else if 	(up)		nxtState	= ONE;
					else if	(down)	nxtState = ELEVEN;
					else nxtState = ONE;
					end
			endcase
	end // always comb
	
endmodule

//simulate with waveform1