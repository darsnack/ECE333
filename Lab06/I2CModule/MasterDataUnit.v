`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// CM Box: 			 1608 & 1876
// Engineer:		 Kyle Daruwalla & David McNeil
//
// Create Date:    10/27/2014
// Module Name:    MasterDataUnit
// Description:
//
// A I2C MasterDataUnit.
//
//////////////////////////////////////////////////////////////////////////////////
module MasterDataUnit(BaudRate, CLKFreq, CLK, BaudEN, RESET, ACK, Start, Stop, Read, Select, SendData, Shift, Load, SCL, SDA, ReceivedData);
input [19:0] BaudRate;
input [29:0] CLKFreq;
input [7:0] SendData;
input CLK, BaudEN, RESET, ACK, Start, Stop, Read, Select, Shift, Load;
output [7:0] ReceivedData;
output SCL, SDA;

wire ShiftIn, ShiftOut;

BaudRateGenerator BaudRateUnit(.BaudRate(BaudRate), .ClockFreq(CLKFreq), .CLK(CLK), .EN(BaudEN), .RESET(RESET), .CLK_OUT(SCL));
SDAModule SDAUnit(.Read(Read), .Select(Select), .ShiftOut(ShiftOut), .ShiftIn(ShiftIn), .SDA(SDA));
ShiftRegister ShiftRegisterUnit(.DataIn(SendData), .CLK(CLK), .RESET(RESET), .ShiftCLK(SCL), .ShiftIn(ShiftIn), .Shift(Shift), .Load(Load), .DataOut(ReceivedData), .ShiftOut(ShiftOut));

endmodule
