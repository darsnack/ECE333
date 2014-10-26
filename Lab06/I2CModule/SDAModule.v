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
output reg ShiftIn;
inout SDA;

parameter	HI_Z = 1'bZ;

parameter	READ = 2'b1x,
			START_STOP_ACK = 2'b00,
			DATA = 2'b01;

always @(Read or Select or ShiftOut or StartStopACK) begin
	casex({Read, Select})
	READ: ShiftIn <= HI_Z;
	START_STOP_ACK: ShiftIn <= StartStopACK;
	DATA: ShiftIn <= ShiftOut;
	default: ShiftIn <= HI_Z;
    endcase
end

assign SDA = ShiftIn;

endmodule
