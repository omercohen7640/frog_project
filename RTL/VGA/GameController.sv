// this module is the game's FSM
//inputs: all objects draw requests
//output:
//take_gate - control signal that tell  the frog to move to a gate's location.
//AorB- set the gate that the frog should take when it jumps to gate.
//log_enable_out - number of logs enabled is equal to the number of ones in this vector.
//                  also: nmuber of logs enable = level * 5
// 
//lose conditions -
//hit frog and log
//hit frog and waterfall
//hit frog and french
//
//win conditions-
//hit frog and end bank


module GameController(
	input logic clk, resetN,
	input	logic waterfall_draw_req, log_draw_req, frog_draw_req, endbank_draw_req, french_draw_req, gate_a_draw_req, gate_b_draw_req,
	output logic win, lose, AorB, take_gate,
	output logic [7:0] select_mux, 
	output logic [9:0] sound_freq_out,
	output logic [99:0] log_enable_out,
	output logic enable_sound,
	output logic [7:0] level 
	);

enum logic [2:0] {WIN, LOSE, PLAY, BUZ} prState, nxtState;
 
localparam BACKGROUND = 0;
localparam WATERFALL = 1;
localparam LOG = 2;
localparam FROG = 3;
localparam ENDBANK = 4;
localparam FRENCH = 5;
localparam GATEA = 6;
localparam GATEB = 7;
localparam A = 0;
localparam B = 1;
localparam TAKE = 1;
localparam DONT_TAKE = 0;




localparam one_sec = 50000000;
//localparam one_sec = 5; // value for simulation
localparam LOG_NUM = 100;

localparam LOSE_FREQ = 950;
localparam WIN_FREQ = 500;

logic [25:0] counter;

logic [7:0] level_next;


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
		log_number <= 0;
		sound_freq <= 0;
		level <= 1;
		end
   else 		// Synchronic logic FSM
	begin
		log_number = next_log_number;
		if (prState == BUZ)
			begin
				if (counter > 0)
					counter <= counter -1;
				else
				begin
					level <= level_next;
					sound_freq <= sound_freq_next;
					prState <= nxtState;
				end
			end
		else
			begin
				level <= level_next;
				sound_freq <= sound_freq_next;
				counter <= one_sec;
				prState <= nxtState;
			end
	end
	end // always
	
always_comb
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
	take_gate = DONT_TAKE;
	AorB = A;
	case (prState)
	PLAY: begin //waterfall > endbank > french >log > gate > frog  
				if (waterfall_draw_req)
				begin
					select_mux = WATERFALL;
					if (frog_draw_req) //lose condition
					begin
						nxtState = LOSE;
					end
				end
				else if (endbank_draw_req) 
				begin
					select_mux = ENDBANK;
					if (frog_draw_req) //win condition
					begin
						nxtState = WIN;
					end
				end
				else if (french_draw_req) 
				begin
					select_mux = FRENCH;
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
				else if (gate_a_draw_req)
				begin
					select_mux = GATEA;
					if (frog_draw_req && !take_gate) // jump to gate B
					begin
						AorB = B;
						take_gate = TAKE;
					end
				end
				else if (gate_b_draw_req)
				begin
					select_mux = GATEB;
					if (frog_draw_req && !take_gate) // jump to gate A
					begin
						AorB = A;
						take_gate = TAKE;
					end
				end
				else if (frog_draw_req)
				begin
					select_mux = FROG;
				end
			end
	LOSE: begin
			lose = 1;
			win = 0;
			nxtState = BUZ;
			sound_freq_next = LOSE_FREQ;
			if (level_next > 1) begin
				level_next = level - 1;
				next_log_number = (log_number - 31)/32;//subtract 5 ones from log_number
				end
			end
	WIN:	begin
			lose = 0 ;
			win = 1;
			nxtState = BUZ;
			sound_freq_next = WIN_FREQ;
			level_next = level + 1;
			next_log_number = log_number*32 + 31; //add 5 ones to log_number
			end
	BUZ: begin //one second delay and sound enabled
			lose = 0;
			win = 0;
			nxtState = PLAY;
			enable_sound = 1;
			end
	endcase
	end // always comb
	
endmodule
//simulate waveform2