

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
logic [15:0] [10:0]  A_coord_x  = {
  11'd40
, 11'd60
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

logic [15:0] [10:0]  B_coord_x  = {
  11'd360
, 11'd380
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
  11'd80
, 11'd100
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
logic [15:0] [10:0]  B_coord_y  = {
  11'd140
, 11'd200
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
			A_start_offsetY <= 0;
			A_start_offsetX <= 0;
			B_start_offsetY <= 0;
			B_start_offsetX <= 0;
		end
   else if (change_coord)
			begin
			A_start_offsetX <= A_coord_x [random] ;
			A_start_offsetY <= A_coord_y [random] ;
			B_start_offsetX <= B_coord_x [random] ;
			B_start_offsetY <= B_coord_y [random] ;
			end
end
//
endmodule
//
