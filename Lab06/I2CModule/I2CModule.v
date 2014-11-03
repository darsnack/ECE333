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

module I2CModule(CLK, Go, RESET, locked, SCL, SDA, Data, ReceivedData, Display, Transistors);

input Go, RESET, CLK;
input [7:0] Data;
output SCL, locked;
inout SDA;
output [7:0] ReceivedData;
output [7:0] Display;
output [3:0] Transistors;

parameter first_byte=8'b11111111;
parameter baud_rate=20'd100000, frequency=30'd50000000;

wire clock, Go_oneshot;
Clock50MHz SystemClock(CLK, clock, locked);

wire ShiftLoad, ReadOrWrite, ShiftOrHold, Select, BaudEnable, StartStopACK;
I2CController ControlUnit(.CLK(clock), .CLKI2C(SCL), .EN(Go_oneshot), .RESET(RESET), .BaudEnable(BaudEnable), .ReadOrWrite(ReadOrWrite), 
						  .Select(Select), .ShiftOrHold(ShiftOrHold), .StartStopACK(StartStopACK), .ShiftLoad(ShiftLoad));

wire [7:0] ReceivedData;
MasterDataUnit DataUnit(.BaudRate(baud_rate), .CLKFreq(frequency), .CLK(clock), .BaudEN(BaudEnable), .RESET(RESET), .ACK(StartStopACK), 
				.Read(ReadOrWrite), .Select(Select), .SendData(Data), .Shift(ShiftOrHold), 
			   .Load(ShiftLoad), .SCL(SCL), .SDA(SDA), .ReceivedData(ReceivedData));
				
ClockedOneShot OneShot(Go, Go_oneshot, RESET, clock);

wire C0, C1, F0, F1, C0_out, C1_out, F0_out, F1_out;
TemperatureConverter TempConverter(.Temperature(ReceivedData), .SCL(SCL), .SDA(SDA), .F1(F1), .F0(F0), .C1(C1), .C0(C0), .Reset(RESET), .clock(clock));

BCDto7Segment C0Unit(C0, C0_out);
BCDto7Segment C1Unit(C1, C1_out);
BCDto7Segment F0Unit(F0, F0_out);
BCDto7Segment F1Unit(F1, F1_out);
SevenSegDriver DisplayUnit(C0_out, C1_out, F0_out, F1_out, Display, RESET, clock, Transistors);

endmodule
