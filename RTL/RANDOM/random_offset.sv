

module	random_offset	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input logic CLK,

					//output	logic	[900:1]	start_offsetY,
					//output	logic	[900:1]	start_offsetX
					
					output	logic	[8:0]	start_offsetY [99:0],
					output	logic	[8:0]	start_offsetX [99:0]
					
					
);



//900 bits random
//logic offset_x = 900'b011100110011011011001100001111101111110110001000000100100111010000010011011001001111100011110010101011000001001110111000110001111011110000100001100000011001100001000010011001101101110111001101010100010100001011011000000110000101111001000000000000101110000101000000010000110101010010010001110100111101000000101011010001000111000111111010110011110010000001101010110010001011000010110000101101101101001010001110000100110111001001011100100000010010011101100010001010111110110100101000101000000111000110100100110110010101011111010011010110011011100101000001000111001101100101001110010011111110000010100011010101111001001101000111100100100111111001010100010010110010101111100000011111000000111000101000001101011111011101101010100011011101110100100001100100010101100101010111011010010110010010001111100101011001111111110011100000110001010011100110000001110100001101001001110101000100010111000010110111111111;
//logic offset_y = 900'b110011100000110001010011100110000001110100001101001001110101000100010111000010110100010010100000100110111111001000101011111111111011111100100100010011001001011101011100111000100110000100101000001000110111011001111110011110110111011000100011000000111010101010010110110101010111101111011101010110110001110111101001111100110000011001110011110010000001011100100101110100000100001010001100011101000010010101011111100110110100001011110010100011100100101011110111110110101011111010111010000100001110100101011101011110111101011000010000111100111101111010010010110110011010110000010111000101111110001100001101010110100011111000100101000000100001001100000110101110010110110000110011001011101100111110010101001010101001100001101100000011010101011001011010101011100110100100011111110110001101010111110111111110001111110010100111101000111100011111110111011110110111000100101110101101100001111010011001010101000011;

localparam NUM_OF_LOGS = 100;

//18 bits random
logic [NUM_OF_LOGS-1:0] [8:0]  offset_x  = {
9'b010000011
, 9'b011000111
, 9'b100000101
, 9'b100001100
, 9'b101101010
, 9'b111111001
, 9'b010111001
, 9'b011010000
, 9'b000010110
, 9'b001110000
, 9'b101010100
, 9'b101100001
, 9'b110000111
, 9'b001101001
, 9'b100010000
, 9'b011011101
, 9'b100010110
, 9'b110001000
, 9'b111100010
, 9'b111000010
, 9'b001000100
, 9'b110100001
, 9'b101111011
, 9'b111000110
, 9'b101001101
, 9'b111000001
, 9'b011000101
, 9'b011000010
, 9'b010000100
, 9'b110010100
, 9'b010001101
, 9'b110101011
, 9'b011010100
, 9'b001011011
, 9'b001100011
, 9'b111100100
, 9'b010111011
, 9'b001001100
, 9'b100011011
, 9'b110011101
, 9'b100011000
, 9'b011000101
, 9'b111000010
, 9'b100010101
, 9'b001101101
, 9'b101101001
, 9'b101001110
, 9'b001001110
, 9'b100110100
, 9'b111001000
, 9'b001001110
, 9'b001000001
, 9'b010000001
, 9'b011010010
, 9'b001101000
, 9'b111011100
, 9'b100000000
, 9'b111010100
, 9'b001111110
, 9'b110010000
, 9'b101110011
, 9'b100011001
, 9'b111111111
, 9'b100110011
, 9'b001010111
, 9'b010111011
, 9'b000001001
, 9'b101100000
, 9'b011101101
, 9'b010110101
, 9'b110000011
, 9'b000000110
, 9'b010000010
, 9'b010000101
, 9'b011110000
, 9'b111111010
, 9'b001111011
, 9'b101111100
, 9'b110001111
, 9'b111001100
, 9'b100001100
, 9'b111000110
, 9'b000101100
, 9'b101100110
, 9'b000000111
, 9'b100101101
, 9'b000000011
, 9'b111011101
, 9'b101000001
, 9'b001011101
, 9'b010011010
, 9'b010101100
, 9'b111101000
, 9'b100010011
, 9'b000001110
, 9'b011100110
, 9'b001011111
, 9'b011111110
, 9'b010000101
, 9'b111110000
};
logic [NUM_OF_LOGS-1:0] [8:0]  offset_y  = {
9'b111000111
, 9'b010111011
, 9'b011011000
, 9'b111110010
, 9'b100000010
, 9'b010001101
, 9'b010001100
, 9'b011110110
, 9'b000010111
, 9'b001000101
, 9'b001000010
, 9'b010100011
, 9'b100100100
, 9'b111100001
, 9'b101001010
, 9'b100000101
, 9'b110110001
, 9'b110011100
, 9'b011011110
, 9'b110111011
, 9'b101000110
, 9'b011111001
, 9'b100011001
, 9'b011100000
, 9'b100011100
, 9'b001010000
, 9'b101101010
, 9'b010111110
, 9'b001001111
, 9'b010010010
, 9'b101011010
, 9'b000110101
, 9'b010100101
, 9'b011010011
, 9'b101100101
, 9'b110011111
, 9'b000000111
, 9'b111111000
, 9'b001100110
, 9'b101000111
, 9'b110111100
, 9'b100001000
, 9'b101100000
, 9'b001010110
, 9'b010101011
, 9'b001101011
, 9'b101111101
, 9'b001010100
, 9'b000100101
, 9'b000001011
, 9'b110110100
, 9'b001010010
, 9'b110000000
, 9'b001001001
, 9'b010001010
, 9'b101000001
, 9'b011001111
, 9'b100010000
, 9'b111101010
, 9'b100110111
, 9'b101010010
, 9'b011011011
, 9'b111000011
, 9'b110110101
, 9'b101011010
, 9'b110001100
, 9'b011000001
, 9'b000000101
, 9'b001111000
, 9'b101000001
, 9'b111101011
, 9'b011010011
, 9'b000010000
, 9'b100111101
, 9'b001001011
, 9'b010100101
, 9'b101101100
, 9'b011001110
, 9'b010110101
, 9'b100001011
, 9'b101110100
, 9'b100001111
, 9'b110111110
, 9'b011010100
, 9'b011010001
, 9'b101001100
, 9'b000010111
, 9'b111011010
, 9'b110100111
, 9'b100000011
, 9'b110010101
, 9'b110010001
, 9'b110110010
, 9'b000011101
, 9'b011101000
, 9'b110101011
, 9'b000101001
, 9'b111010111
, 9'b011001011
, 9'b010111100
};

always_comb
begin
	for (int i = 0; i< NUM_OF_LOGS-1; i++) begin
		start_offsetX[i] = offset_x[i];
		start_offsetY[i] = offset_y[i];
	end
end
//
endmodule
//
