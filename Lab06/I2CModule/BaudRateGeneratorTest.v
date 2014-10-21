`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// CM Box: 			 1608 & 1876
// Engineer:		 Kyle Daruwalla & David McNeil
// 
// Create Date:    10/21/2014
// Module Name:    BaudRateGeneratorTest
// Description: 
//
// A test bench for BaudRateGenerator.
//
//////////////////////////////////////////////////////////////////////////////////

module BaudRateGeneratorTest;
// Inputs and outputs
reg [19:0] BaudRate;
reg [29:0] ClockFreq;
reg CLK, EN, RESET;
wire CLK_OUT;

BaudRateGenerator BaudRateUnit(.BaudRate(BaudRate), .ClockFreq(ClockFreq), .CLK(CLK), .EN(EN), .RESET(RESET), .CLK_OUT(CLK_OUT));

parameter	LOW = 1'b0,
			HIGH = 1'b1;

parameter PERIOD = 20; // 20ns

initial begin CLK = 0; forever #(PERIOD / 2) CLK = ~CLK; end

initial fork
	#0 BaudRate = 1;

	#0 ClockFreq = 50000000; // 50MHz

	#0 EN = LOW;
	#11 EN = HIGH;
	#31 EN = LOW;
	#41 EN = HIGH;

	#0 RESET = LOW;
	#51 RESET = HIGH;
	#61 RESET = LOW;

	#100 $stop;
join