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
module I2CController(CLK, CLKI2C, EN, RESET, BaudEnable, Read, Select, Shift, StartStopACK, ShiftLoad);
input CLK, CLKI2C, EN, RESET;
output reg BaudEnable, Read, Select, Shift, StartStopACK, ShiftLoad;
wire timeout, I2C_oneshot;
reg clear_timer;

// State variables
reg [3:0] current_state, next_state;
reg [3:0] count;
//State Codes
parameter initial_state = 4'd0, start_state = 4'd1, load_state = 4'd2, write_state = 4'd3, ack_read_state = 4'd4, 
          read_state = 4'd5, ack_write_state = 4'd6, transit_state = 4'd7, stop_state = 4'd8;

// Output logic
always@(current_state) begin
    case(current_state)
        initial_state: begin
            BaudEnable <= 0; Read <= 0; Select <= 0; Shift <= 0; StartStopACK <= 1; ShiftLoad <= 0;
        end
        start_state: begin
            BaudEnable <= 0; Read <= 0; Select <= 0; Shift <= 0; StartStopACK <= 0; ShiftLoad <= 0;
        end
        load_state: begin
            BaudEnable <= 1; Read <= 0; Select <= 0; Shift <= 0; StartStopACK <= 0; ShiftLoad <= 1;     
        end
        write_state: begin
            BaudEnable <= 1; Read <= 0; Select <= 1; Shift <= 1; StartStopACK <= 0; ShiftLoad <= 0; 
        end
        ack_read_state: begin
            BaudEnable <= 1; Read <= 1; Select <= 0; Shift <= 0; StartStopACK <= 0; ShiftLoad <= 0;
        end
        read_state: begin
            BaudEnable <= 1; Read <= 1; Select <= 1; Shift <= 1; StartStopACK <= 0; ShiftLoad <= 0;
        end
        ack_write_state: begin
            BaudEnable <= 1; Read <= 0; Select <= 0; Shift <= 0; StartStopACK <= 0; ShiftLoad <= 0;
        end
        transit_state: begin
            BaudEnable <= 0; Read <= 0; Select <= 0; Shift <= 0; StartStopACK <= 0; ShiftLoad <= 0;
        end
        stop_state: begin
            BaudEnable <= 0; Read <= 0; Select <= 0; Shift <= 0; StartStopACK <= 1; ShiftLoad <= 0;
        end
        default: begin
            BaudEnable <= 0; Read <= 0; Select <= 0; Shift <= 0; StartStopACK <= 0; ShiftLoad <= 0;
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
			count <= 4'd0;
		end
		start_state: begin
			clear_timer <= 0;
			count <= count;
		end
		load_state: begin
			clear_timer <= 1;
			if (count == 0 && I2C_oneshot) count <= 4'd8;
			else count <= count;
		end
		write_state: begin
			clear_timer <= 1;
			if(I2C_oneshot) count <= count - 1'b1; 
			else count <= count;
		end
		ack_read_state: begin
			clear_timer <= 1;
			count <= 4'd8;
		end
        read_state: begin
            clear_timer <= 1;
            if(I2C_oneshot) count <= count - 1'b1; 
            else count <= count;
        end
        ack_write_state: begin
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
            if(count > 0) next_state <= write_state;
            else next_state <= load_state; 
        end
        write_state: begin
            if(count == 0) next_state <= ack_read_state;
            else next_state <= write_state; 
        end
        ack_read_state: begin
            if(CLKI2C) next_state <= read_state;
            else next_state <= ack_read_state; 
        end
        read_state: begin
            if(count == 0) next_state <= ack_write_state;
            else next_state <= read_state; 
        end
        ack_write_state: begin
            if(CLKI2C) next_state <= transit_state;
            else next_state <= ack_write_state; 
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
ClockedOneShot OneShot(~CLKI2C, I2C_oneshot, RESET, CLK);

endmodule
