

module	gate_mover	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input logic CLK,
					input logic resetN,
					input logic [3:0] random,
					input logic change_coord,
					output	logic	[10:0]	A_start_offsetY ,
					output	logic	[10:0]	A_start_offsetX ,
					output	logic	[10:0]	B_start_offsetY ,
					output	logic	[10:0]	B_start_offsetX 						
					
					
);


//min_x = 40
//max_x = 629
//min_y = 80
//max_y = 389
//18 bits random
logic [25:0] counter ,next_counter;
localparam one_sec = 50000000;
//localparam one_sec = 3; //simulation value

enum logic [2:0] {NEW_GATES, IDLE ,NO_SHOW} prState, nxtState;
logic [10:0] B_start_offsetX_next,B_start_offsetY_next,A_start_offsetX_next,A_start_offsetY_next;

logic [15:0] [10:0]  B_coord_x  = {
  11'd340
, 11'd355
, 11'd400
, 11'd420
, 11'd440
, 11'd460
, 11'd480
, 11'd500
, 11'd520
, 11'd540
, 11'd560
, 11'd580
, 11'd600
, 11'd620
, 11'd400
, 11'd500
};
logic [15:0] [10:0]  A_coord_y  = {
  11'd102
, 11'd360
, 11'd120
, 11'd160
, 11'd300
, 11'd220
, 11'd160
, 11'd140
, 11'd210
, 11'd340
, 11'd260
, 11'd160
, 11'd200
, 11'd300
, 11'd100
, 11'd82
};


logic [15:0] [10:0]  A_coord_x  = {
  11'd100
, 11'd115
, 11'd80
, 11'd100
, 11'd120
, 11'd140
, 11'd160
, 11'd180
, 11'd200
, 11'd220
, 11'd240
, 11'd260
, 11'd280
, 11'd300
, 11'd320
, 11'd340
};

logic [15:0] [10:0]  B_coord_y  = {
  11'd375
, 11'd115
, 11'd180
, 11'd320
, 11'd90
, 11'd190
, 11'd317
, 11'd240
, 11'd080
, 11'd180
, 11'd200
, 11'd120
, 11'd280
, 11'd100
, 11'd380
, 11'd360
};

always_ff@(posedge CLK or negedge resetN)
begin
   if ( !resetN ) begin  // Asynchronic reset
			prState <= NEW_GATES;
			A_start_offsetY <= A_coord_y [random];
			A_start_offsetX <= A_coord_x [random];
			B_start_offsetY <= B_coord_y [random];
			B_start_offsetX <= B_coord_x [random];
			counter <= one_sec;
		end
   else
		begin
		counter <= next_counter;
		if (prState == NO_SHOW)
			begin
				if(counter == 0)
					prState <= nxtState;
			end
		else
			begin
				prState <= nxtState;
			end
//		if (change_coord)
//			begin
			A_start_offsetX <= A_start_offsetX_next;
			A_start_offsetY <= A_start_offsetY_next;
			B_start_offsetX <= B_start_offsetX_next;
			B_start_offsetY <= B_start_offsetY_next;
//			end
		end
end

always_comb
begin
//defalut values
		A_start_offsetY_next = A_start_offsetY;
		A_start_offsetX_next = A_start_offsetX;
		B_start_offsetY_next = B_start_offsetY;
		B_start_offsetX_next = B_start_offsetX;
		nxtState = prState;
		next_counter = one_sec;
		case (prState)
			IDLE:begin
					A_start_offsetY_next = A_start_offsetY;
					A_start_offsetX_next = A_start_offsetX;
					B_start_offsetY_next = B_start_offsetY;
					B_start_offsetX_next = B_start_offsetX;
					next_counter = one_sec;
					if (change_coord)
						nxtState = NO_SHOW;
					else
						nxtState = IDLE;
				end
			NO_SHOW:begin
					A_start_offsetY_next = 11'd0;
					A_start_offsetX_next = 11'd0;
					B_start_offsetY_next = 11'd0;
					B_start_offsetX_next = 11'd0;
					next_counter = counter -1;
					nxtState = NEW_GATES;
				end
			NEW_GATES:begin
					next_counter = one_sec;
					A_start_offsetY_next = A_coord_y [random];
					A_start_offsetX_next = A_coord_x [random];
					B_start_offsetY_next = B_coord_y [random];
					B_start_offsetX_next = B_coord_x [random];
					nxtState = IDLE;
				end
		endcase
end
endmodule
//
