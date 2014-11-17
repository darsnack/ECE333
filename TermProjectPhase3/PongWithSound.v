`timescale 1ns / 1ps
///File: pongNewDriverTemplate.v
//pong game with new controller template
//ECE333 Fall 2014
//Term Project template
//
//Date: October 30, 2014
//the video controller uses synch timings from the pong game
//the system clock should be 100MHz
//the VGA pixel clock is 25MHz
//this is a template for students to complete
//try to match the video_timer

module PongWithSound(
    input CLK, RESET, rota, rotb,
	 input  [3:0] PaddleSize,
    output [2:0] red,
    output [2:0] green,
    output [1:0] blue,
    output hsync, vsync,
    output SpeakerOut
);

wire [9:0] xpos;
wire [9:0] ypos;
wire GeneratedCLK;

parameter [9:0] NumberofPixels=10'd640, NumberofLines=10'd480, SystemClockFreq=10'd100; //MHz 

//Clock50MHz ClockUnit(.CLK_IN1(CLK), .CLK_OUT1(GeneratedCLK), .LOCKED());

CRTcontroller VideoTimer(
	.Xresolution(NumberofPixels), 
	.Yresolution(NumberofLines), 
	.SystemClockFreq(SystemClockFreq), 
	.hsync(hsync), 
	.vsync(vsync), 
	.xposition(xpos), 
	.yposition(ypos), 
	.RESET(RESET), 
	.CLK(CLK)
);

GameWithSoundButton game(CLK, RESET, xpos, ypos, rota, rotb, PaddleSize, red, green, blue, SpeakerOut);
					
endmodule
