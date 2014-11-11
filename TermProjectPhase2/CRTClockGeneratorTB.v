`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// CM Box: 			 1608 & 1876
// Engineer:		 Kyle Daruwalla & David McNeil
//
// Create Date:    11/10/2014
// Module Name:    CRTClockGeneratorTB
// Description:
//
// Test bench for generating the internal game clock at 25MHz from a system clock
//
//////////////////////////////////////////////////////////////////////////////////

module CRTClockGeneratorTB;

	// Inputs
	reg CLK;
	reg RESET;
	reg [9:0] SystemClock;

	// Outputs
	wire CRTclock;
	wire [15:0] count = uut.count;
	wire [15:0] crt_clock_threshold = ((uut.SystemClock / uut.PixelClock) / 2) - 1;

	// Instantiate the Unit Under Test (UUT)
	CRTClockGenerator uut (
		.CLK(CLK), 
		.RESET(RESET), 
		.SystemClock(SystemClock), 
		.CRTclock(CRTclock)
	);

	initial begin SystemClock = 100; RESET = 0; CLK = 0; end
 
	initial fork
		#0 RESET=1; #20 RESET=0;
		#800 $stop;
	join
		
	always #5 CLK=~CLK;      
endmodule
