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

reg [DataLength-1:0] KeysPaddleLeft [0:MemorySize-1];
reg [DataLength-1:0] TimesPaddleLeft [0:MemorySize-1];

reg [DataLength-1:0] KeysBallCollision [0:MemorySize-1];
reg [DataLength-1:0] TimesBallCollision [0:MemorySize-1];

parameter MissedScore = 2'b00, PaddleLeftScore = 2'b01, BallCollisionScore = 2'b10, BackgroundScore = 2'b11;

always@(posedge CLK or posedge RESET)
	if(RESET==1) begin
		KeysMissed[0] <= 3; TimesMissed[0] <= 2;
		KeysMissed[1] <= 2; TimesMissed[1] <= 2;
		KeysMissed[2] <= 1; TimesMissed[2] <= 2;
		KeysMissed[3] <= 0; TimesMissed[3] <= 0;
		KeysMissed[4] <= 0; TimesMissed[4] <= 0;
		KeysMissed[5] <= 0; TimesMissed[5] <= 0;
		KeysMissed[6] <= 0; TimesMissed[6] <= 0;
		KeysMissed[7] <= 0; TimesMissed[7] <= 0;
		KeysMissed[8] <= 0; TimesMissed[8] <= 0;
		KeysMissed[9] <= 0; TimesMissed[9] <= 0;
		KeysMissed[10] <= 0; TimesMissed[10] <= 0;
		KeysMissed[11] <= 0; TimesMissed[11] <= 0;

		KeysPaddleLeft[0] <= 1; TimesPaddleLeft[0] <= 2;
		KeysPaddleLeft[1] <= 0; TimesPaddleLeft[1] <= 0;
		KeysPaddleLeft[2] <= 0; TimesPaddleLeft[2] <= 0;
		KeysPaddleLeft[3] <= 0; TimesPaddleLeft[3] <= 0;
		KeysPaddleLeft[4] <= 0; TimesPaddleLeft[4] <= 0;
		KeysPaddleLeft[5] <= 0; TimesPaddleLeft[5] <= 0;
		KeysPaddleLeft[6] <= 0; TimesPaddleLeft[6] <= 0;
		KeysPaddleLeft[7] <= 0; TimesPaddleLeft[7] <= 0;
		KeysPaddleLeft[8] <= 0; TimesPaddleLeft[8] <= 0;
		KeysPaddleLeft[9] <= 0; TimesPaddleLeft[9] <= 0;
		KeysPaddleLeft[10] <= 0; TimesPaddleLeft[10] <= 0;
		KeysPaddleLeft[11] <= 0; TimesPaddleLeft[11] <= 0;

		KeysBallCollision[0] <= 3; TimesBallCollision[0] <= 1;
		KeysBallCollision[1] <= 0; TimesBallCollision[1] <= 0;
		KeysBallCollision[2] <= 0; TimesBallCollision[2] <= 0;
		KeysBallCollision[3] <= 0; TimesBallCollision[3] <= 0;
		KeysBallCollision[4] <= 0; TimesBallCollision[4] <= 0;
		KeysBallCollision[5] <= 0; TimesBallCollision[5] <= 0;
		KeysBallCollision[6] <= 0; TimesBallCollision[6] <= 0;
		KeysBallCollision[7] <= 0; TimesBallCollision[7] <= 0;
		KeysBallCollision[8] <= 0; TimesBallCollision[8] <= 0;
		KeysBallCollision[9] <= 0; TimesBallCollision[9] <= 0;
		KeysBallCollision[10] <= 0; TimesBallCollision[10] <= 0;
		KeysBallCollision[11] <= 0; TimesBallCollision[11] <= 0;
	end 
	else if (ReadOrWrite == 1) begin	//read memory
		case(ScoreSelect) 
		MissedScore: begin 
			KeyOutput <= KeysMissed[Address];
			TimeOutput <= TimesMissed[Address];
		end
		PaddleLeftScore: begin
			KeyOutput <= KeysPaddleLeft[Address];
			TimeOutput <= TimesPaddleLeft[Address];
		end
		BallCollisionScore: begin
			KeyOutput <= KeysBallCollision[Address];
			TimeOutput <= TimesBallCollision[Address];
		end
		default: begin
			KeyOutput <= 0;
			TimeOutput <= 0;
		end
		endcase
	end
	else begin
		case(ScoreSelect) 
		MissedScore: begin 
			KeysMissed[Address] <= KeyInput;
			TimesMissed[Address] <= TimeInput;
			KeysPaddleLeft[Address] <= KeysPaddleLeft[Address];
			TimesPaddleLeft[Address] <= TimesPaddleLeft[Address];
			KeysBallCollision[Address] <= KeysBallCollision[Address];
			TimesBallCollision[Address] <= TimesBallCollision[Address];
		end
		PaddleLeftScore: begin
			KeysMissed[Address] <= KeysMissed[Address];
			TimesMissed[Address] <= TimesMissed[Address];
			KeysPaddleLeft[Address] <= KeyInput;
			TimesPaddleLeft[Address] <= TimeInput;
			KeysBallCollision[Address] <= KeysBallCollision[Address];
			TimesBallCollision[Address] <= TimesBallCollision[Address];
		end
		BallCollisionScore: begin
			KeysMissed[Address] <= KeysMissed[Address];
			TimesMissed[Address] <= TimesMissed[Address];
			KeysPaddleLeft[Address] <= KeysPaddleLeft[Address];
			TimesPaddleLeft[Address] <= TimesPaddleLeft[Address];
			KeysBallCollision[Address] <= KeyInput;
			TimesBallCollision[Address] <= TimeInput;
		end
		default: begin
			KeysMissed[Address] <= KeysMissed[Address];
			TimesMissed[Address] <= TimesMissed[Address];
			KeysPaddleLeft[Address] <= KeysPaddleLeft[Address];
			TimesPaddleLeft[Address] <= TimesPaddleLeft[Address];
			KeysBallCollision[Address] <= KeysBallCollision[Address];
			TimesBallCollision[Address] <= TimesBallCollision[Address];
		end
		endcase
	end
endmodule
