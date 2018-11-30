//-- This module is dividing the 50MHz CLOCK OSC, and sends clock
//-- enable it to the appropriate outputs in order to achieve
//-- operation at slower rate of individual modules (this is done
//-- to keep the whole system globally synchronous).
//-- All DACs output are set to 100 KHz. 

//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018

module	prescaler	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input		logic [9:0]	count_limit_ir,
					output	logic	prescaler_1, 
					output	logic	prescaler_2

		);

							logic [9:0]	count_limit;
/*
	lpm_constant	 #(
				.lpm_cvalue("1E"),
				.lpm_hint ("ENABLE_RUNTIME_MOD=YES, INSTANCE_NAME=12"),
				.lpm_type("LPM_CONSTANT"),
				.lpm_width(10)
				) LPM_CONSTANT_component
				(
				.result (count_limit));
*/
assign count_limit = 10'b0000011110;
		

int	PRESCALER_COUNTER;



//
always_ff@(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
			PRESCALER_COUNTER	<= 10'b0;
			prescaler_1			<= 1'b0;
			prescaler_2			<= 1'b0;
	end
	else
	begin
		prescaler_2	<=	prescaler_1; // 1 clk delay
		if (PRESCALER_COUNTER >= count_limit + count_limit_ir) begin
				PRESCALER_COUNTER <= 10'b0;
				prescaler_1			<= 1'b1;
		end
		else begin
				PRESCALER_COUNTER <= PRESCALER_COUNTER + 1'b1;
				prescaler_1			<= 1'b0;
		end
				
	end
end
endmodule
