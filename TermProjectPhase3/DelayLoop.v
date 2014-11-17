`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// CM Box: 			 1608 & 1876
// Engineer:		 Kyle Daruwalla & David McNeil
//
// Create Date:    11/10/2014
// Module Name:    DelayLoop
// Description:
//
// Divide a high frequency square wave to generate a lower frequency square wave.
//
//////////////////////////////////////////////////////////////////////////////////

module DelayLoop(MR,Timeout,Clock) ;
parameter	Divider = 10000;	//delay time in number of clock cycles
parameter 	NumberOfBits = 27;
input			MR, Clock;
output reg	Timeout;
reg 	[NumberOfBits-1:0]	count;
	
always @ (count)
	if(count==Divider) Timeout<=1;
	else Timeout<=0;
	
always @ (posedge Clock)
	if(MR==1)		begin count <= 0; end
	else if (count>=Divider)	count<=0;
		else count <= count+1'b1;
endmodule
