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
inout reg SDA;

parameter	HI_Z = 1'bZ;

parameter	READ = 2'b1x,
			START_STOP_ACK = 2'b01,
			DATA = 2'b00;

always @(Read or Select or ShittOut or StartStopACK) begin
	casex({Read, Select})
	READ: begin
		ShiftIn <= HI_Z;
		SDA <= HI_Z;
	end
	START_STOP_ACK: begin
		ShiftIn <= StartStopACK;
		SDA <= StartStopACK;
	end
	DATA: begin
		ShiftIn <= ShittOut;
		SDA <= ShittOut;
	end
	default: begin
		ShiftIn <= HI_Z;
		SDA <= HI_Z;
	end
	endcase
end

endmodule
