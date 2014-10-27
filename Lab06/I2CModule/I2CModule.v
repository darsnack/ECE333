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

module I2CModule(CLK, Go, RESET, locked, SCL, SDA);

input Go, RESET, CLK;
output SCL, locked;
inout SDA;

parameter first_byte=8'b10010011;
parameter baud_rate=20'd100000, frequency=30'd50000000;

wire clock;
Clock50MHz SystemClock(CLK, clock, locked);

wire ShiftLoad, ReadOrWrite, ShiftOrHold, Select, BaudEnable, StartStopACK;
I2CController ControlUnit(.CLK(clock), .CLKI2C(SCL), .EN(Go), .RESET(RESET), .BaudEnable(BaudEnable), .ReadOrWrite(ReadOrWrite), 
						  .Select(Select), .ShiftOrHold(ShiftOrHold), .StartStopACK(StartStopACK), .ShiftLoad(ShiftLoad));

wire [7:0] ReceivedData;
MasterDataUnit DataUnit(.BaudRate(), .CLKFreq(), .CLK(clock), .BaudEN(BaudEnable), .RESET(RESET), .ACK(StartStopACK), 
			   .Start(), .Stop(), .Read(ReadOrWrite), .Select(Select), .SendData(), .Shift(ShiftOrHold), 
			   .Load(ShiftLoad), .SCL(SCL), .SDA(SDA), .ReceivedData(ReceivedData));

endmodule
