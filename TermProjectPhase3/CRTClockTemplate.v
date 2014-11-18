`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// CM Box: 			 1608 & 1876
// Engineer:		 Kyle Daruwalla & David McNeil
//
// Create Date:    11/10/2014
// Module Name:    ClockGenerator
// Description:
//
// Generate the internal game clock at any frequency from a system clock
//
//////////////////////////////////////////////////////////////////////////////////

module ClockGenerator(CLK, RESET, SystemCLKFreq, OutputCLKFreq, OutputCLK);
// Number of bits for SystemClock frequency in MHz
// Max = 1023 MHz
parameter SystemClockSize = 10;
input [(SystemClockSize - 1):0] SystemCLKFreq, OutputCLKFreq;
input RESET, CLK;

output reg OutputCLK;

// Internal variables for maintaining state
parameter INIT_COUNT = 16'd0;
reg [15:0] count;

always @(posedge CLK) begin
	if(RESET) begin
		count <= INIT_COUNT;
		OutputCLK <= 1'b0;
	end
	// Formula for converting SystemClock to OutputCLK:
	// ((SystemClock / PixelClock) / 2) - 1
	// Toggle clock on every half period, -1 inorder to accomadate
	// for starting at zero
	else if (count >= ((SystemCLKFreq / OutputCLKFreq) / 2) - 1) begin
		count <= INIT_COUNT;
		OutputCLK <= ~OutputCLK;
	end
	else begin
		count <= count + 1'b1;
		OutputCLK <= OutputCLK;
	end
end

endmodule

