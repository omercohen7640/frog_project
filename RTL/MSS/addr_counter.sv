module	addr_counter	 #(
					COUNT_SIZE = 8
		)
	
		(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input		logic	en,
					input		logic	en1,
					output	logic [COUNT_SIZE-1:0]	addr

		);



logic [COUNT_SIZE-1:0] count_limit = {COUNT_SIZE{1'b1}};
//
always_ff@(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		addr	<= 0;
	end
	else if (en == 1'b1 && en1 == 1'b1) begin
				if (addr >= count_limit)  
					addr <= 0;
				else 
					addr <= addr + 1;
			end

end
endmodule

