`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// CM Box: 			 1608 & 1876
// Engineer:		 Kyle Daruwalla & David McNeil
//
// Create Date:    10/21/2014
// Module Name:    SDAModule
// Description:
//
// A I2C SDA module designed to generate start, stop, data, and ACK bits.
//
//////////////////////////////////////////////////////////////////////////////////
module SDAModule(Read, Select, ShiftOut, StartStopACK, ShiftIn, SDA);
input Read, Select, ShiftOut, StartStopACK;
output ShiftIn;
inout SDA;

parameter	HI_Z = 1'b0;

assign SDA = Read ? HI_Z : (Select ? ShiftOut : StartStopACK);
assign ShiftIn = SDA;

endmodule
