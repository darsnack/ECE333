`timescale 1ns / 1ps

module ClockedOneShotTB;
reg X, Reset, CLOCK;
wire OneShot;

 //module ClockedOneShot(InputPulse, OneShot, Reset, CLOCK) ;      
	ClockedOneShot OneShotChip(X, OneShot, Reset, CLOCK);
	
	initial begin #0 CLOCK=0; end	//initial value for input CLOCK

	initial fork	//absolute time instances
		#0  Reset=1; #13 Reset = 0;     #57 Reset=1; #76 Reset=0;
		#0 X=0;   #24 X=1; #50 X=0;   #60 X=1;  #68 X=0;  #75 X=1;  #88 X=0; #96 X=1;  #134 X=0;
		#140 $stop;
	join

always #5 CLOCK=~CLOCK;	//generate a periodic signal as clock
endmodule

