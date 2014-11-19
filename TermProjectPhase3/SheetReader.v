`timescale 1ns / 1ps
//File: MusicSheetReader.v
//Author: Jianjian Song
//Date: May 11, 2012
//Purpose: Read a music sheet from memory MusicScore
//module MusicScore(ReadOrWrite, Address, KeyInput, KeyOutput, TimeInput, TimeOutput,Clock, Reset);
//Start reading when Start=1. Read from StartAddress until the end when Keyoutput=0;
module MusicSheetReader(Start, EndofScore, StartAddress, KeyOutput, CurrentAddress, EndofNote, Clock, Reset);
input Clock, Reset, Start;
output EndofScore;
parameter DataLength=4;
input [DataLength-1:0] KeyOutput;
parameter AddressBits=5;
input [AddressBits-1:0] StartAddress;
output reg [AddressBits-1:0] CurrentAddress;
input EndofNote;
reg State;

assign EndofScore = ~State;

always@(posedge Clock or posedge Reset)
	if (Reset==1) begin State<=0;end
	else if(Start==1 && KeyOutput!=0) begin State<=1;end //start
	else if(KeyOutput==0) begin State<=0;end	//stop
	else begin State<=State;end
	
always@(posedge Clock or posedge Reset) 
	if(Reset==1) begin CurrentAddress<=0;end
	else if (State==0) begin CurrentAddress<=StartAddress;end
	else if (EndofNote==1 && KeyOutput!=0) 
		begin CurrentAddress<=CurrentAddress+1'b1; end
	else begin CurrentAddress<=CurrentAddress;end

/*reg CurrentState;
reg NextState;
parameter InitialState = 1'b0, PlayState = 1'b1;

always@(CurrentState) begin
	if(InitialState) CurrentAddress <= StartAddress;
	else CurrentAddress <= CurrentAddress + 1'b1;
end

always@(CurrentState) begin
	case(CurrentState)
	InitialState: begin
		if (Start) NextState <= PlayState;
		else NextState <= InitialState;
	end
	PlayState: begin
		if (EndofNote == 1 && KeyOutput == 0) NextState <= InitialState;
		else NextState <= PlayState;
	end
	default: NextState <= InitialState;
	endcase
end
	
always@(posedge Clock or posedge Reset) begin
	if(Reset == 1) CurrentState <= InitialState;
	else CurrentState <= NextState;
end*/

endmodule
