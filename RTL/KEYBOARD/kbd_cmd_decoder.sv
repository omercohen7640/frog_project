// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By David Bar-On  June 2018 


module kbd_cmd_decoder 	
 ( 
   input	   logic  clk,
	input	   logic  resetN, 
   input  logic [8:0]	key_Pressed,	
   input  logic 	make,	
   input  logic 	brakee,  // warning break is a reserved word 
	
//  output  logic 	ball_toggle, // presing enter key valid for one clock 
//  output  logic [3:0]	IR_key,	// last key  [0..9]  
//  output  logic 	ir_write,	// valid while key [0..9] is pressed
   output  logic 	up,    // valid while key is presed (from make to brake)  
	output  logic 	down,
	output  logic 	right,
	output  logic 	left	
  	 
  ) ;


   localparam KEY_WUP = 9'h01D ; 
   localparam KEY_SDOWN = 9'h01B ;
	localparam KEY_ALEFT = 9'h01C ; 
   localparam KEY_DRIGHT = 9'h023 ; 

//   localparam KEY_1 = 9'h016 ; 
//   localparam KEY_2 = 9'h01e ; 
//   localparam KEY_3 = 9'h026 ; 
//   localparam KEY_4 = 9'h025 ; 
//   localparam KEY_5 = 9'h02e ; 
//   localparam KEY_6 = 9'h036 ; 
//   localparam KEY_7 = 9'h03d ; 
//   localparam KEY_8 = 9'h03e ; 
//   localparam KEY_9 = 9'h046 ; 
//   localparam KEY_0 = 9'h045 ; 
	
	//logic enter_pressed_d , enter_pressed ; //  _d == delay of one clock 
 
  
	always_ff @(posedge clk or negedge resetN)
	begin: fsm_sync_proc
		if (resetN == 1'b0) begin 
			//IR_key <= 4'b0000 ; 	
			//ir_write	 <= 0 ; 
			up <= 0;
			down <= 0;
			right <= 0;
			left <= 0;
			//enter_pressed_d <= 0  ; 
			//enter_pressed  <= 0 ; 
			//ball_toggle <= 0 ;
 
		end 
		else begin 

// keys logic 
//
//		 if (key_Pressed  == KEY_0 ) begin IR_key <= 4'h0 ; if (make == 1'b1) ir_write <= 1'b1 ; if (brakee == 1'b1) ir_write <= 1'b0 ; end ; 
//		 if (key_Pressed  == KEY_1 ) begin IR_key <= 4'h1 ; if (make == 1'b1) ir_write <= 1'b1 ; if (brakee == 1'b1) ir_write <= 1'b0 ; end ; 
//		 if (key_Pressed  == KEY_2 ) begin IR_key <= 4'h2 ; if (make == 1'b1) ir_write <= 1'b1 ; if (brakee == 1'b1) ir_write <= 1'b0 ; end ; 
//		 if (key_Pressed  == KEY_3 ) begin IR_key <= 4'h3 ; if (make == 1'b1) ir_write <= 1'b1 ; if (brakee == 1'b1) ir_write <= 1'b0 ; end ; 
//		 if (key_Pressed  == KEY_4 ) begin IR_key <= 4'h4 ; if (make == 1'b1) ir_write <= 1'b1 ; if (brakee == 1'b1) ir_write <= 1'b0 ; end ; 
//		 if (key_Pressed  == KEY_5 ) begin IR_key <= 4'h5 ; if (make == 1'b1) ir_write <= 1'b1 ; if (brakee == 1'b1) ir_write <= 1'b0 ; end ; 
//		 if (key_Pressed  == KEY_6 ) begin IR_key <= 4'h6 ; if (make == 1'b1) ir_write <= 1'b1 ; if (brakee == 1'b1) ir_write <= 1'b0 ; end ; 
//		 if (key_Pressed  == KEY_7 ) begin IR_key <= 4'h7 ; if (make == 1'b1) ir_write <= 1'b1 ; if (brakee == 1'b1) ir_write <= 1'b0 ; end ; 
//		 if (key_Pressed  == KEY_8 ) begin IR_key <= 4'h8 ; if (make == 1'b1) ir_write <= 1'b1 ; if (brakee == 1'b1) ir_write <= 1'b0 ; end ; 
//		 if (key_Pressed  == KEY_9 ) begin IR_key <= 4'h9 ; if (make == 1'b1) ir_write <= 1'b1 ; if (brakee == 1'b1) ir_write <= 1'b0 ; end ; 
		  
		 
		 if (key_Pressed  == KEY_WUP ) begin  if (make == 1'b1) up <= 1'b1 ; if (brakee == 1'b1) up <= 1'b0 ; end ; 
		 if (key_Pressed  == KEY_SDOWN ) begin  if (make == 1'b1) down <= 1'b1 ; if (brakee == 1'b1) down <= 1'b0 ; end ; 
		 if (key_Pressed  == KEY_ALEFT ) begin  if (make == 1'b1) left <= 1'b1 ; if (brakee == 1'b1) left <= 1'b0 ; end ; 
		 if (key_Pressed  == KEY_DRIGHT ) begin  if (make == 1'b1) right <= 1'b1 ; if (brakee == 1'b1) right <= 1'b0 ; end ; 
//		 if (key_Pressed  == KEY_ENTER ) begin  if (make == 1'b1) enter_pressed <= 1'b1 ; if (brakee == 1'b1) enter_pressed <= 1'b0 ; end ; 
		 
//		 enter_pressed_d  <= enter_pressed ; // delay of one clock 
// 	    ball_toggle = (( enter_pressed_d == 1'b0 ) && ( enter_pressed == 1'b1 )) ? ~ball_toggle : ball_toggle ; // swap on rising edge 

 	end // if 
	end // always_ff 
	

endmodule


