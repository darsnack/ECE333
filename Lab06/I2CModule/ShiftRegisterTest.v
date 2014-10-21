`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// CM Box: 			 1608 & 1876
// Engineer:		 Kyle Daruwalla & David McNeil
// 
// Create Date:    10/21/2014
// Module Name:    ShiftRegisterTest
// Description: 
//
// Test bench for a shift register designed to handle serial data output 
// for an I2C master module.
//////////////////////////////////////////////////////////////////////////////////
module ShiftRegisterTest;

	// Inputs
	reg [7:0] DataIn;
	reg CLK;
	reg RESET;
	reg ShiftCLK;
	reg ShiftIn;
	reg Shift;
	reg Load;

	// Outputs
	wire [7:0] DataOut;
	wire ShiftOut;

	// Instantiate the Unit Under Test (UUT)
	ShiftRegister uut (
		.DataIn(DataIn), 
		.CLK(CLK), 
		.RESET(RESET), 
		.ShiftCLK(ShiftCLK), 
		.ShiftIn(ShiftIn), 
		.Shift(Shift), 
		.Load(Load), 
		.DataOut(DataOut), 
		.ShiftOut(ShiftOut)
	);

	initial begin CLK = 0; forever #5 CLK = ~CLK; end
	initial begin ShiftCLK = 0; forever #10 ShiftCLK = ~ShiftCLK; end

	initial fork
		#0 begin RESET = 1; end
		#10 begin RESET = 0; end
		#20 begin DataIn = 8'd4; ShiftIn = 1; Shift = 0; Load = 1; end
		#30 begin DataIn = 8'd4; ShiftIn = 1; Shift = 1; Load = 0; end
		#40 begin DataIn = 8'd4; ShiftIn = 0; Shift = 0; Load = 0; end
		#60 begin DataIn = 8'd4; ShiftIn = 0; Shift = 1; Load = 0; end
		#80 begin DataIn = 8'd4; ShiftIn = 0; Shift = 0; Load = 0; end
		#100 begin RESET = 1; end
		#110 $stop;
	join

endmodule

