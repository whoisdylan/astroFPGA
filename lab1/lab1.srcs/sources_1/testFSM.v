/* This example is an FSM that interacts with the lcd_control.v module.  
   It first sends the string "18545" to the LCD module
   It then waits for the nextString input to be asserted
   It then sends the string "ECE" to the LCD module
   It then waits forever.
 */
 
module testFSM(clkFSM,
					resetFSM,
					initDone,
					writeDone,
					data, 
					writeStart,
					input_data,
					update,
					lcd_clear);
	input update;				
	input clkFSM;
	input resetFSM;
	input initDone;
	input writeDone;
	input wire[3:0] input_data;
	
	output [7:0]	data;
	output			writeStart;
	output			lcd_clear;

	reg lcd_clear;
	reg [7:0]		data, digit1, digit2;
	reg 		 		writeStart;
	reg [5:0] 		state,next_state;
	reg [3:0]	count_data;
	`define idle 	     6'd1
	`define data1	     6'd2
	`define wait1	     6'd3
	`define data2	     6'd4
	`define wait2	     6'd5
	`define data3	     6'd6
	`define wait3	     6'd7
	`define data4	     6'd8
	`define wait4	     6'd9
	`define data5	     6'd10
	`define wait5	     6'd11
	`define data6	     6'd12
	`define wait6	     6'd13
	`define data7	     6'd14
	`define wait7	     6'd15
	`define data8	     6'd16
	`define wait8	     6'd17
	`define waitClear   6'd18
	`define finish      6'd19

	`define clear		6'd20
	`define countWait	6'd21
	`define	data10		6'd22
	`define	wait10		6'd23
	`define	done		6'd24


always @(*)begin
	
	if(input_data > 4'd9)
	begin
		digit1 = 8'd49;
		digit2 = ({4'd0,input_data} - 8'd10)+8'd48;
	end
	else
	begin
		digit1 = 8'd32;
		digit2 = {4'd0,input_data} + 8'd48;
	end

end
	
	/* first write 18545, then write ECE to LCD */
	always @ (clkFSM or state or initDone or writeDone)
		begin
			next_state <= `idle;
			data = 8'd0;
			writeStart = 'b0;
			lcd_clear =1'b0;
			case(state)
				`idle : 
					begin
						if(initDone == 1'b1) 
							next_state <= `data1;
						else
							next_state <= `idle;
					end
				`data1 :
					begin
						data = digit1;		//first char
						writeStart = 1'b1;
						next_state <= `wait1;
					end
				`wait1 :
					begin
						data = digit1;
						if(writeDone == 1'b1)
							next_state <= `data2;
						else
							next_state <= `wait1;
					end
				`data2 :
					begin
						data = digit2;		// second char
						writeStart = 1'b1;
						next_state <= `wait2;
					end
				`wait2 :
					begin
						data = digit2;
						if(writeDone == 1'b1)
							next_state <= `done;
						else
							next_state <= `wait2;
					end
				`done :
					begin	
						if(update)
							next_state <= `clear;
						else
							next_state <= `done;
					end
				`clear :
					begin
						data=8'b0;
						lcd_clear =1'b1;
						next_state <= `idle;
					end
			endcase	
		
		end
	
	//registers state variables
	always @ (posedge clkFSM)
		begin
			if (resetFSM) 
				begin
					state <= `idle;			
				end
			else 
				begin
					state <= next_state;			
				end
		end // always 
					
endmodule
