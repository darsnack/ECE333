`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// CM Box:           1608 & 1876
// Engineer:         Kyle Daruwalla & David McNeil
// 
// Create Date:    10/21/2014
// Module Name:    I2CController
// Description: 
//
// A test bench for the controller for the I2C module
//
//////////////////////////////////////////////////////////////////////////////////
module I2CControllerTB;

	// Inputs
	reg CLK;
	reg CLKI2C;
	reg EN;
	reg RESET;

	// Outputs
	wire BaudEnable;
	wire ReadOrWrite;
	wire Select;
	wire ShiftOrHold;
	wire StartStopACK;
	wire ShiftLoad;
	wire [3:0] current_state = uut.current_state;
	//wire [2:0] next_state = uut.next_state;
	wire [3:0] count = uut.count;
	//wire [3:0] next_count = uut.next_count;
	wire timeout = uut.timeout;
	wire I2C_oneshot = uut.I2C_oneshot;

	// Instantiate the Unit Under Test (UUT)
	I2CController uut (
		.CLK(CLK), 
		.CLKI2C(CLKI2C), 
		.EN(EN), 
		.RESET(RESET), 
		.BaudEnable(BaudEnable), 
		.Read(ReadOrWrite), 
		.Select(Select), 
		.Shift(ShiftOrHold), 
		.StartStopACK(StartStopACK), 
		.ShiftLoad(ShiftLoad)
	);

	initial begin  EN = 0;  RESET = 0;  CLKI2C = 0;  CLK = 0; end
	always #4 CLK=~CLK;
	always #12 CLKI2C=~CLKI2C;
	
	initial fork
		#0 EN = 0;  
		#12 EN = 1;  
		#0 RESET = 1;  
		#6 RESET = 0; 
		#1000 $stop;
	join
      
endmodule

