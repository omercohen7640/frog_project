//object mux recieves color vectors from all of the objects in the game. 
//the gamecontroller controls which color vector the mux should pass on to the VGA modules to present in current coordinate.

module	objects_mux	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	CLK,
					input		logic	RESETn,
					input		logic	[7:0] object_to_draw,
					input		logic	[7:0] endbank_mVGA_RGB,
					input		logic	[7:0] frog_mVGA_RGB, 
					input		logic	[7:0] waterfall_mVGA_RGB,
					input		logic	[7:0] background_mVGA_RGB,
					input		logic	[7:0] log_mVGA_RGB,
					input		logic [7:0] french_mVGA_RGB,
					input		logic [7:0] gate_a_mVGA_RGB,
					input		logic [7:0] gate_b_mVGA_RGB,
					output	logic	[7:0] m_mVGA_R, 
					output	logic	[7:0] m_mVGA_G, 
					output	logic	[7:0] m_mVGA_B
					
);


localparam BACKGROUND = 0;
localparam WATERFALL = 1;
localparam LOG = 2;
localparam FROG = 3;
localparam ENDBANK = 4;
localparam FRENCH = 5;
localparam GATEA = 6;
localparam GATEB = 7;


logic [7:0] m_mVGA_t;
localparam N = 3;

assign m_mVGA_R	= {m_mVGA_t[7:5], 5'b0}; //-- expand to 8 bits 
assign m_mVGA_G	= {m_mVGA_t[4:2], 5'b0};
assign m_mVGA_B	= {m_mVGA_t[1:0], 6'b0};

//
always_ff@(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
			m_mVGA_t	<= 8'b0;
	end
	else 
	begin
		case (object_to_draw)
				WATERFALL:	m_mVGA_t <= waterfall_mVGA_RGB;
				FROG:			m_mVGA_t <= frog_mVGA_RGB;
				LOG:			m_mVGA_t <= log_mVGA_RGB;
				ENDBANK:		m_mVGA_t <= endbank_mVGA_RGB;
				FRENCH:		m_mVGA_t <= french_mVGA_RGB;
				GATEA:		m_mVGA_t <= gate_a_mVGA_RGB;
				GATEB:		m_mVGA_t <= gate_b_mVGA_RGB;
				default:		m_mVGA_t	<= background_mVGA_RGB; //if not any object then output <= background
		endcase 
	end
end
endmodule

//simulate with waveform


