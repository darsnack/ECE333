`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// CM Box: 			 1608 & 1876
// Engineer:		 Kyle Daruwalla & David McNeil
//
// Create Date:    11/10/2014
// Module Name:    CRTClockGenerator
// Description:
//
// Generate the internal game clock at 25MHz from a system clock
//
//////////////////////////////////////////////////////////////////////////////////

module CRTClockGenerator(CLK, RESET, SystemClock, CRTclock);
// Number of bits for SystemClock frequency in MHz
// Max = 1023 MHz
parameter SystemClockSize=10;
input [SystemClockSize-1:0] SystemClock;
input RESET, CLK;

output reg	CRTclock;

// The desired frequency for the internal game clock in MHz
parameter PixelClock=25;
// Internal variables for maintaining state
parameter INIT_COUNT = 16'd0;
reg [15:0] count;

always @(posedge CLK) begin
	if(RESET) begin
		count <= INIT_COUNT;
		CRTclock <= 1'b0;
	end
	// Formula for converting SystemClock to CRTclock:
	// ((SystemClock / PixelClock) / 2) - 1
	// Toggle clock on every half period, -1 inorder to accomadate
	// for starting at zero
	else if (count >= ((SystemClock / PixelClock) / 2) - 1) begin
		count <= INIT_COUNT;
		CRTclock <= ~CRTclock;
	end
	else begin
		count <= count + 1'b1;
		CRTclock <= CRTclock;
	end
end

endmodule

