`timescale 1ns / 1ps
//File: CRTClockTemplate.v
//Generate 25MHz VGA clock from a SystemClock
//
//ECE333 Spring 2014
//Term Project on Pong game on VGA
//this is a template to be completed by students

module CRTClockGenerator(SystemClock, CRTclock, Reset, Clock);

parameter SystemClockSize=10;
input [SystemClockSize-1:0] SystemClock;

output reg	CRTclock;
input Reset, Clock;

//parameter PixelClock=2;
parameter PixelClock=25;	//MHz

//a counter is needed to generate CRTclock

endmodule

