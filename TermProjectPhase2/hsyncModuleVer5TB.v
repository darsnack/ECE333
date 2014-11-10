`timescale 1ns / 1ps
//Test bench for hsyncModuleVer4.v

module hsyncModuleVer5TB;

	reg vsync, PixelClock;
	reg [9:0] SynchPulse, BackPorch, ActiveVideo, FrontPorch;
	reg reset, clock;

	wire hsync, LineEnd;
	wire [9:0] xposition;
	wire PixelClockOneShot=uut.PixelClockOneShot;
	wire [9:0] xcount=uut.xcount;
	wire RestartOneShot=uut.RestartOneShot;
//module hsyncModuleVer5(vsync, PixelClock, SynchPulse, BackPorch, ActiveVideo, 
//FrontPorch, hsync, LineEnd, xposition, reset, clock);

	hsyncModuleVer5 uut (vsync, PixelClock, SynchPulse, BackPorch, ActiveVideo, 
	FrontPorch, hsync, LineEnd, xposition, reset, clock);

		initial begin
		vsync = 0; PixelClock=0;   SynchPulse = 2;  BackPorch = 3;  ActiveVideo = 5;
		FrontPorch = 2;   reset = 0; clock = 0;    end
	always #1 clock=~clock;
	always #4 PixelClock=~PixelClock;
	initial fork
	#0 reset=1; 	#12 reset=0; 
	#0 vsync=0;  #35 vsync=1; #56 vsync=0;
	#187 vsync=1; #200 vsync=0;
   #300 $stop;
	join
      
endmodule

