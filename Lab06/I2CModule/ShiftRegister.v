`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// CM Box: 			 1608 & 1876
// Engineer:		 Kyle Daruwalla & David McNeil
// 
// Create Date:    10/21/2014
// Module Name:    ShiftRegister
// Description: 
//
// A shift register designed to handle serial data output for an I2C master module.
//
//////////////////////////////////////////////////////////////////////////////////
module ShiftRegister(DataIn, CLK, RESET, ShiftCLK, ShiftIn, Shift, Load, DataOut, ShiftOut);
input [7:0] DataIn;
input CLK, RESET, ShiftCLK, ShiftIn, Shift, Load;
output [7:0] DataOut;
output reg ShiftOut;

reg [6:0] InternalBuffer;

parameter INIT_VALUE = 8'b00000000;

always @(posedge CLK) begin
	if (RESET) InternalBuffer <= INIT_VALUE;
	else if (Load) {ShiftOut, InternalBuffer} <= DataIn;
	else {ShiftOut, InternalBuffer} <= {ShiftOut, InternalBuffer};
end

always @(posedge ShiftCLK) begin
	if (Shift) {ShiftOut, InternalBuffer} <= {InternalBuffer[6:0], ShiftIn};
	else {ShiftOut, InternalBuffer} <= {ShiftOut, InternalBuffer};
end

assign DataOut = {ShiftOut, InternalBuffer};

endmodule
