`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// CM Box: 			 1608 & 1876
// Engineer:		 Kyle Daruwalla & David McNeil
//
// Create Date:    10/27/2014
// Module Name:    SDAModule
// Description:
//
// A test for the master data unit
//
//////////////////////////////////////////////////////////////////////////////////
module MasterDataUnitTest;

	// Inputs
	reg [19:0] BaudRate;
	reg [29:0] CLKFreq;
	reg CLK;
	reg BaudEN;
	reg RESET;
	reg ACK;
	reg Start;
	reg Stop;
	reg Read;
	reg Select;
	reg [7:0] SendData;
	reg Shift;
	reg Load;

	// Outputs
	wire SCL;
	wire SDA;
	wire [7:0] ReceivedData;
	//wire ClockI2C=uut.ClockI2C;

	// Instantiate the Unit Under Test (UUT)
	MasterDataUnit uut (
		.BaudRate(BaudRate), 
		.CLKFreq(CLKFreq), 
		.CLK(CLK), 
		.BaudEN(BaudEN), 
		.RESET(RESET), 
		.ACK(ACK), 
		.Start(Start), 
		.Stop(Stop), 
		.Read(Read), 
		.Select(Select), 
		.SendData(SendData), 
		.Shift(Shift), 
		.Load(Load), 
		.SCL(SCL), 
		.SDA(SDA), 
		.ReceivedData(ReceivedData)
	);

	// MasterDataUnitI2C uut (WriteLoad, ReadorWrite, ShiftorHold, Select, BaudEN, SentData, 
	// ReceivedData, SDA, SCL, StartStopAck, Reset, clock, BaudRate, CLKFreq);

	initial begin 
		Load = 0;   Read = 0;  Shift = 0;  Select = 0;  BaudEN = 0;  SendData = 0;
		ACK = 0; RESET = 0; CLK = 0; BaudRate = 0; CLKFreq = 0;
	end
	always #4 CLK=~CLK;
	
	initial fork
		#0 RESET = 1; #13 RESET = 0;  
		#0 BaudRate = 2;
		#0 CLKFreq = 12;
		#0 Load = 0; #15 Load = 1;  #23 Load = 0;  
		#0 SendData = 8'b11001010;
		#0 Select = 0; #52 Select = 1; #484 Select = 0;
		#0 ACK = 1; #21 ACK = 0; #157 ACK = 1; #484 ACK = 0; #494 ACK = 1;
		#0 BaudEN = 0; #30 BaudEN = 1; #484 BaudEN = 0;     
		#0 Read = 0; #430 Read = 1; #484 Read = 0; 
		#0 Shift = 0; #90 Shift = 1; #442 Shift = 0; 
		#510 $stop;
	join

      
endmodule

