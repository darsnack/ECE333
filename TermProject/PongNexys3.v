`timescale 1ns / 1ps
// This is the pong game from
// http://www.bigmessowires.com/2009/06/21/fpga-pong/
// -----------------------------------------------
// top-level module
// -----------------------------------------------
module PongNexys3(
    input clk,
    input rota,
    input rotb,
    output [2:0] red,
    output [2:0] green,
    output [1:0] blue,
    output hsync,
    output vsync
    );
wire clk50;

Clock50MHz ClockUnit(.CLK_IN1(clk), .CLK_OUT1(clk50), .LOCKED());

// divide input clock by two, and use a global 
// clock buffer for the derived clock
reg clk25_int;
always @(posedge clk50) begin
	clk25_int <= ~clk25_int;
end

wire clk25;
BUFG bufg_inst(clk25, clk25_int);

wire [9:0] xpos;
wire [9:0] ypos;

video_timer video_timer_inst(clk25, hsync, vsync, xpos, ypos);
game game_inst(clk25, xpos, ypos, rota, rotb, red, green, blue);
					
endmodule
