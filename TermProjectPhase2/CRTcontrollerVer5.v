`timescale 1ns / 1ps
//File Name: CRTcontrollerVer5.v
//Author: Jianjian Song
//Date: May 17, 2014
//Test: On Nexys 3 board successfully
//Purpose: generate VGA timing signals hsync and vsync
// and synchronized(x,y) coordinates.
//inputs: resolution (x,y) and system clock in MHz
////active videos are Xresolution and Yresolution
//x ranges from 600 to 800 pixels. y ranges from 400 to 600 pixels
//system clock ranges from 25 to 100MHz
//synch pulse, back porch and front porch are defined within this module
// hsync <= ~(xpos > 664 && xpos <= 760);  // active for 95 clocks
// vsync <= ~(ypos == 490 || ypos == 491);   // active for lines 490 and 491

module CRTcontroller(Xresolution, Yresolution, SystemClockFreq, hsync, vsync, xposition, yposition, RESET, CLK);
parameter ResolutionSize=10, SystemClockSize=10;
input [ResolutionSize-1:0] Xresolution, Yresolution;
input [SystemClockSize-1:0] SystemClockFreq;
input RESET, CLK;
output hsync, vsync;
output [ResolutionSize-1:0] xposition, yposition;
//hsync is generated after active video and front porch from >664 to >=760 
parameter hSynchPulse=10'd95, hFrontPorch=10'd25, hBackPorch=10'd40; //hsynch=800
//vsync is generated after active video and front porch from =>490 to >=491 
parameter vSynchPulse=10'd2, vFrontPorch=10'd10, vBackPorch=10'd29; //vsynch=520

wire PixelClock, LineEnd;

CRTClockGenerator CRTclockUnit(.SystemClockFreq(SystemClockFreq), .CRTclock(PixelClock), .RESET(RESET), .CLK(CLK));

HSyncModule hsyncModule(
	.vsync(vsync), 
	.PixelClock(PixelClock), 
	.SynchPulse(hSynchPulse), 
	.BackPorch(hBackPorch), 
	.ActiveVideo(Xresolution), 
	.FrontPorch(hFrontPorch), 
	.hsync(hsync), 
	.LineEnd(LineEnd), 
	.xposition(xposition), 
	.RESET(RESET), 
	.CLK(CLK)
);

VSyncModule vsyncModule(
	.RESET(RESET), 
	.CLK(PixelClock), 
	.LineEnd(LineEnd), 
	.SynchPulse(vSynchPulse), 
	.FrontPorch(vFrontPorch),
 	.ActiveVideo(Yresolution), 
 	.BackPorch(vBackPorch), 
 	.vsync(vsync), 
 	.yposition(yposition)
);

endmodule
