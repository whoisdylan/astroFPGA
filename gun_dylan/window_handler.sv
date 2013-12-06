module window_handler_fake
    (input logic clk, rst_n, en,
    output logic done);
    enum logic {WAIT, FAKE_IT} cs, ns;
    
    bit [4:0] winCount;
    bit countEn, clr;
    counter_local #(5) window_count_faker(clk, rst_n, clr, countEn, winCount);
    
    always_comb begin
        countEn = 1'b0;
        clr = 1'b0;
        done = 1'b0;
        case(cs)
            WAIT: begin
                if (en) begin
                    ns = FAKE_IT;
                    countEn = 1'b1;
                end
                else begin
                    ns = WAIT;
                end
            end
            FAKE_IT: begin
                if (winCount == 5'd5) begin
                    done = 1'b1;
                    clr = 1'b1;
                    ns = WAIT;
                end
                else begin
                    countEn = 1'b1;
                    ns = FAKE_IT;
                end
            end
        endcase
    end
    
    always_ff @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            cs <= WAIT;
        end
        else begin
            cs <= ns;
        end
    end
endmodule: window_handler_fake
    
module window_handler (clk,rst_n,window_data,window_ready,
						en, input_data, row, col, done, ack, receive, LEDs
					);
					
	input logic			clk, rst_n;
	input logic [31:0]	input_data;		//data read from memory;
	input logic			en;				//enable this module
	input logic			receive;		//Dylan says he got it.
					
	output logic [15:0][15:0][7:0]		window_data;	//template data.
	output logic 		window_ready; 	// tell Dylan data is valid.
	output logic [6:0]	row, col;
	output logic		done;			// signal to indicate finish.
	output logic 		ack;			//acknowledgement.
	output bit [3:0] LEDs;
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

	enum logic[2:0] {INIT0, SETUP, SHIFT, EMPTY,NXTROW, RSHIFT} cs,ns;
	
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
		done = 1'b0;
		LEDs = 4'd0;
		case(cs)
			INIT0: begin
			    LEDs = 4'd0;
				if(en) begin
					ack = 1'b1;
					row = 'd0;
					col = 'd0;
					load =1'b0;
					row_offset = 'd0;
					window_offset = 'd0;
					window_slider = 'd0;
					ns = SETUP;
				end
				else begin
                    ns = INIT0;
                end
			end
			SETUP: begin
			        LEDs = 4'd1;
					if(store_row == 'd15 && store_col == 'd3)begin // first patch finished.
						load = 1'b1;
						window_ready = 1'b1;// first patch is ready, 
						window_offset = 'd0;// Dylan can load it.
						row = 'd0;			// top row, the column
						col = 'd4;			// after 16x16
						row_mem = store_row;		// start loading the next piece.
						col_mem = store_col;
						ns = SHIFT;
					end
					else if(store_col =='d3) begin // hit the end of the column,
						load = 1'b1;				// move down a row.
						window_offset = 'd0;
						row = store_row +'d1;
						col = 'd0;
						row_mem = store_row;
						col_mem = store_col;
						ns = SETUP;
					end
					else begin // normal operation.
						load = 1'b1;
						window_offset = 'd0;
						row = store_row;
						col = store_col +'d1; //move on to the next 4 bytes.
						row_mem = store_row;
						col_mem = store_col;
						ns = SETUP;
					end
			end
			SHIFT: begin
			    LEDs = 4'd2;
				if( store_row == 'd15 && store_col == 'd19)begin 
				// hit row == 15 and column == 19 since 19*4.
				// move to a stage where four windows are slide out
					load = 1'b1;  // load in the last bit
					ns = EMPTY;
					row_mem = store_row;
					col_mem = store_col;
			
				end
				else if (store_row == 'd15) begin 
				// row == 15 , move on to do the next column.
					load = 1'b1;
					row = 'd0;
					col = store_col +'d1;		
					row_mem = store_row;
					col_mem = store_col;
					ns = SHIFT;
					window_slider = 'd3; //	doing it once here.
					window_offset = store_window_offset +'d1;
					window_ready = 1'b1; // signal Dylan once
				end	
				else begin // within bound, keep going
					load = 1'b1;
					row = store_row+'d1;
					col = store_col;
					row_mem = store_row;
					col_mem = store_col;
					ns = SHIFT;
					if(store_window_slider !='d0) begin // keep sliding, until hit 0.
						window_offset = store_window_offset+'d1;
						window_slider = store_window_slider -'d1;
						window_ready = 1'b1;
					end
				end
			end
			EMPTY: begin // mindlessly shift out 3 windows.
			    LEDs = 4'd3;
				if(store_window_slider !='d1) begin // keep sliding, until hit 1 is left.
					window_offset = store_window_offset+'d1;
					window_slider = store_window_slider -'d1;
					window_ready = 1'b1;
					ns = EMPTY;
				end
				else begin // 
					load = 1'b0;
					window_offset = store_window_offset + 'd1;
					window_slider = store_window_slider - 'd1;
					window_ready = 1'b1;
					row = store_row + 'd1;	// start getting the new row data
					col = 'd0;				// col is 0 
					ns = NXTROW;
					row_mem = 'd15;			//doesn't matter, not loading.
					col_mem = 'd0;
/*
					load = 1'b1;
					ns = NXTROW;
					new_row = 1'b1; 		//activate new row
					row = store_row +'d1;	// store the new data into the last row.
					col = 'd0;				// start at column 0.
					row_mem = 'd15;			// 17th row.
					col_mem = 'd0;			//
*/
					end
			end
			NXTROW: begin // keep track of row offset,load in the other 3 chunks.
						  // move on to RSHIFT after done.
					LEDs = 4'd4;
					if(store_col == 'd3) begin // complete loading of 4 chunks
						// start shifting out window.
						load = 1'b1; //keep loading
						window_ready = 1'b1;
						window_offset = 'd0;
						
						// load in the next 4 column.
						row = store_row;
						col = store_col +'d1;
						row_mem = 'd15;
						col_mem = store_col;
						ns = RSHIFT;
					end
					else begin // keep loading in the other 3 chunks.
						load = 1'b1;
						row = store_row; 
						col = store_col +'d1;
						row_mem = 'd15;
						col_mem = store_col;
						ns = NXTROW;
					end
			
			
			end
			RSHIFT: begin // first 4 column sets are in. load in the rest
						  // and keep shifting window
			    LEDs = 4'd5;
				if(store_col == 'd19 && store_window_offset == 'd64)begin
						if(store_row == 'd79) begin // last row
							load = 1'b0;
							ns = INIT0;
							done =1'b1;
							
						end
						else begin // move to next row if not on last row
							load = 1'b1;
							ns = NXTROW;
							new_row = 1'b1; 		//activate new row
							row = store_row +'d1;	// store the new data into the last row.
							col = 'd0;				// start at column 0.
							row_mem = 'd15;			// 17th row.
							col_mem = store_col;	//
						end
				end
				else if(store_col == 'd19) begin	// finish loading in all the column.
					load =1'b0;
					row = store_row;
					col = store_col;
					row_mem = 'd15;
					col_mem = store_col;
					ns = RSHIFT;
					// keep doing the window
					window_offset = store_window_offset +'d1;		//increment.
					window_ready = 1'b1;
				end
				else begin					// keep loading in next chunk
					load = 1'b1;
					row = store_row;
					col = store_col+'d1;
					row_mem = 'd15;
					col_mem = store_col;
					window_offset = store_window_offset + 'd1;
					window_ready = 1'b1;
					ns = RSHIFT;
				end
			end
		endcase
	end
	always_ff@(posedge clk, negedge rst_n) begin
		if(~rst_n) begin
			cs <= INIT0;
			store_row_offset <= 'd0;
			store_row <= 'd0;
			store_col <= 'd0;
			store_window_slider <= 'd0;
			store_window_offset <= 'd0;
		end
		else begin
			cs <= ns;
			store_row_offset <= row_offset;
			store_row <= row;
			store_col <= col;
			store_window_slider <= window_slider;
			store_window_offset <= window_offset;
		end
	end
endmodule: window_handler
