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
parameter MemorySize=27;

reg [DataLength-1:0] KeysMissed [0:MemorySize-1];
reg [DataLength-1:0] TimesMissed [0:MemorySize-1];

reg [DataLength-1:0] KeysPaddleLeft [0:MemorySize-1];
reg [DataLength-1:0] TimesPaddleLeft [0:MemorySize-1];

reg [DataLength-1:0] KeysBallCollision [0:MemorySize-1];
reg [DataLength-1:0] TimesBallCollision [0:MemorySize-1];

reg [DataLength-1:0] KeysBackground [0:MemorySize-1];
reg [DataLength-1:0] TimesBackground [0:MemorySize-1];

parameter MissedScore = 2'b00, PaddleLeftScore = 2'b01, BallCollisionScore = 2'b10, BackgroundScore = 2'b11;

always@(posedge CLK or posedge RESET)
	if(RESET==1) begin
		KeysMissed[0] <= 3; TimesMissed[0] <= 2;
		KeysMissed[1] <= 2; TimesMissed[1] <= 2;
		KeysMissed[2] <= 1; TimesMissed[2] <= 2;
		KeysMissed[3] <= 0; TimesMissed[3] <= 0;

		KeysPaddleLeft[0] <= 1; TimesPaddleLeft[0] <= 1;
		KeysPaddleLeft[1] <= 0; TimesPaddleLeft[1] <= 0;

		KeysBallCollision[0] <= 3; TimesBallCollision[0] <= 1;
		KeysBallCollision[1] <= 0; TimesBallCollision[1] <= 0;
		
		KeysBackground[0] <= 3; TimesBackground[0] <= 1;
		KeysBackground[1] <= 2; TimesBackground[1] <= 1;
		KeysBackground[2] <= 1; TimesBackground[2] <= 1;
		KeysBackground[3] <= 2; TimesBackground[3] <= 1;
		KeysBackground[4] <= 3; TimesBackground[4] <= 1;
		KeysBackground[5] <= 3; TimesBackground[5] <= 1;
		KeysBackground[6] <= 3; TimesBackground[6] <= 1;
		KeysBackground[7] <= 2; TimesBackground[7] <= 1;
		KeysBackground[8] <= 2; TimesBackground[8] <= 1;
		KeysBackground[9] <= 2; TimesBackground[9] <= 1;
		KeysBackground[10] <= 3; TimesBackground[10] <= 1;
		KeysBackground[11] <= 3; TimesBackground[11] <= 1;
		KeysBackground[12] <= 3; TimesBackground[12] <= 1;
		KeysBackground[13] <= 3; TimesBackground[13] <= 1;
		KeysBackground[14] <= 2; TimesBackground[14] <= 1;
		KeysBackground[15] <= 1; TimesBackground[15] <= 1;
		KeysBackground[16] <= 2; TimesBackground[16] <= 1;
		KeysBackground[17] <= 3; TimesBackground[17] <= 1;
		KeysBackground[18] <= 3; TimesBackground[18] <= 1;
		KeysBackground[19] <= 3; TimesBackground[19] <= 1;
		KeysBackground[20] <= 3; TimesBackground[20] <= 1;
		KeysBackground[21] <= 2; TimesBackground[21] <= 1;
		KeysBackground[22] <= 2; TimesBackground[22] <= 1;
		KeysBackground[23] <= 3; TimesBackground[23] <= 1;
		KeysBackground[24] <= 2; TimesBackground[24] <= 1;
		KeysBackground[25] <= 1; TimesBackground[25] <= 1;
		KeysBackground[26] <= 0; TimesBackground[26] <= 0;
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
		BackgroundScore: begin
			KeyOutput <= KeysBackground[Address];
			TimeOutput <= TimesBackground[Address];
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
			KeysBackground[Address] <= KeysBackground[Address];
			TimesBackground[Address] <= TimesBackground[Address];
		end
		PaddleLeftScore: begin
			KeysMissed[Address] <= KeysMissed[Address];
			TimesMissed[Address] <= TimesMissed[Address];
			KeysPaddleLeft[Address] <= KeyInput;
			TimesPaddleLeft[Address] <= TimeInput;
			KeysBallCollision[Address] <= KeysBallCollision[Address];
			TimesBallCollision[Address] <= TimesBallCollision[Address];
			KeysBackground[Address] <= KeysBackground[Address];
			TimesBackground[Address] <= TimesBackground[Address];
		end
		BallCollisionScore: begin
			KeysMissed[Address] <= KeysMissed[Address];
			TimesMissed[Address] <= TimesMissed[Address];
			KeysPaddleLeft[Address] <= KeysPaddleLeft[Address];
			TimesPaddleLeft[Address] <= TimesPaddleLeft[Address];
			KeysBallCollision[Address] <= KeyInput;
			TimesBallCollision[Address] <= TimeInput;
			KeysBackground[Address] <= KeysBackground[Address];
			TimesBackground[Address] <= TimesBackground[Address];
		end
		BackgroundScore: begin
			KeysMissed[Address] <= KeysMissed[Address];
			TimesMissed[Address] <= TimesMissed[Address];
			KeysPaddleLeft[Address] <= KeysPaddleLeft[Address];
			TimesPaddleLeft[Address] <= TimesPaddleLeft[Address];
			KeysBallCollision[Address] <= KeysBallCollision[Address];
			TimesBallCollision[Address] <= TimesBallCollision[Address];
			KeysBackground[Address] <= KeyInput;

			TimesBackground[Address] <= TimeInput;
		end
		default: begin
			KeysMissed[Address] <= KeysMissed[Address];
			TimesMissed[Address] <= TimesMissed[Address];
			KeysPaddleLeft[Address] <= KeysPaddleLeft[Address];
			TimesPaddleLeft[Address] <= TimesPaddleLeft[Address];
			KeysBallCollision[Address] <= KeysBallCollision[Address];
			TimesBallCollision[Address] <= TimesBallCollision[Address];
			KeysBackground[Address] <= KeysBackground[Address];
			TimesBackground[Address] <= TimesBackground[Address];
		end
		endcase
	end
endmodule
