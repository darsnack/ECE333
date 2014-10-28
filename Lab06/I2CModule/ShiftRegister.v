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
output ShiftOut;

reg [7:0] InternalBuffer;
wire I2C_oneshot;

parameter INIT_VALUE = 8'b00000000;

always @(posedge CLK) begin
	if (RESET) 
		InternalBuffer <= DataIn;
	else if (Load) 
		InternalBuffer <= DataIn;
	else if (I2C_oneshot && Shift) 
		InternalBuffer <= {InternalBuffer[6:0], ShiftIn};
	else 
		InternalBuffer <= InternalBuffer;
end

assign DataOut = InternalBuffer;
assign ShiftOut = InternalBuffer[7];

ClockedOneShot OneShot(~ShiftCLK, I2C_oneshot, RESET, CLK);

endmodule
