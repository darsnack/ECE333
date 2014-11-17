`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// CM Box: 			 1608 & 1876
// Engineer:		 Kyle Daruwalla & David McNeil
//
// Create Date:    11/10/2014
// Module Name:    game
// Description:
//
// updates the ball and paddle positions, and determines the output video image
//
//////////////////////////////////////////////////////////////////////////////////

module GameWithSoundButton(input clk25, input Reset,
				input [9:0] xpos,
				input [9:0] ypos,
				input rota,
				input rotb,
				input ServeBallButton,
				input [3:0] PaddleSize,
				output [2:0] red,
				output [2:0] green,
				output [1:0] blue,
				output SpeakerOut);
		
// paddle movement		
reg [10:0] paddlePosition;
reg [2:0] quadAr, quadBr;
always @(posedge clk25) quadAr <= {quadAr[1:0], rota};
always @(posedge clk25) quadBr <= {quadBr[1:0], rotb};

always @(posedge clk25)
if(quadAr[2] ^ quadAr[1] ^ quadBr[2] ^ quadBr[1])
begin
	if(quadAr[2] ^ quadBr[1]) begin
		if(paddlePosition + (PaddleSize*10+25) < 632) // make sure the value doesn't overflow
			paddlePosition <= paddlePosition + 3'd4;
	end
	else begin
		if(paddlePosition > 2'd3)        // make sure the value doesn't underflow
			paddlePosition <= paddlePosition - 3'd4;
	end
end
		
// ball movement	
reg [9:0] ballX;
reg [8:0] ballY;
reg ballXdir, ballYdir;
reg bounceX, bounceY;
	
wire endOfFrame = (xpos == 0 && ypos == 480);

wire MissedSoundOut;

// Logic to handle serving the ball on push button press
reg ServeBall;
always @(ServeBallButton, missTimer) begin
	if (ServeBallButton)
		ServeBall <= 1;
	else
		ServeBall <= ServeBall;
	if (missTimer != 0)
		ServeBall <= 0;
end	
	
always @(posedge clk25) begin
	if (endOfFrame) begin // update ball position at end of each frame
		if (ballX == 0 && ballY == 0) begin // cheesy reset handling, assumes initial value of 0
			ballX <= 480;
			ballY <= 300;
		end
		else begin
			if (missTimer != 0) begin
				ballY <= 10;
				ballX <= $random;
			end
			else if(ServeBall) begin
				if (ballXdir ^ bounceX) 
					ballX <= ballX + 2'd2;
				else 
					ballX <= ballX - 2'd2;	
		
				if (ballYdir ^ bounceY) 
					ballY <= ballY + 2'd2;
				else
					ballY <= ballY - 2'd2;
			end
		end
	end	
end		
		
// pixel color	
reg [5:0] missTimer = 05'b11111;	
wire visible = (xpos < 640 && ypos < 480);
wire top = (visible && ypos <= 4);
wire bottom = (visible && ypos >= 476);
wire left = (visible && xpos <= 4);
wire right = (visible && xpos >= 636);
wire border = (visible && (left || right || top));
wire paddle = (xpos >= paddlePosition+4 && xpos <= paddlePosition+(PaddleSize*10+25) && ypos >= 440 && ypos <= 447);
wire ball = (xpos >= ballX && xpos <= ballX+7 && ypos >= ballY && ypos <= ballY+7);
wire background = (visible && !(border || paddle || ball));
wire checkerboard = (xpos[5] ^ ypos[5]);
wire missed = visible && missTimer != 0;

assign red   = { missed || border || paddle, 2'b00 };
assign green = { !missed && (border || paddle || ball), 2'b00 };
assign blue  = { !missed && (border || ball), background && checkerboard}; 
		
// ball collision	
always @(posedge clk25) begin
	if (!endOfFrame) begin
		if (ball && (left || right))
			bounceX <= 1;
		if (ball && (top || bottom || (paddle && ballYdir)))
			bounceY <= 1;
		if (ball && bottom)
			missTimer <= 63;
	end
	else begin
		if (ballX == 0 && ballY == 0) begin // cheesy reset handling, assumes initial value of 0
			ballXdir <= 1;
			ballYdir <= 1;
			bounceX <= 0;
			bounceY <= 0;
		end 
		else begin
			if (bounceX)
				ballXdir <= ~ballXdir;
			if (bounceY)
				ballYdir <= ~ballYdir;			
			bounceX <= 0;
			bounceY <= 0;
			if (missTimer != 0)
				missTimer <= missTimer - 1'b1;
		end
	end
end

PlaySound MissedSoundUnit(.PlayAgain(1), .Speaker(SpeakerOut), .ScoreSelect(2'b00), .RESET(RESET), .CLK(clk25));

// assign SpeakerOut = MissedSoundOut;
		
endmodule
