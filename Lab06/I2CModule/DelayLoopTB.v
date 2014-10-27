`timescale 1ns / 1ps

module DelayLoopTB;

	// Inputs
	reg MR;
	reg Clock;

	// Outputs
	wire Timeout;

	// Instantiate the Unit Under Test (UUT)
	DelayLoop uut (
		.MR(MR), 
		.Timeout(Timeout), 
		.Clock(Clock)
	);

	initial begin
		MR = 0; Clock = 0; #10;
		MR = 1; #10;
		MR = 0; #10;
		MR = 0; #10;
		MR = 0; #10;
		MR = 0; #10;
		MR = 0; #10;
		MR = 0; #10;
		MR = 0; #10;
		MR = 0; #10;
		MR = 0; #10;
		MR = 0; #10;
		MR = 0; #10;
		MR = 0; #10;
		MR = 0; #10;
		MR = 0; #10;
		MR = 0; #10;
		MR = 0; #10;
		$stop;
	end
      
always #10 Clock=~Clock;  
      
endmodule

