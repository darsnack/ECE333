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

module pongWithCRTdriver(
    input Clock, Reset, rota, rotb,
    output [2:0] red,
    output [2:0] green,
    output [1:0] blue,
    output hsync, vsync
    );

wire [9:0] xpos;
wire [9:0] ypos;

parameter [9:0] NumberofPixels=10'd640, NumberofLines=10'd480, SystemClock=10'd100; //MHz 

//module CRTcontrollerVer5(Xresolution, Yresolution, SystemClock, hsync, vsync, xposition, yposition, reset, clock);
CRTcontrollerVer5 VideoTimer(NumberofPixels, NumberofLines, SystemClock, 
     hsync, vsync, xpos, ypos, Reset, Clock);
game game_inst(Clock, Reset, xpos, ypos, rota, rotb, red, green, blue);
					
endmodule
