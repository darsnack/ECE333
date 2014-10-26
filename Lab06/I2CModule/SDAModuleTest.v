`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// CM Box: 			 1608 & 1876
// Engineer:		 Kyle Daruwalla & David McNeil
//
// Create Date:    10/21/2014
// Module Name:    SDAModuleTest
// Description:
//
// A testbench for SDAModule
//
//////////////////////////////////////////////////////////////////////////////////
module SDAModuleTest;
reg Read, Select, ShiftOut, StartStopACK;
wire ShiftIn, SDA;

parameter   LOW = 1'b0,
            HIGH = 1'b1;

SDAModule SDAUnit(.Read(Read), .Select(Select), .ShiftOut(ShiftOut), .StartStopACK(StartStopACK), .ShiftIn(ShiftIn), .SDA(SDA));

initial fork
    #0 begin
        Read = LOW;
        Select = LOW;
        StartStopACK = HIGH;
        ShiftOut = LOW;
    end
    #12 begin
        Read = HIGH;
        Select = LOW;
        StartStopACK = HIGH;
        ShiftOut = LOW;
    end
    #21 begin
        Read = HIGH;
        Select = HIGH;
        StartStopACK = HIGH;
        ShiftOut = HIGH;
    end
    #34 begin
        Read = LOW;
        Select = HIGH;
        StartStopACK = HIGH;
        ShiftOut = LOW;
    end
    #35 begin
        Read = LOW;
        Select = LOW;
        StartStopACK = HIGH;
        ShiftOut = LOW;
    end
    #38 begin
        Read = LOW;
        Select = LOW;
        StartStopACK = LOW;
        ShiftOut = LOW;
    end
    #43 begin
        Read = LOW;
        Select = LOW;
        StartStopACK = HIGH;
        ShiftOut = LOW;
    end
    #45 begin
        Read = LOW;
        Select = LOW;
        StartStopACK = HIGH;
        ShiftOut = HIGH;
    end
    #50 begin
        Read = LOW;
        Select = LOW;
        StartStopACK = LOW;
        ShiftOut = HIGH;
    end
    #53 begin
        Read = LOW;
        Select = LOW;
        StartStopACK = HIGH;
        ShiftOut = HIGH;
    end
    #56 begin
        Read = HIGH;
        Select = LOW;
        StartStopACK = HIGH;
        ShiftOut = HIGH;
    end
    #57 begin
        Read = HIGH;
        Select = LOW;
        StartStopACK = HIGH;
        ShiftOut = LOW;
    end
    #77 begin
        Read = HIGH;
        Select = HIGH;
        StartStopACK = HIGH;
        ShiftOut = LOW;
    end
    #78 begin
        Read = LOW;
        Select = HIGH;
        StartStopACK = HIGH;
        ShiftOut = LOW;
    end
    #87 begin
        Read = LOW;
        Select = HIGH;
        StartStopACK = HIGH;
        ShiftOut = HIGH;
    end
    #94 begin
        Read = LOW;
        Select = HIGH;
        StartStopACK = LOW;
        ShiftOut = HIGH;
    end
    #96 begin
        Read = LOW;
        Select = LOW;
        StartStopACK = LOW;
        ShiftOut = HIGH;
    end
    #98 begin
        Read = LOW;
        Select = LOW;
        StartStopACK = HIGH;
        ShiftOut = HIGH;
    end
    #100 $stop;
join

endmodule
