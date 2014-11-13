`timescale 1ns / 1ps

module VSyncModuleTB;

	reg LineEnd;
	reg [9:0] SynchPulse, FrontPorch, ActiveVideo, BackPorch;
	reg RESET, CLK;

	wire vsync;
	wire [9:0] yposition;

	VSyncModule uut (LineEnd, SynchPulse, FrontPorch, ActiveVideo, 
	BackPorch, vsync, yposition, RESET, CLK);
	
	initial begin
		SynchPulse = 2;
		BackPorch = 3;
		ActiveVideo = 5;
		FrontPorch = 2;
		RESET = 0; 
		CLK = 0;
		LineEnd=0;
	end

	always #1 CLK=~CLK;
	always #6 LineEnd=~LineEnd;
	
	initial fork
		#0 RESET=1;
		#12 RESET=0;
		#300 $stop;
	join
	
endmodule

