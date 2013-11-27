module window_holder ( clk, rst_n, input_data, window_offset,
						row, col, new_row, load,
						window_data
						);						// combinational read based on window_offset
	
	input logic 			clk, rst_n;			// standard
	input logic [31:0]		input_data;			// data read from memory
	input logic [6:0]		row;				// relative to 16 slots in the memory
												// the offset is calculated by the above module.
	input logic [6:0]		col;				// row and col to place read data.

	input logic				new_row;			// new row? do flip over.
	input logic				load;				// when to load.
	input logic	[6:0]		window_offset;		// which 16x16 window to output.
	
	
	output logic [7:0][15:0][15:0] window_data;		//output patch.
	
	logic [7:0][79:0][15:0]			store_data;		// 80x80 stored data.
	logic [7:0][79:0][15:0]			store_data_new;	//format to store new data.
	
	int i,j;
	always_comb begin // data loading logic
		if(new_row)begin // start of new row, shift.
			store_data_new = store_data;
			for( i =0; i<15; i++) begin // shift all row up by 1.
				store_data_new[i] = store_data[i+1];
			end
			// deal with the last row.
			// load in the 4 bytes to last row first columns.
				store_data_new[15] = 'd0;
				store_data_new[15]['d3] = input_data[7:0];
				store_data_new[15]['d2] = input_data[15:8];
				store_data_new[15]['d1] = input_data[23:16];
				store_data_new[15]['d0] = input_data[31:24];
			
		end
		else begin			//not a new row, load as normal.
			store_data_new = store_data; 		//set default case.
			store_data_new[row][col+'d3] = input_data[7:0];
			store_data_new[row][col+'d2] = input_data[15:8];
			store_data_new[row][col+'d1] = input_data[23:16];
			store_data_new[row][col] = input_data[31:24];
			
			
		end
	end
	
	always_comb begin // output 16x16 logic.
		for( i = 0; i <16; i++)begin
			for( j = 0; j<16; j++) begin
				window_data[i][j]= store_data[i][window_offset+j];
			end
		end
	end
	
	always_ff@(posedge clk, negedge rst_n)begin
		if(~rst_n) begin
			store_data <= 'b0;
		end
		else if(load) begin
			store_data <= store_data_new;
		end
		else begin // maintain data.
			store_data <= store_data;
		end
	end
						
endmodule: window_holder