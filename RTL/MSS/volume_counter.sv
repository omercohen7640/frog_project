// Alex Grinshpun Jul 2018

module	volume_counter	 #(
					COUNT_SIZE = 8
		)
	
		(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input		logic	VOLUP,
					input		logic	VOLDOWN,
					input		logic	VOLVALID,		
					output	logic [COUNT_SIZE-1:0]	volume

		);

parameter int oneSec  = 5_000_000;// real 
// parameter int oneSec  = 5;// simulation 


logic [COUNT_SIZE-1:0] count_up_limit		= {COUNT_SIZE{1'b1}};
logic [COUNT_SIZE-1:0] count_down_limit	= {COUNT_SIZE{1'b0}};
int 	cnt;
logic cnt_en;

//always_ff@(posedge CLK or negedge RESETn)
//begin
//	if(!RESETn)
//	begin
//		cnt		<= 0;
//		cnt_en	<= 1'b0;
//	end
//	else	if (cnt >= oneSec) begin
//				cnt		<= 0;
//				cnt_en	<= 1'b1;
//			end 
//			else begin
//				cnt		<= cnt + 1;
//				cnt_en	<= 1'b0;			
//			end
//
//end
assign cnt_en = 1'b1;

always_ff@(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		volume <= count_down_limit;
	end
	else	if (cnt_en == 1'b1 && VOLVALID == 1'b1) begin
				if (VOLUP == 1'b1 && VOLDOWN == 1'b0) begin
					if (volume >= count_up_limit)  
						volume <= count_up_limit;
					else 
						volume <= volume + 1;
				end else 
				if (VOLDOWN == 1'b1 && VOLUP == 1'b0) begin
					if (volume == count_down_limit)  
						volume <= count_down_limit;
					else 
						volume <= volume - 1;
				end
			end

end

endmodule