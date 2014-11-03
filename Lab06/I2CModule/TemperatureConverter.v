`timescale 1ns / 1ps
module TemperatureConverter(Temperature, SCL, SDA, F1, F0, C1, C0, Reset, clock);
input [7:0] Temperature;
input SCL, SDA, Reset, clock;
output [3:0] F1, F0, C1, C0;
wire OneShotSDA;

ClockedOneShot OneShot(SDA, OneShotSDA, Reset, clock);
reg [7:0] CurrentTemperature;

always@(posedge clock) begin
	if(Reset==1) CurrentTemperature<=8'd0;
	else if (SCL==1&&OneShotSDA==1) CurrentTemperature<=Temperature;
	else CurrentTemperature<=CurrentTemperature;
end	
	
	assign C1 = CurrentTemperature/10;
	assign C0 = CurrentTemperature%10;
	assign F1 = (CurrentTemperature*18/10+32)/10;
	assign F0 = (CurrentTemperature*18/10+32)%10;
endmodule