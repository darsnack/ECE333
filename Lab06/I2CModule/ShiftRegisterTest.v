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
	wire CLKOneShot = uut.I2C_oneshot;

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

//	initial begin CLK = 0; forever #5 CLK = ~CLK; end
//	initial begin ShiftCLK = 0; forever #10 ShiftCLK = ~ShiftCLK; end
//
//	initial fork
//		#0 begin RESET = 1; end
//		#10 begin RESET = 0; end
//		#20 begin DataIn = 8'd4; ShiftIn = 1; Shift = 0; Load = 1; end
//		#30 begin DataIn = 8'd4; ShiftIn = 1; Shift = 1; Load = 0; end
//		#40 begin DataIn = 8'd4; ShiftIn = 0; Shift = 0; Load = 0; end
//		#60 begin DataIn = 8'd4; ShiftIn = 0; Shift = 1; Load = 0; end
//		#80 begin DataIn = 8'd4; ShiftIn = 0; Shift = 0; Load = 0; end
//		#100 begin RESET = 1; end
//		#110 $stop;
//	join

	initial begin
		Load = 0;  DataIn = 0;  ShiftIn = 0;   Shift = 0;   ShiftCLK = 0;  RESET = 0;  CLK = 0;
	end
	always #4 CLK=~CLK;
	
	initial fork
		#0 RESET = 0;  #6 RESET = 1;  #14 RESET = 0;  
		#0 Load = 0;  #18 Load = 1; #25 Load = 0; #66 Load = 1;  #76 Load = 0; 
		#0 DataIn = 8'b10101011;    	#56 DataIn = 8'b00110101;  
		#0 ShiftIn = 1;   #13 ShiftIn = 1;   #19 ShiftIn = 0;   #24 ShiftIn = 1;   #38 ShiftIn = 0;    #46 ShiftIn = 1;
		#67 ShiftIn = 0; #98 ShiftIn = 1;
		#0 Shift = 0;   #32 Shift = 1;    #56 Shift = 0;  #67 Shift = 1;  
		#0 ShiftCLK = 0; #45 ShiftCLK = 1; #55 ShiftCLK = 0; #65 ShiftCLK = 1; #75 ShiftCLK = 0; #85 ShiftCLK = 1;
		#95 ShiftCLK = 0; #105 ShiftCLK = 1; #115 ShiftCLK = 0; #125 ShiftCLK = 1; #135 ShiftCLK = 0; #145 ShiftCLK = 1; 
		#160 $stop;
	join



endmodule

