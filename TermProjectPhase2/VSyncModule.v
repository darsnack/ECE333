`timescale 1ns / 1ps
//File: VSyncModule.v
//Author: 
//Date: 
//The line increment is synchronized with the hsync pulse
//synch pulse is generated at the end of the line: Active Video-BackPorch-SynchPulse-FrontPorch
//this is how it is done by the video timer of the pong game
//LineEnd and FrameEnd are ANDed to restart frame

module VSyncModule(RESET, CLK, LineEnd, SynchPulse, FrontPorch, ActiveVideo, BackPorch, vsync, yposition);
parameter yresolution = 10;
input [(yresolution - 1):0] SynchPulse, FrontPorch, ActiveVideo, BackPorch;
input RESET, CLK, LineEnd;
output vsync;
output [(yresolution - 1):0] yposition;
wire [(yresolution - 1):0] ycount;
wire [(yresolution - 1):0] EndCount = SynchPulse + FrontPorch + ActiveVideo + BackPorch;

ClockedOneShot RestartUnit(LineEnd, NextLineOneShot, RESET, CLK);
ClockedOneShot PixelClockUnit(PixelClock, PixelClockOneShot, RESET, CLK);

assign vsync = ~(ycount >= (ActiveVideo + FrontPorch) && ycount <= (ActiveVideo + FrontPorch + SynchPulse));
assign yposition = ycount;

UniversalCounter10bitsV5 XPositionCounter(
	.P(10'd0), 
	.BeginCount(10'd0), 
	.EndCount(EndCount), 
	.Q(ycount), 
	.S1(NextLineOneShot), 
	.S0(NextLineOneShot || PixelClockOneShot),
	.TerminalCount(),
	.RESET(RESET), 
	.CLK(CLK)
);

endmodule
