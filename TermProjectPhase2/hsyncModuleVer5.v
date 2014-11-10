`timescale 1ns / 1ps
//File: hsyncModuleVer5.v
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

module hsyncModuleVer5(vsync, PixelClock, SynchPulse, BackPorch, ActiveVideo, FrontPorch, hsync, LineEnd, xposition, reset, clock);
parameter xresolution=10;
input [xresolution-1:0] SynchPulse, FrontPorch, ActiveVideo, BackPorch;
input vsync, PixelClock, reset, clock;
output hsync, LineEnd;
output reg [xresolution-1:0] xposition;
wire [xresolution-1:0] xcount;

ClockedOneShot RestartUnit(vsync, RestartOneShot, reset, clock);
ClockedOneShot PixelClockUnit(PixelClock, PixelClockOneShot, reset, clock);

wire [xresolution-1:0] EndCount=SynchPulse+FrontPorch+ActiveVideo+BackPorch;
//synch pulse appears at the end of the line and after front porch to mimic the pong video_timer
//hsync <= ~(xpos > 664 && xpos <= 760);  // active for 95 clocks
assign hsync = ~(xcount>=(ActiveVideo+FrontPorch)&&xcount<=(ActiveVideo+FrontPorch+SynchPulse));
assign LineEnd=xcount==EndCount;	//reset counter
always@(xcount, SynchPulse, BackPorch, ActiveVideo, FrontPorch) 
//	if(xcount>ActiveVideo) xposition<=0;
//	else xposition<=xcount;
	xposition<=xcount;	//the game circuit does not work if xposition does not run from 0 to 800. JJS
//module UniversalCounter10bitsV5(P,BeginCount, EndCount, Q,S1,S0,TerminalCount, Reset, CLOCK);
UniversalCounter10bitsV5 XPositionCounter(10'd0,10'd0, EndCount, xcount, LineEnd||RestartOneShot,LineEnd||RestartOneShot||PixelClockOneShot,   , reset, clock) ;

endmodule
