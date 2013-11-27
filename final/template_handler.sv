module template_handler (clk,rst_n,template_data,template_ready,
						en, input_data, row, col, done, ack, receive
					);
		
	input logic			clk, rst_n;
	input logic [31:0]	input_data;		//data read from memory;
	input logic			en;				//enable this module
	input logic			receive;		// doesn't need to use this.
					
	output logic [31:0]	template_data;	//template data.
	output logic 		template_ready; // tell Dylan data is valid.
	output logic [6:0]	row, col;
	output logic		done;			// signal to indicate finish.
	output logic 		ack;			//acknowledgement.
	logic [6:0]			store_row, store_col;				
	enum {INIT, PROC} cs,ns;

assign template_data = input_data; 		// send the read result to Dylan.
	
	always_comb begin
		template_ready = 1'b0;
		done = 1'b0;
		ack = 1'b0;
		case(cs)
		INIT: begin
			if(en) begin
				row = 8'b0;
				col = 8'b0;
				ack = 1'b1; 		// acknowledge and indicate the start of operation.
				ns = PROC;
			end
			else begin
				ns = INIT;
			end
		end
		PROC: begin 
			template_ready = 1'b1; 		// data is read and ready.
			
		// compute next row,col
		if(store_row == 8'd15 && store_col == 8'd3) begin
			// data on the line is the last block.
			// template load operation almost complete.
			row = 8'b0;
			col = 8'b0;
			done = 1'b1;
			ns = INIT;
		end
		else if(store_col == 8'd3) begin // finished a row
			row = store_row +8'b1;
			col = 8'b0;
			ns = PROC;
		end
		else begin // within bound for both cases.
			row = store_row; 	//increment column.
			col = store_col + 8'b1; 
			ns = PROC;
			end
		end
	endcase
end
	
	always_ff@(posedge clk, negedge rst_n) begin
		if(~rst_n) begin
			cs <= INIT;
			store_row <= 8'b0;
			store_col <= 8'b0;
		end
		else begin
			cs <= ns;
			store_row <= row;
			store_col <= col;
		end
	end
	
endmodule: template_handler