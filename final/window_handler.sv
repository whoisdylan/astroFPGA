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
	logic [6:0]			mem_row, mem_col;       //latched	
	logic [6:0]			mem_row_c, mem_col_c;	//combinationally set

    logic       [79:0][79:0][7:0]       window_data_mem; //latched 80x80 window
	
	enum logic[1:0] {INIT0, SETUP, LOAD, WAIT} cs,ns;
	
    int i,j,k,l;
	always_comb begin
		ack =1'b0;
		window_ready = 1'b0;
		row = store_row;
		col = store_col;
		done = 1'b0;
		LEDs = 4'd0;
        mem_row_c = 'd0;
        mem_col_c = 'd0;
        window_data = 'd0;

		case(cs)
			INIT0: begin
				if(en) begin
					ack = 1'b1;
					row = 'd0;
					col = 'd0;
					ns = SETUP;
				end
				else begin
                    ns = INIT0;
                end
			end
			SETUP: begin
			    LEDs = 4'd1;
				if(store_row == 'd79 && store_col == 'd19)begin // first patch finished.
					row = 'd0;			// top row, the column
					col = 'd0;			// after 16x16
					ns = LOAD;
				end
				else if(store_col =='d19) begin // hit the end of the column,
					row = store_row +'d1;
					col = 'd0;
                    ns = SETUP;
				end
				else begin // normal operation.
					row = store_row;
					col = store_col +'d1; //move on to the next 4 bytes.
                    ns = SETUP;
				end
                mem_row_c = 'd0;
                mem_col_c = 'd0;
			end
            LOAD: begin
                window_ready = 1'b1;
                for (i=0 ; i < 'd16; i++) begin
                    for (j=0; j < 'd16; j++) begin
                        window_data[i][j][7:0] = window_data_mem[mem_row+i][mem_col+j][7:0];
                    end
                end
                if (mem_row == 'd64 && mem_col == 'd64) begin
                    ns = INIT0;
                    done = 'b1;
                end
                else if (mem_col == 'd64) begin
                    mem_col_c = 'd0;
                    mem_row_c = mem_row + 'd1;
                    ns=WAIT;
                end
                else begin
                    mem_col_c = mem_col+'d1;
                    mem_row_c = mem_row;
                    ns = WAIT;
                end
            end
            WAIT: begin
                ns = LOAD;
                mem_row_c = mem_row;
                mem_col_c = mem_col;
            end
		endcase
	end
	always_ff@(posedge clk, negedge rst_n) begin
		if(~rst_n) begin
			cs <= INIT0;
			store_row <= 'd0;
			store_col <= 'd0;
		end
        else if (cs == SETUP) begin
            window_data_mem[store_row][store_col*4+3] <= input_data[7:0];
            window_data_mem[store_row][store_col*4+2] <= input_data[15:8];
            window_data_mem[store_row][store_col*4+1] <= input_data[23:16];
            window_data_mem[store_row][store_col*4] <= input_data[31:24];
            store_row <= row;
            store_col <= col;
            cs <= ns;
            mem_row <= mem_row_c;
            mem_col <= mem_col_c;
        end
		else if (cs == LOAD) begin
            mem_row <= mem_row_c;
            mem_col <= mem_col_c;
            cs <= ns;
        end
        else begin
            cs <= ns;
        end
	end
endmodule: window_handler
