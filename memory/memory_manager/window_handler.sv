module window_handler (clk,rst_n,window_data,window_ready,
						en, input_data, row, col, done, ack, receive
					);
					
	input logic			clk, rst_n;
	input logic [31:0]	input_data;		//data read from memory;
	input logic			en;				//enable this module
	input logic			receive;		//Dylan says he got it.
					
	output logic [31:0]	window_data;	//template data.
	output logic 		window_ready; 	// tell Dylan data is valid.
	output logic [6:0]	row, col;
	output logic		done;			// signal to indicate finish.
	output logic 		ack;			//acknowledgement.
	logic [6:0]			store_row, store_col;	
	logic [6:0]			row_offset;
	logic [6:0]			store_row_offset;
	logic [6:0]			window_offset;	  // which 16x16 of 16x80 to select.
	logic [6:0]			store_window_offset;
	logic				new_row;
	logic [6:0]			row_mem, col_mem; // row_mem is actual row - offset.
	logic 				load; 			  // load into memory holder
	logic [2:0]			window_slider;	  // keep track of how far to slide.
	logic [2:0]			store_window_slider;
	
	window_holder format_space(.clk(clk), .rst_n(rst_n), .input_data(input_data), 
							.window_offset(window_offset), .row(row_mem), .col(col_mem),
							.new_row(new_row), .load(load), .window_data(window_data));

	enum {INIT0, SETUP, SHIFT, EMPTY,NXTRW, RSHIFT} cs,ns;
	
	always_comb begin
		ack =1'b0;
		row_offset = store_row_offset;
		window_offset = store_window_offset;
		window_slider = store_window_slider;
		new_row = 1'b0;
		window_ready = 1'b0;
		load = 1'b0;
		row = store_row;
		col = store_col;
		case(cs)
			INIT0: begin
				if(en) begin
					ack = 1'b1;
					row = 'd0;
					col = 'd0;
					load =1'b1;
					row_offset_new = 'd0;
					
				end
				else begin
				end
			end
			SETUP: begin
					if(store_row == 'd15 && store_col == `d3)begin // first patch finished.
						load = 1'b1;
						window_ready = 1'b1;// first patch is ready, 
						window_offset = 'd0;// Dylan can load it.
						row = 'd0;			// top row, the column
						col = 'd4;			// after 16x16
						row_mem = row;		// start loading the next piece.
						col_mem = col;
						ns = SHIFT;
					end
					else if(store_col == `d3) begin // hit the end of the column,
						load = 1'b1;				// move down a row.
						window_offset = 'd0;
						row = store_row +'d0;
						col = 'd1;
						row_mem = row;
						col_mem = col;
						ns = SETUP;
					end
					else begin // normal operation.
						load = 1'b1;
						window_offset = 'd0;
						row = store_row;
						col = store_col +'d1; //move on to the next 4 bytes.
						row_mem = row;
						col_mem = col;
						ns = SETUP;
					end
			end
			SHIFT: begin
				if( store_row == 'd15 && store_col == 'd19)begin 
				// hit row == 15 and column == 19 since 19*4.
				// move to a stage where four windows are slide out
					load = 1'b0;
					ns = EMPTY;
			
				end
				else if (store_row == 'd15) begin 
				// row == 15 , move on to do the next column.
					load = 1'b1;
					row = 'd0;
					col = store_col +'d1;		
					row_mem = row;
					col_mem = col;
					ns = SHIFT;
					window_slider = 'd3; //	doing it once here.
					window_offet = store_window_offset +'d1;
					window_ready = 1'b1; // signal Dylan once
					
				else begin // within bound, keep going
					load = 1'b1;
					row = store_row+'d1;
					col = store_col;
					row_mem = row;
					col_mem = col;
					ns = SHIFT;
					if(store_window_slider !='d0) begin // keep sliding, until hit 0.
						window_offset = store_window_offset+`d1;
						window_slider = store_window_slider -'d1;
						window_ready = 1'b1;
					end
				end
			end
			EMPTY: begin // mindlessly shift out 3 windows.
				if(store_window_slider !='d0) begin // keep sliding, until hit 0.
					window_offset = store_window_offset+`d1;
					window_slider = store_window_slider -'d1;
					window_ready = 1'b1;
					ns = EMPTY;
				end
				else begin // 
					load = 1'b1;
					ns = NXTROW;
					row_offset = 'd1;		// one row away...
					new_row = 1'b1; 		//activate new row
					row = store_row +'d1;	// store the new data into the last row.
					col = 'd0;				// start at column 0.
					row_mem = 'd16;			// 17th row.
					col_mem = 'd0;			//
				end
			end
			NXTROW: begin // keep track of row offset,load in the other 3 chunks.
						  // move on to RSHIFT after done.
					if(store_col == 'd3) begin // complete loading of 4 chunks
						// start shifting out window.
					
					
					end
					else begin // keep loading in the 4 chunks.
						
						row = 
						col = 
						row_mem = 'd16;
						col_mem = col;
						
					end
			
			
			end
			RSHIFT: begin
			
			end
	end
	
	
	
	
	
	always_ff@(posedge clk, negedge rst_n) begin
		if(~rst_n) begin
			cs <= INIT0;
			store_row_offset <= 'd0;
			store_row <= 'd0;
			store_col <= 'd0;
			store_window_slider <= 'd0;
		end
		else begin
			cs <= ns;
			store_row_offset <= row_offset;
			store_row <= row;
			store_col <= col;
			store_window_slider <= window_slider;
		end
	end
endmodule: window_handler