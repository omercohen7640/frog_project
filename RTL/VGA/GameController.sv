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
	input	logic waterfall_draw_req, log_draw_req, frog_draw_req, endbank_draw_req, french_draw_req,
	output logic win, lose,
	output logic [7:0] select_mux, // object select number defined by its place on the input raw when. example: waterfall is 1, frog is 2. backgrond is 0.
	output logic [9:0] sound_freq_out,
	output logic [1:0] log_enable_out,
	output logic enable_sound
	);

enum logic [2:0] {WIN, LOSE, PLAY, BUZ} prState, nxtState;
 
localparam BACKGROUND = 0;
localparam WATERFALL = 1;
localparam LOG = 2;
localparam FROG = 3;
localparam ENDBANK = 4;
localparam FRENCH = 5;


//localparam one_sec = 50000000;
localparam one_sec = 5; // value for simulation
localparam LOG_NUM = 2;

localparam LOSE_FREQ = 0;
localparam WIN_FREQ = 1;

logic [25:0] counter;

logic [10:0] level;
logic [10:0] level_next;


logic [LOG_NUM-1:0] log_number;
logic [LOG_NUM-1:0] next_log_number;

logic [9:0] sound_freq;
logic [9:0] sound_freq_next;




assign log_enable_out = log_number;
assign sound_freq_out = sound_freq;


always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN ) begin  // Asynchronic reset
		prState <= PLAY;
		log_number = 0;
		sound_freq = 0;
		level = 1;
		end
   else 		// Synchronic logic FSM
	begin
		log_number = next_log_number;
		if (prState == BUZ)
			begin
				if (counter > 0)
					counter <= counter -1;
				else
					level = level_next;
					sound_freq = sound_freq_next;
					prState <= nxtState;
			end
		else
			begin
				level = level_next;
				sound_freq = sound_freq_next;
				counter <= one_sec;
				prState <= nxtState;
			end
	end
	end // always
	
always_comb // Update next state and outputs
	begin
	//defalut values
	nxtState = prState;
	select_mux = BACKGROUND; //default value is to draw background.
	win = 0;
	lose = 0;
	enable_sound = 0;
	next_log_number = log_number;
	sound_freq_next = LOSE_FREQ;
	level_next = level;
	case (prState)
	PLAY: begin //waterfall > french >log > frog > bank
				if (waterfall_draw_req)
				begin
						select_mux = WATERFALL;
						if (frog_draw_req) //lose condition
						begin
							nxtState = LOSE;
						end
				end
				else if (french_draw_req)
						begin
							select_mux = FRENCH;
							if (log_draw_req)
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
			nxtState = BUZ;
			sound_freq_next = LOSE_FREQ;
			if (level_next > 1) begin
				level_next = level_next - 1;
				next_log_number = (next_log_number - 31)/32;
				end
			end
	WIN:	begin
			lose = 0 ;
			win = 1;
			nxtState = BUZ;
			sound_freq_next = WIN_FREQ;
			level_next = level_next + 1;
			next_log_number = next_log_number*32 + 31;
			end
	BUZ: begin
			lose = 0;
			win = 0;
			nxtState = PLAY;
			enable_sound = 1;
			end
	endcase
	end // always comb
	
endmodule
//simulate waveform2