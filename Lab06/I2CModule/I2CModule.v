`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// CM Box: 			 1608 & 1876
// Engineer:		 Kyle Daruwalla & David McNeil
//
// Create Date:    10/27/2014
// Module Name:    I2CModule
// Description:
//
// The top level I2C interface.
//
//////////////////////////////////////////////////////////////////////////////////

module I2CModule(CLK, Go, RESET, locked, SCL, SDA, Data);

input Go, RESET, CLK;
input [7:0] Data;
output SCL, locked;
inout SDA;

parameter first_byte=8'b11111111;
parameter baud_rate=20'd100000, frequency=30'd50000000;

wire clock, Go_oneshot;
Clock50MHz SystemClock(CLK, clock, locked);

wire ShiftLoad, ReadOrWrite, ShiftOrHold, Select, BaudEnable, StartStopACK;
I2CController ControlUnit(.CLK(clock), .CLKI2C(SCL), .EN(Go_oneshot), .RESET(RESET), .BaudEnable(BaudEnable), .ReadOrWrite(ReadOrWrite), 
						  .Select(Select), .ShiftOrHold(ShiftOrHold), .StartStopACK(StartStopACK), .ShiftLoad(ShiftLoad));

wire [7:0] ReceivedData;
MasterDataUnit DataUnit(.BaudRate(baud_rate), .CLKFreq(frequency), .CLK(clock), .BaudEN(BaudEnable), .RESET(RESET), .ACK(StartStopACK), 
			   .Start(), .Stop(), .Read(ReadOrWrite), .Select(Select), .SendData(Data), .Shift(ShiftOrHold), 
			   .Load(ShiftLoad), .SCL(SCL), .SDA(SDA), .ReceivedData(ReceivedData));
				
ClockedOneShot OneShot(Go, Go_oneshot, RESET, clock);

endmodule
