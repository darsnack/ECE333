`timescale 1ns / 1ps
//Music score in RAM
module MusicScore(ReadOrWrite, Address, KeyInput, KeyOutput, TimeInput, TimeOutput, ScoreSelect, CLK, RESET);
input ReadOrWrite, CLK, RESET;
input [1:0] ScoreSelect;
parameter DataLength=4;
input [DataLength-1:0] KeyInput, TimeInput;
output reg [DataLength-1:0] KeyOutput, TimeOutput;
parameter AddressBits=5;
input [AddressBits-1:0] Address;
parameter MemorySize=20;

reg [DataLength-1:0] KeysMissed [0:MemorySize-1];
reg [DataLength-1:0] TimesMissed [0:MemorySize-1];

parameter MissedScore = 2'b00, PaddleLeftScore = 2'b01, PaddleRightScore = 2'b10, BackgroundScore = 2'b11;

always@(posedge CLK or posedge RESET)
	if(RESET==1) begin
		KeysMissed[0]<=1; TimesMissed[0]<=2;
		KeysMissed[1]<=2; TimesMissed[1]<=1;
		KeysMissed[2]<=3; TimesMissed[2]<=1;
		KeysMissed[3]<=3; TimesMissed[3]<=1;
		KeysMissed[4]<=2; TimesMissed[4]<=1;
		KeysMissed[5]<=1; TimesMissed[5]<=1;
		KeysMissed[6]<=1; TimesMissed[6]<=1;
		KeysMissed[7]<=2; TimesMissed[7]<=1;
		KeysMissed[8]<=3; TimesMissed[8]<=1;
		KeysMissed[9]<=2; TimesMissed[9]<=1;
		KeysMissed[10]<=1; TimesMissed[10]<=2;
		KeysMissed[11]<=0; TimesMissed[11]<=0;
	end 
	else if (ReadOrWrite == 1) begin	//read memory
		//case(ScoreSelect) 
		//MissedScore: begin 
			KeyOutput <= KeysMissed[Address];
			TimeOutput <= TimesMissed[Address];
		//end
		//default: begin
			//KeyOutput <= KeysMissed[Address];
			//TimeOutput <= TimesMissed[Address];
		//end
		//endcase
	end
	else begin
		KeysMissed[Address] <= KeyInput; TimesMissed[Address] <= TimeInput;
	end
endmodule
