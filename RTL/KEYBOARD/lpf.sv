// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By David Bar-On  June 2018 

module lpf 	
 #(parameter FILTER_SIZE = 4)
 
 ( 
 	input	   logic  clk,
	input	   logic  resetN, 
	input	   logic  in,
	
   output  logic 	out_filt	
 
  ) ;


 enum  logic [0:0] {ONE, ZERO}  nxt_st, cur_st;

  logic [FILTER_SIZE-1:0] cntr, nextCntr ; 

//	always_ff @(posedge clk)
	always_ff @(posedge clk or negedge resetN)
	begin: fsm_sync_proc
		if (resetN == 1'b0) begin 
			cur_st <= ZERO ; 
			cntr <= {FILTER_SIZE{1'b0}}; ;
			end 	
		else begin 
			cur_st <= nxt_st;
			cntr <= nextCntr ; 
		end ; 
	end // end fsm_sync_proc
 

 
 // Asynchronous Process
	always_comb 
	begin: fsm_async_proc
		
		// default values 
		nextCntr = cntr   ; 
		nxt_st = cur_st  ;
		
				if (in == 1'b1) 
				begin 
				   if (cntr <  {FILTER_SIZE{1'b1}} )
							nextCntr = cntr + {{(FILTER_SIZE-1){1'b0}},1'b1} ; 
				 	else 
							nxt_st = ONE;
				end
				else begin 
					if (cntr >  {FILTER_SIZE{1'b0}} )
							nextCntr = cntr - {{(FILTER_SIZE-1){1'b0}},1'b1} ; 
					else  
						nxt_st = ZERO;
				end ; 
	
	// output logic 		
	
	 if (cur_st == ONE) 	
						out_filt <= 1'b1 ;	
		else 
						out_filt <= 1'b0 ;	
	
	end // end fsm_async_proc
 
 	

endmodule


