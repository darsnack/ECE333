`timescale 1ns / 1ps
//File: PlaySound.v
//Author: Jianjian Song
//Date:	November 2012
//Play a music score stored in the RAM in MusicSheet.v
//PlayAgain - play the score stored in MusicSheet when a positive pulse appears on PlayAgain

module PlaySound(PlayAgain, Speaker, ScoreSelect, RESET, CLK);
input PlayAgain, RESET, CLK;
input [1:0] ScoreSelect;
output Speaker;

parameter AddressBits=5;
parameter DataLength=4;
wire [2:0] NoteArray;	//three notes
wire [DataLength-1:0] KeyOutput, TimeOutput;
wire [AddressBits-1:0] ReadingAddress;
wire EndofScore, DebouncedPlayAgain, OneShotPlayAgain;

// Debouncer PlayDebounce(PlayAgain, DebouncedPlayAgain, RESET, CLK);
//ClockedOneShot PlayOneShot(PlayAgain, OneShotPlayAgain, RESET, CLK);

//module MusicSheetReader(Start, EndofScore, StartAddress, KeyOutput, TimeOutput, CurrentAddress, EndofNote, CLK, RESET);
MusicSheetReader Reader(PlayAgain, EndofScore, 5'd0 , KeyOutput, ReadingAddress, Over, CLK, RESET);

//module MusicScore(ReadOrWrite, Address, KeyInput, KeyOutput, TimeInput, TimeOutput,CLK, RESET);
// MusicScore Sheet(1'b1,ReadingAddress, 4'd0, KeyOutput, 4'd0, TimeOutput,CLK, RESET);
MusicScore Sheet(.ReadOrWrite(1'b1), .Address(ReadingAddress), .KeyInput(4'd0), .KeyOutput(KeyOutput),  .TimeInput(4'd0), .TimeOutput(TimeOutput), .ScoreSelect(ScoreSelect), .CLK(CLK), .RESET(RESET));
//module PlayNote(Note, Duration, Start, Over, NoteArray, RESET, CLK);
PlayNote2 PlayNoteUnit(KeyOutput, TimeOutput, ~EndofScore, Over, NoteArray, RESET, CLK);

//module ThreeMusicNotes(keyC, keyD, keyE, Speaker, RESET, CLK) ;
ThreeMusicNotes NoteUnit(NoteArray[0], NoteArray[1], NoteArray[2], Speaker, RESET, CLK) ;

endmodule
