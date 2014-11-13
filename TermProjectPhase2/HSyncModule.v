`timescale 1ns / 1ps
//File: HSyncModule.v
//Author: Jianjian Song
//Date: May 17, 2014
//to generate hsync signal and x position coordinate for VGA video display
//Rose-Hulman Institute of Technology
//PixelClock provides the reference time for pixel duration
//Restart is not synchronized with PixelClock
//synch pulse is generated at the end of the line: Active Video-BackPorch-SynchPulse-FrontPorch
//this is how it is done by the video timer of the pong game
// x coordinate has to cover the whole line from 0 to 800 for the game module to work
//vsync cannot be used as the game module would not work when vsync is on

module HSyncModule(vsync, PixelClock, SynchPulse, BackPorch, ActiveVideo, FrontPorch, hsync, LineEnd, xposition, RESET, CLK);
parameter xresolution=10;
input [(xresolution - 1):0] SynchPulse, FrontPorch, ActiveVideo, BackPorch;
input vsync, PixelClock, RESET, CLK;
output hsync, LineEnd;
output [(xresolution - 1):0] xposition;
wire [(xresolution - 1):0] xcount;

wire [xresolution-1:0] EndCount = SynchPulse + FrontPorch + ActiveVideo + BackPorch;

ClockedOneShot RestartUnit(vsync, RestartOneShot, RESET, CLK);
ClockedOneShot PixelClockUnit(PixelClock, PixelClockOneShot, RESET, CLK);

//synch pulse appears at the end of the line and after front porch to mimic the pong video_timer
//hsync <= ~(xpos > 664 && xpos <= 760);  // active for 95 clocks
assign hsync = ~(xcount >= (ActiveVideo+FrontPorch) && xcount<= (ActiveVideo + FrontPorch + SynchPulse));
assign LineEnd = (xcount == EndCount);	//reset counter
assign xposition = xcount;
UniversalCounter10bitsV5 XPositionCounter(
	.P(10'd0), 
	.BeginCount(10'd0), 
	.EndCount(EndCount), 
	.Q(xcount), 
	.S1(LineEnd || RestartOneShot), 
	.S0(LineEnd || RestartOneShot || PixelClockOneShot),
	.TerminalCount(),
	.RESET(RESET), 
	.CLK(CLK)
);

endmodule
