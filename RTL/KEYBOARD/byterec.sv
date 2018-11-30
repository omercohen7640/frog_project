// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By David Bar-On  June 2018 

module byterec 	
 ( 
   input	   logic  clk,
	input	   logic  resetN, 
	input	   logic  din_new,
	input	   logic  [7:0] din,
   output  logic [8:0]	key_Pressed,	
   output  logic 	make,	
   output  logic 	brakk	
	 
  ) ;


     enum  logic [3:0] { idle_ST     ,   // initial state
                   sample_nor_ST     ,   // sample out reg of normal scan
                   new_make_ST       ,   // anounce out new make
                   wait_rel_ST       ,   // wait for code after release code
                   sample_rel_ST     ,   // sample out new code of released key
                   new_break_ST      ,   // anounce out new make
                   wait_ext_ST       ,   // wait for code after extended code
                   sample_ext_ST     ,   // sample out new extended code
                   wait_ext_rel_ST   ,   // wait for code after ext-rel code
                   sample_ext_rel_ST }   // sample out new extended-rel code
	 present_state , next_state;

  logic [3:0] cntr, nextCntr ; 
  logic [9:0] shift_reg, Next_Shift_Reg  ; 
  logic [7:0] Next_Dout  ; 
  

    logic nor_code  ; // normal code upt o 127
   logic ext_code  ; // extended code E0
   logic rel_code  ; // relese code   F0
   logic ext  ; // extended bit acts as msb of code table
   logic oe  ; // output enable of output register

  
  // commade decoder    code classifier (combinatorial)
   always_comb  begin ; 
      nor_code = 1'b0 ;
      ext_code = 1'b0 ;
      rel_code = 1'b0 ;
 	
		
		if ( din == 16'd224 ) 
				ext_code =1'b1 ;  // 224

		if ( din == 16'd240 ) 
				rel_code =1'b1;  // 240
				
		if (( din > 16'd00 ) &&  ( din < 16'd132 )) 
				nor_code =1'b1 ;  // 1 to 131
				
        // E1 -- part of scan code of key 126 (Pause-Break)
        // 00 - buffer overflow (
        // AA - keyboad passed self test
        // EE - response to echo command
        // FA - keyboad acknowledge command
        // FC - 2 bad messages in a row
        // FE - reserved message
    end 
  
// next state and output latch 
	always_ff @(posedge clk or negedge resetN)
	begin: fsm_sync_proc
		if (resetN == 1'b0) begin 
			present_state <= idle_ST ; 
			key_Pressed <= 8'h00 ;
  
			end 	
		else begin 
	     present_state <= next_state;
        if (oe == 1'b1) 
				key_Pressed <= { ext , {din [7:0]}} ;
		  end  
	end // end fsm_sync_proc
 
   
 
  // combinational part of state machine (moore)
   always_comb  
   begin
      // default outputs (for no latches)
      make  = 1'b0 ;
      brakk = 1'b0 ;
      oe    = 1'b0 ;
      ext   = 1'b0 ;
		next_state = present_state ;
	
      case (present_state )
  
      idle_ST : begin 
 //   ----------------------
           if (din_new == 1'b1) 
			  begin; 
               if (   nor_code == 1'b1 )
                  next_state = sample_nor_ST ;
						else if (rel_code == 1'b1 )
							next_state = wait_rel_ST ;
							else if (ext_code == 1'b1 )
								next_state = wait_ext_ST ;
			 end  
      end  
		
      sample_nor_ST : begin
 //   ----------------------
          oe = 1'b1 ;
          next_state = new_make_ST ;
		end
		
      new_make_ST : begin
 //    ----------------------
          make    = 1'b1 ;
          next_state = idle_ST ;
		end 
			 
     wait_rel_ST : begin
   //        ----------------------
          if  (din_new == 1'b1) 
			  begin 
               if (nor_code == 1'b1 ) 
                  next_state = sample_rel_ST ;
               else
                  next_state = idle_ST ;
          end  
      end 
  

    sample_rel_ST : begin
 //  ----------------------
         oe = 1'b1 ;
         next_state = new_break_ST ;
	end 
 
    new_break_ST : begin
 //    ----------------------
         brakk   = 1'b1 ;
         next_state = idle_ST ;
 end 
 
 wait_ext_ST : begin
 //    ----------------------
         if (din_new == 1'b1 ) 
				begin 	
			      if   ( nor_code == 1'b1  ) 
                  next_state <= sample_ext_ST ;
               else if (rel_code == 1'b1) 
                  next_state = wait_ext_rel_ST ;
               else
                  next_state = idle_ST ;
         end ;
   end  
	
sample_ext_ST : begin
//        ----------------------
         oe  = 1'b1 ;
         ext = 1'b1 ;
         next_state = new_make_ST ;
 end  

 wait_ext_rel_ST : begin
     //        ----------------------
        if (din_new == 1'b1 )
		   begin  
               if (nor_code == 1'b1) 
                  next_state = sample_ext_rel_ST ;
               else
                  next_state = idle_ST ;
         end  
   
  end  

  sample_ext_rel_ST : begin
 //  ----------------------
          oe  = 1'b1 ;
            ext = 1'b1 ;
            next_state = new_break_ST ;
  end 
   default : begin   
  //      ----------------------
          next_state = idle_ST ;  // bad states recover
 end 
			
endcase
 
end // comb  
 
 
endmodule

/* 



   -- state register
   process ( resetN , clk )
   begin
      if resetN = 1'b0 then
         present_state <= idle ;
      elsif clk'event and clk = 1'b1 then
         present_state <= next_state ;
      end if ;
   end process ;

   -- combinational part of state machine (moore)
   process (present_state,din_new,nor_code,ext_code,rel_code )
   begin
      -- default outputs (for no latches)
      make  <= 1'b0 ;
      break <= 1'b0 ;
      oe    <= 1'b0 ;
      ext   <= 1'b0 ;
      case present_state is
         ----------------------
         when idle   =>
            if din_new = 1'b1 then
               if    nor_code = 1'b1 then
                  next_state <= sample_nor ;
               elsif rel_code = 1'b1 then
                  next_state <= wait_rel ;
               elsif ext_code = 1'b1 then
                  next_state <= wait_ext ;
               else
                  next_state <= idle ;
               end if ;
            else
               next_state <= idle ;
            end if ;
         ----------------------
         when sample_nor    =>
            oe <= 1'b1 ;
            next_state <= new_make ;
         ----------------------
         when new_make       =>
            make    <= 1'b1 ;
            next_state <= idle ;
         ----------------------
         when wait_rel      =>
            if  din_new = 1'b1 then
               if nor_code = 1'b1 then
                  next_state <= sample_rel ;
               else
                  next_state <= idle ;
               end if ;
            else
               next_state <= wait_rel ;
            end if ;
         ----------------------
         when sample_rel    =>
            oe <= 1'b1 ;
            next_state <= new_break ;
         ----------------------
         when new_break       =>
            break   <= 1'b1 ;
            next_state <= idle ;
         ----------------------
         when wait_ext      =>
            if din_new = 1'b1 then
               if    nor_code = 1'b1 then
                  next_state <= sample_ext ;
               elsif rel_code = 1'b1 then
                  next_state <= wait_ext_rel ;
               else
                  next_state <= idle ;
               end if ;
            else
               next_state <= wait_ext ;
            end if ;
         ----------------------
         when sample_ext    =>
            oe  <= 1'b1 ;
            ext <= 1'b1 ;
            next_state <= new_make ;
         ----------------------
         when wait_ext_rel  =>
            if din_new = 1'b1 then
               if nor_code = 1'b1 then
                  next_state <= sample_ext_rel ;
               else
                  next_state <= idle ;
               end if ;
            else
               next_state <= wait_ext_rel ;
            end if ;
         ----------------------
         when sample_ext_rel =>
            oe  <= 1'b1 ;
            ext <= 1'b1 ;
            next_state <= new_break ;
         ----------------------
         when others        =>
            next_state <= idle ;  -- bad states recover
      end case ;
   end process ;

   -- output register
   process ( resetN , clk )
   begin
      if resetN = 1'b0 then
         dout <= (others => 1'b0) ;
      elsif clk'event and clk = 1'b1 then
         if oe = 1'b1 then
            dout <= ext & din(7 downto 0) ;
         end if ;
      end if ;
   end process ;

end arc_byterec ;



============ full code 


library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity byterec is
   port ( resetN   : in  std_logic                    ;
          clk      : in  std_logic                    ;
          din_new  : in  std_logic                    ;
          din      : in  std_logic_vector(7 downto 0) ;
          make     : out std_logic                    ;
          break    : out std_logic                    ;
          dout     : out std_logic_vector(8 downto 0) ) ;

end byterec ;
architecture arc_byterec of byterec is

   type state is ( idle           ,   -- initial state
                   sample_nor     ,   -- sample out reg of normal scan
                   new_make       ,   -- anounce out new make
                   wait_rel       ,   -- wait for code after release code
                   sample_rel     ,   -- sample out new code of released key
                   new_break      ,   -- anounce out new make
                   wait_ext       ,   -- wait for code after extended code
                   sample_ext     ,   -- sample out new extended code
                   wait_ext_rel   ,   -- wait for code after ext-rel code
                   sample_ext_rel ) ;   -- sample out new extended-rel code
   signal present_state , next_state : state         ;

   signal nor_code : std_logic ; -- normal code upt o 127
   signal ext_code : std_logic ; -- extended code E0
   signal rel_code : std_logic ; -- relese code   F0
   signal ext : std_logic ; -- extended bit acts as msb of code table
   signal oe  : std_logic ; -- output enable of output register

begin

   -- code classifier (combinatorial)
   process ( din )
   begin
      nor_code <= 1'b0 ;
      ext_code <= 1'b0 ;
      rel_code <= 1'b0 ;
      case conv_integer(din) is
         when 1 to 16#83# =>  nor_code <=1'b1 ;  -- 1 to 131
         when 16#E0#      =>  ext_code <=1'b1 ;  -- 224
         when 16#F0#      =>  rel_code <=1'b1 ;  -- 240
         when others      =>
         -- E1 -- part of scan code of key 126 (Pause-Break)
         -- 00 - buffer overflow (
         -- AA - keyboad passed self test
         -- EE - response to echo command
         -- FA - keyboad acknowledge command
         -- FC - 2 bad messages in a row
         -- FE - reserved message
      end case ;
   end process ;

   -- state register
   process ( resetN , clk )
   begin
      if resetN = 1'b0 then
         present_state <= idle ;
      elsif clk'event and clk = 1'b1 then
         present_state <= next_state ;
      end if ;
   end process ;

   -- combinational part of state machine (moore)
   process (present_state,din_new,nor_code,ext_code,rel_code )
   begin
      -- default outputs (for no latches)
      make  <= 1'b0 ;
      break <= 1'b0 ;
      oe    <= 1'b0 ;
      ext   <= 1'b0 ;
      case present_state is
         ----------------------
         when idle   =>
            if din_new = 1'b1 then
               if    nor_code = 1'b1 then
                  next_state <= sample_nor ;
               elsif rel_code = 1'b1 then
                  next_state <= wait_rel ;
               elsif ext_code = 1'b1 then
                  next_state <= wait_ext ;
               else
                  next_state <= idle ;
               end if ;
            else
               next_state <= idle ;
            end if ;
         ----------------------
         when sample_nor    =>
            oe <= 1'b1 ;
            next_state <= new_make ;
         ----------------------
         when new_make       =>
            make    <= 1'b1 ;
            next_state <= idle ;
         ----------------------
         when wait_rel      =>
            if  din_new = 1'b1 then
               if nor_code = 1'b1 then
                  next_state <= sample_rel ;
               else
                  next_state <= idle ;
               end if ;
            else
               next_state <= wait_rel ;
            end if ;
         ----------------------
         when sample_rel    =>
            oe <= 1'b1 ;
            next_state <= new_break ;
         ----------------------
         when new_break       =>
            break   <= 1'b1 ;
            next_state <= idle ;
         ----------------------
         when wait_ext      =>
            if din_new = 1'b1 then
               if    nor_code = 1'b1 then
                  next_state <= sample_ext ;
               elsif rel_code = 1'b1 then
                  next_state <= wait_ext_rel ;
               else
                  next_state <= idle ;
               end if ;
            else
               next_state <= wait_ext ;
            end if ;
         ----------------------
         when sample_ext    =>
            oe  <= 1'b1 ;
            ext <= 1'b1 ;
            next_state <= new_make ;
         ----------------------
         when wait_ext_rel  =>
            if din_new = 1'b1 then
               if nor_code = 1'b1 then
                  next_state <= sample_ext_rel ;
               else
                  next_state <= idle ;
               end if ;
            else
               next_state <= wait_ext_rel ;
            end if ;
         ----------------------
         when sample_ext_rel =>
            oe  <= 1'b1 ;
            ext <= 1'b1 ;
            next_state <= new_break ;
         ----------------------
         when others        =>
            next_state <= idle ;  -- bad states recover
      end case ;
   end process ;

   -- output register
   process ( resetN , clk )
   begin
      if resetN = 1'b0 then
         dout <= (others => 1'b0) ;
      elsif clk'event and clk = 1'b1 then
         if oe = 1'b1 then
            dout <= ext & din(7 downto 0) ;
         end if ;
      end if ;
   end process ;

end arc_byterec ;



*/ 