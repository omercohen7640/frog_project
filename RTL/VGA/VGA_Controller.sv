module	VGA_Controller	(	//	Host Side
					input		logic [7:0]		iRed,
					input		logic	[7:0]		iGreen,
					input		logic	[7:0]		iBlue,
					output	logic	[10:0]	oCurrent_X,
					output	logic	[10:0]	oCurrent_Y,
					output	logic	[21:0]	oAddress,
					output	logic				oRequest,
						//	VGA Side
					output	logic	[7:0]	oVGA_R,
					output	logic	[7:0]	oVGA_G,
					output	logic	[7:0]	oVGA_B,
					output	logic			oVGA_HS,
					output	logic			oVGA_VS,
					output	logic			oVGA_SYNC,
					output	logic			oVGA_BLANK,
					output	logic			oVGA_CLOCK,
					output	logic			StartOfFrame,
						//	Control Signal
					input		logic	iCLK,
					input		logic	iRST_N	);

//	Internal Registers
logic			[10:0]	H_Cont;
logic			[10:0]	V_Cont;
////////////////////////////////////////////////////////////
//	Horizontal	Parameter
const int	H_FRONT	=	16;
const int	H_SYNC	=	96;
const int	H_BACK	=	48;
const int	H_ACT	=	640;
const int	H_BLANK	=	H_FRONT+H_SYNC+H_BACK;
const int	H_TOTAL	=	H_FRONT+H_SYNC+H_BACK+H_ACT;
////////////////////////////////////////////////////////////
//	Vertical Parameter
const int	V_FRONT	=	11;
const int	V_SYNC	=	2;
const int	V_BACK	=	31;
const int	V_ACT	=	480;
const int	V_BLANK	=	V_FRONT+V_SYNC+V_BACK;
const int	V_TOTAL	=	V_FRONT+V_SYNC+V_BACK+V_ACT;

logic VGA_VS_pulse;
logic VGA_VS_d;
int VGA_VS_pulse_cnt;
int  NUMBER_FRAMES = 1;  // -- define after how many frames TimerDone is generate 
logic			timer_done;

////////////////////////////////////////////////////////////
assign	oVGA_SYNC	=	1'b1;			//	This pin is unused.
assign	oVGA_BLANK	=	~((H_Cont<H_BLANK)||(V_Cont<V_BLANK));
assign	oVGA_CLOCK	=	~iCLK;
assign	oVGA_R		=	iRed;
assign	oVGA_G		=	iGreen;
assign	oVGA_B		=	iBlue;
assign	oAddress	=	oCurrent_Y*H_ACT+oCurrent_X;
assign	oRequest	=	((H_Cont>=H_BLANK && H_Cont<H_TOTAL)	&&
						 (V_Cont>=V_BLANK && V_Cont<V_TOTAL));
assign	oCurrent_X	=	(H_Cont>=H_BLANK)	?	H_Cont-H_BLANK	:	11'h0	;
assign	oCurrent_Y	=	(V_Cont>=V_BLANK)	?	V_Cont-V_BLANK	:	11'h0	;


//Dudy Bar-On Prescaler 25 MHZ generator from 50 MHZ 
logic clk_25;
always_ff@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		clk_25	<=	1'b0;
	end
	else
	begin
		clk_25 <=	!clk_25;
	end
end
	


//	Horizontal Generator: Refer to the pixel clock
always_ff@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		H_Cont		<=	0;
		oVGA_HS		<=	1;
	end
	else
	begin
		if(H_Cont<H_TOTAL) begin
			if (clk_25== 1'b0) begin              //Dudy Bar-On
					H_Cont	<=	H_Cont+1'b1;
			end 
			end
		else
		H_Cont	<=	0;
		//	Horizontal Sync
		if(H_Cont==H_FRONT-1)			//	Front porch end
		oVGA_HS	<=	1'b0;
		if(H_Cont==H_FRONT+H_SYNC-1)	//	Sync pulse end
		oVGA_HS	<=	1'b1;
	end
end

//	Vertical Generator: Refer to the horizontal sync
always_ff@(posedge oVGA_HS or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		V_Cont		<=	0;
		oVGA_VS		<=	1;
	end
	else
	begin
		if(V_Cont<V_TOTAL)
			V_Cont	<=	V_Cont+1'b1;
		else
			V_Cont	<=	0;
		//	Vertical Sync
		if(V_Cont==V_FRONT-1)			//	Front porch end
			oVGA_VS	<=	1'b0;
		if(V_Cont==V_FRONT+V_SYNC-1)	//	Sync pulse end
			oVGA_VS	<=	1'b1;
	end
end




//---- Timer -------
always_ff@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		VGA_VS_d	<= 0;
	end
	else
	begin
		VGA_VS_d	<= oVGA_VS;
	end
end

assign VGA_VS_pulse	= !oVGA_VS && VGA_VS_d;
// generating a single timer_done sync pulse after NUMBER_FRAMES frames 
//always_ff@(posedge iCLK or negedge iRST_N)
//begin
//	if(!iRST_N)
//	begin
//			VGA_VS_pulse_cnt	<= 0;
//			timer_done 			<= 1'b0; 
//	end
//	else
//	begin
//			timer_done <= 1'b0; // clear 
//			if (VGA_VS_pulse == 1'b1) begin 
//				if (VGA_VS_pulse_cnt == NUMBER_FRAMES) begin
//					VGA_VS_pulse_cnt	<= 0;
//					timer_done			<= 1'b1 ; 
//					end
//				else
//					VGA_VS_pulse_cnt  <= VGA_VS_pulse_cnt + 1;
//				end
//			end
//	end


assign StartOfFrame	= VGA_VS_pulse;
//sign StartOfFrame	= timer_done;
endmodule