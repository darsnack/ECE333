`timescale 1ns / 1ps

module HSyncModuleTB;

	// Inputs
	reg vsync;
	reg PixelClock;
	reg [9:0] SynchPulse;
	reg [9:0] BackPorch;
	reg [9:0] ActiveVideo;
	reg [9:0] FrontPorch;
	reg RESET;
	reg CLK;

	// Outputs
	wire hsync;
	wire LineEnd;
	wire [9:0] xposition;

	// Instantiate the Unit Under Test (UUT)
	HSyncModule uut (
		.vsync(vsync), 
		.PixelClock(PixelClock), 
		.SynchPulse(SynchPulse), 
		.BackPorch(BackPorch), 
		.ActiveVideo(ActiveVideo), 
		.FrontPorch(FrontPorch), 
		.hsync(hsync), 
		.LineEnd(LineEnd), 
		.xposition(xposition), 
		.RESET(RESET), 
		.CLK(CLK)
	);

	initial begin
		vsync = 0; PixelClock=0;   SynchPulse = 2;  BackPorch = 3;  ActiveVideo = 5;
		FrontPorch = 2;   RESET = 0; CLK = 0;    
	end
	always #1 CLK=~CLK;
	always #4 PixelClock=~PixelClock;
	
	initial fork
		#0 RESET=1; 	#12 RESET=0; 
		#0 vsync=0;  #35 vsync=1; #56 vsync=0;
		#187 vsync=1; #200 vsync=0;
		#300 $stop;
	join
      
endmodule

