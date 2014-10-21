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

	initial fork
		// Initialize Inputs
		#0 CLK = 0;
//		RESET = 1; #100;
//		DataIn = 8'd0; CLK = 0; RESET = 0; ShiftCLK = 0; ShiftIn = 0; Shift = 0; Load = 0; #11;
//		DataIn = 8'd4; ShiftIn = 0; Shift = 0; Load = 1; #10;
//		DataIn = 8'd4; ShiftIn = 0; Shift = 0; Load = 0; #10;
//		DataIn = 8'd4; ShiftIn = 1; Shift = 1; Load = 0; #40;
//		DataIn = 8'd4; ShiftIn = 0; Shift = 1; Load = 0; #40;
//		RESET = 1; #10;
		#100 $stop;
	join

assign #5 CLK = ~CLK;  
//assign #10 ShiftCLK = ~ShiftCLK;    
		
endmodule

