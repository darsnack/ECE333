`timescale 1ns / 1ps
//File: vsyncModuleTemplate.v
//Author: 
//Date: 
//The line increment is synchronized with the hsync pulse
//synch pulse is generated at the end of the line: Active Video-BackPorch-SynchPulse-FrontPorch
//this is how it is done by the video timer of the pong game
//LineEnd and FrameEnd are ANDed to restart frame

module vsyncModuleTemplate(LineEnd, SynchPulse, FrontPorch, ActiveVideo, BackPorch, vsync, yposition, reset, clock);
parameter yresolution=10;
input [yresolution-1:0] SynchPulse, FrontPorch, ActiveVideo, BackPorch;
input reset, clock, LineEnd;
output vsync;
output [yresolution-1:0] yposition;
wire [yresolution-1:0] ycount;
//hsynch starts next line
ClockedOneShot RestartUnit(LineEnd, NextLineOneShot, reset, clock);
//a counter is needed to generate synch signal and y coordinate
//to be completed by students

endmodule
