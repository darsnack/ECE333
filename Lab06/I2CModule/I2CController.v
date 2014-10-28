`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// CM Box:           1608 & 1876
// Engineer:         Kyle Daruwalla & David McNeil
// 
// Create Date:    10/21/2014
// Module Name:    I2CController
// Description: 
//
// A controller for the I2C module
//
//////////////////////////////////////////////////////////////////////////////////
module I2CController(CLK, CLKI2C, EN, RESET, BaudEnable, ReadOrWrite, Select, ShiftOrHold, StartStopACK, ShiftLoad);
input CLK, CLKI2C, EN, RESET;
output reg BaudEnable, ReadOrWrite, Select, ShiftOrHold, StartStopACK, ShiftLoad;
wire timeout, I2C_oneshot;
reg clear_timer;

// State variables
reg [2:0] current_state, next_state;
reg [3:0] count;
//State Codes
parameter initial_state = 3'd0, start_state = 3'd1, load_state = 3'd2, write_state = 3'd3, ack_state = 3'd4, transit_state = 3'd5, stop_state = 3'd6;

// Output logic
always@(current_state) begin
    case(current_state)
        initial_state: begin
            BaudEnable <= 0; ReadOrWrite <= 1; Select <= 0; ShiftOrHold <= 0; StartStopACK <= 1; ShiftLoad <= 0;
        end
        start_state: begin
            BaudEnable <= 0; ReadOrWrite <= 1; Select <= 0; ShiftOrHold <= 0; StartStopACK <= 0; ShiftLoad <= 0;
        end
        load_state: begin
            BaudEnable <= 1; ReadOrWrite <= 1; Select <= 0; ShiftOrHold <= 0; StartStopACK <= 0; ShiftLoad <= 1;     
        end
        write_state: begin
            BaudEnable <= 1; ReadOrWrite <= 1; Select <= 1; ShiftOrHold <= 1; StartStopACK <= 0; ShiftLoad <= 0; 
        end
        ack_state: begin
            BaudEnable <= 1; ReadOrWrite <= 0; Select <= 0; ShiftOrHold <= 0; StartStopACK <= 0; ShiftLoad <= 0;
        end
        transit_state: begin
            BaudEnable <= 0; ReadOrWrite <= 1; Select <= 0; ShiftOrHold <= 0; StartStopACK <= 0; ShiftLoad <= 0;
        end
        stop_state: begin
            BaudEnable <= 0; ReadOrWrite <= 1; Select <= 0; ShiftOrHold <= 0; StartStopACK <= 1; ShiftLoad <= 0;
        end
        default: begin
            BaudEnable <= 0; ReadOrWrite <= 1; Select <= 0; ShiftOrHold <= 0; StartStopACK <= 0; ShiftLoad <= 0;
        end
    endcase
end

// State transitions
always@(posedge CLK) begin
    if(RESET) begin
        current_state <= initial_state;
    end
    else begin
        current_state <= next_state;
    end
    // Configure timer and count based on current state
    case(current_state)
		initial_state: begin
			clear_timer <= 1;
			count <= 9;
		end
		start_state: begin
			clear_timer <= 0;
			count <= count;
		end
		load_state: begin
			clear_timer <= 1;
			count <= count;
		end
		write_state: begin
			clear_timer <= 1;
			if(I2C_oneshot) count <= count - 1'b1; 
			else count <= count;
		end
		ack_state: begin
			clear_timer <= 1;
			count <= count;
		end
		transit_state: begin
			clear_timer <= 0;
			count <= count;
		end
		stop_state: begin
			clear_timer <= 0;
			count <= count;
		end
		default: begin
			clear_timer <= 1;
			count <= count;
		end
    endcase
end

// State transistion logic
always@(CLKI2C or EN or RESET or timeout or count or current_state or I2C_oneshot) begin
    case(current_state)
        initial_state: begin
            if(EN && CLKI2C) next_state <= start_state;
            else next_state <= initial_state; 
        end
        start_state: begin
            if(timeout) next_state <= load_state;
            else next_state <= start_state; 
        end
        load_state: begin
            if(count > 8) next_state <= write_state;
            else next_state <= load_state; 
        end
        write_state: begin
            if(count == 0) next_state <= ack_state;
            else next_state <= write_state; 
        end
        ack_state: begin
            if(I2C_oneshot) next_state <= transit_state;
            else next_state <= ack_state; 
        end
        transit_state: begin
            if(timeout) next_state <= stop_state;
            else next_state <= transit_state; 
        end
        stop_state: begin
            if(timeout) next_state <= initial_state;
            else next_state <= stop_state; 
        end
        default: begin 
            next_state <= initial_state; 
        end
    endcase
end

DelayLoop Timer(clear_timer, timeout, CLK);
ClockedOneShot OneShot(CLKI2C, I2C_oneshot, RESET, CLK) ;

endmodule
