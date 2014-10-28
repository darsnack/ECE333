`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// CM Box: 			 1608 & 1876
// Engineer:		 Kyle Daruwalla & David McNeil
// 
// Create Date:    10/21/2014
// Module Name:    BaudRateGenerator
// Description: 
//
// A baud rate generator configurable using BaudRate and ClockFreq inputs.
//
//////////////////////////////////////////////////////////////////////////////////
module BaudRateGenerator(BaudRate, ClockFreq, CLK, EN, RESET, CLK_OUT);
input [19:0] BaudRate;
input [29:0] ClockFreq;
input CLK, EN, RESET;
output reg CLK_OUT;

reg [15:0] baud_count;

parameter INIT_BAUD_COUNT = 16'd0;

always @(posedge CLK)
	if(RESET) begin
		baud_count <= INIT_BAUD_COUNT;
		CLK_OUT <= 1'b1;
	end
	else if (EN) begin
		if (baud_count == ClockFreq/(BaudRate*2)) begin
				baud_count <= 1'b0;
				CLK_OUT <= ~CLK_OUT;
		end
		else begin
			baud_count <= baud_count + 1'b1;
			CLK_OUT <= CLK_OUT;
		end
	end
	else begin
		baud_count <= INIT_BAUD_COUNT;
		CLK_OUT <= 1'b1;
	end
endmodule
