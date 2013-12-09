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
	
/////////////////////////////////
/////////////////////////////////
	logic			shifting;
	logic			clear;
	logic			load[16];
//	logic [7:0]		window_data [16][16];
	logic [3:0]		mem_row, store_mem_row;
	logic [2:0]		shift_count, store_shift_count;
	logic [6:0]		row_offset,store_row_offset;
	logic [15:0]	valid;

genvar w;			//w is row.
generate
	for(w = 0; w <16; w++)begin
			window_shift  tap(.clk(clk),.rst_n(rst_n),.en(load[w]),.clr(clear),.shift(shifting),.in(input_data),.valid(valid[w]),.out(window_data[w]));
	end
endgenerate

int i;
enum logic [1:0]	{INIT0, SETUP, SHIFT,DONE} cs,ns;

	always_comb begin
		ack = 1'b0;
		window_ready = 1'b0;
		row = store_row;
		col = store_col;
		shift_count = store_shift_count;
		row_offset = store_row_offset;
		done = 1'b0;
		shifting = 1'b0;
		clear = 1'b0;
		for(i = 0; i <16; i++) begin
			load[i] = 1'b0;
		end
		case(cs)
			INIT0: begin
				if(en) begin
					ack =1'b1;
					row ='d0;
					col ='d0;
					ns = SETUP;
					mem_row = 'd0;
					shift_count = 'd0;
					row_offset = 'd0;
				end
				else begin
					ns = INIT0;
				end
			end
			SETUP: begin
				if(store_mem_row == 'd15) begin
					// last request is the last element.
					// move on to shift stage
					load[store_mem_row] = 1'b1;
					ns = SHIFT;
					mem_row = 'd0;
					row = store_row_offset;
					col = store_col+'d1;
					shift_count = 'd4;
					
				end
				else begin  // keep loading in
					ns = SETUP;
					load[store_mem_row] = 1'b1;  //store the incoming data.
					mem_row = store_mem_row +'d1;
					row = store_row + 'd1;
					col = store_col;
				end

			end

			//////////////////////////////
			//
			/////////////////////////////
			SHIFT: begin
				if(store_shift_count == 'd0) begin
					//finish if row_offset == 64 && col == 19
					if(store_row_offset == 'd64 && store_col == 'd19)begin
						ns = DONE;
					end
					//go back to setup and start over with incremented
					//row_offset if col == 19
					else if(store_col == 'd19)begin
						row_offset = store_row_offset +'d1;
						clear = 1'b1;
						row = store_row_offset;
						col = 'd0;
					end
					//neither, row_offset is the same, increment col.
					//go to setup.
					else begin			
						col = store_col;
						row = store_row;
						ns = SETUP;
					end

				end
				else begin // shifting not done yet, keep shifting.
					// do shifting if the queue is filled.
					if(valid[15]) begin
						window_ready = 1'b1;
					end
					else begin
						window_ready = 1'b0;
					end
					shifting = 1'b1;
					shift_count = store_shift_count -'d1;
					ns = SHIFT;	
				end
			end
			////////////////////////////////
			//
			///////////////////////////////
			DONE: begin
				done = 1'b1;
				ns = INIT0;
				clear = 1'b1;
			end
		endcase
	end

always_ff@(posedge clk, negedge rst_n) begin
	if(~rst_n) begin
		store_row <= 'd0;
		store_col <= 'd0;
		store_mem_row <= 'd0;
		store_shift_count <='d0;
		store_row_offset <='d0;
		cs <= INIT0;
	end
	else begin
		cs <= ns;
		store_row <= row;
		store_col <= col;
		store_mem_row <= mem_row;
		store_shift_count <= shift_count;
		store_row_offset <= row_offset;
	end
end

endmodule: window_handler



/*
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
        for(k = 0; k < 16; k++)begin
            for(l = 0; l <16; l++)begin
                window_data[k][l] = 'd0;
            end
        end
        input_data_store = 'd0;
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
			    input_data_store = input_data;
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
            default: ns = INIT0;
		endcase
	end
	always_ff@(posedge clk, negedge rst_n) begin
		if(~rst_n) begin
			cs <= INIT0;
			store_row <= 'd0;
			store_col <= 'd0;
			window_data_mem[store_row][store_col*4+3] <= 'd0;
            window_data_mem[store_row][store_col*4+2] <= 'd0;
            window_data_mem[store_row][store_col*4+1] <= 'd0;
            window_data_mem[store_row][store_col*4] <= 'd0;
            mem_row <= 'd0;
            mem_col <= 'd0;
		end
        else begin
            window_data_mem[store_row][store_col*4+3] <= input_data_store[7:0];
            window_data_mem[store_row][store_col*4+2] <= input_data_store[15:8];
            window_data_mem[store_row][store_col*4+1] <= input_data_store[23:16];
            window_data_mem[store_row][store_col*4] <= input_data_store[31:24];
            store_row <= row;
            store_col <= col;
            cs <= ns;
            mem_row <= mem_row_c;
            mem_col <= mem_col_c;
        end
	end
endmodule: window_handler
*/

module window_shift (clk, rst_n, en, clr, shift,in,valid, out);

	input logic clk, rst_n;
	input logic en, clr;
	input logic shift;
	input logic [3:0][7:0] in;
	output logic valid;
	output logic [15:0][7:0] out;

	logic [19:0][7:0]		data;
	logic [19:0]		valid_array;

	//can only load or shift, can't do both.


assign valid = valid_array[19]; // highest point

int j;
always_comb begin
/*
	for(j = 0; j <16; j++) begin
		out[j] = data[j];
		out[j] = data[j];
		out[j] = data[j];
		out[j]  = data[j];
	end
	*/
	out[0] = data[3];
	out[1] = data[2];
	out[2] = data[1];
	out[3] = data[0];

	out[4] = data[7];
	out[5] = data[6];
	out[6] = data[5];
	out[7] = data[4]; 

	out[8] = data[11];
	out[9] = data[10];
	out[10] = data[9];
	out[11] = data[8];

	out[12] = data[15];
	out[13] = data[14];
	out[14] = data[13];
	out[15] = data[12]; 


end
int i;
always_ff@(posedge clk, negedge rst_n) begin
	if(~rst_n)begin
		for( i =0; i < 20; i++)begin
			data[i] = 'd0;
		end
	end
	else if (clr)begin
		for( i =0; i < 20; i++)begin
			data[i] = 'd0;
		end
	end
	else if (en)begin
		for( i =0; i < 16; i++)begin
			data[i] = data[i];
		end
		data[16] = in[0];
		data[17] = in[1];
		data[18] = in[2];
		data[19] = in[3];
		// set to valid.
		valid_array[3:0] = 4'b1111;
		
	end
	else if (shift) begin
		//shift by 1 element
		for( i =0; i < 19; i++)begin
			data[i] = data[i+1];
		end
		valid_array[19:1] = valid_array[18:0];
		valid_array[0] = 'd0;	
	end
	else begin
		data = data;
		valid_array = valid_array;
	end
end

endmodule: window_shift
