`timescale 1ns / 1ps

//

module CRTClockGeneratorTB;

	reg [30:0] SystemClock;
	reg Reset, Clock;

	wire CRTclock;

	CRTClockGenerator uut (SystemClock, CRTclock, Reset, Clock);

	initial begin SystemClock = 100; Reset = 0; Clock = 0; end
 
	initial fork
	#0 Reset=1; #20 Reset=0;
	#800 $stop;
	join
	always #4 Clock=~Clock;   
endmodule

