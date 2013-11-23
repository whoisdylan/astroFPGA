module user_FPGA_format( clk, rst_n, req, rd_wr, write_data,in_data,
 set_done, row, col, tem_win, ready_2_start);


		input logic			clk, rst_n; // standard signals.
		input logic [31:0]	read_data;	// data read from memory.


		output logic 		tem_win; 	// 0 = want template, 1 = want window.
		output logic		req;		// 1 = want to use memory.
		output logic		rd_wr;		// 0 = read, 1 = write
		output logic[31:0]	write_data; // 32 bits to write into memory.
		output logic		set_done;	// once complete a set, this is asserted.
		output logic[6:0]	row,col;	// 7 bits information of which row, col.
		
		
		logic [31:0]	template_data;  // template data to send to Dylan
		logic 			template_ready; // ready signal saying data line is valid
		logic			tem_win;		// switch to determine which address to get.
		
		
		logic [6:0]		template_row, template_col; 	//row and col requested for template.
		logic [6:0]		window_row, window_col;			//row and col requested for window.
		
		logic 			template_done;					//template_handler is done.
		logic			window_done;					//window_handler is done.

		logic 			activate_template;				//enable signal
		logic			activate_window;				//
		logic			template_data_ready;			//
		logic			window_data_ready;				//
		logic			template_ack;
		logic			window_ack;
		logic			window_receive;					// 1 indicate it can accept the next data.
		logic			template_receive;				//
		
		logic			data_ready;						// signal to Dylan
		logic [7:0][15:0][15:0] window_data;			// 16x16 bytes for a patch.
		logic [7:0]		set_count, set_count_new		// count how many sets have been done.
		
template_handler (.clk(clk),.rst_n(rst_n),.template_data(template_data), .template_ready(template_ready),
					.en(activate_template), .input_data(read_data), .row(template_row), .col(template_col),
					.done(template_done), .ack(template_ack), .receive(template_receive)
					);

window_handler ( .clk(clk),.rst_n(rst_n),. window_data(window_data), .window_ready(window_ready),
				.en(activate_window),. input_data(read_data), .row(window_row),.col(window_col),
				.done(window_done), .ack(window_ack), .receive(window_receive)
				);
				
				
	enum {INIT, TEMP,WIND,DONE} cs,ns;
		
	always_comb begin // task selector between template and window handler.
		set_done = 1'b0;
		activate_template = 1'b0;
		activate_window = 1'b0;
		set_count_new = set_count;
		row = 32'b0;
		col = 32'b0;
		tem_win =1'b0;
		req = 1'b0;
		
		case(cs)
		INIT: begin
			set_count_new = 8'b0;
			if(ready_2_start) begin
				ns = TEMP;
				activate_template = 1'b1;		//activate template handler, get address ready.
				row = template_row;				//
				col = template_col;				// 
				tem_win = 1'b0;					// select template format.
				req = 1'b1;						// want to use memory
				
			end
			else begin
				ns = INIT;
				req = 1'b0;
				
			end
		end
		TEMP: begin
			if(template_done) begin
				ns = WIND;
				activate_window = 1'b1;			// activate template handler, get address ready.
				row = window_row;				//
				col = window_col;				//
				tem_win = 1'b1;					// select template format
				req = 1'b1;
			end
			else begin // keep using template_handler.
				ns = TEMP;
				activate_template = 1'b1;		//activate template handler, get address ready.
				row = template_row;				//
				col = template_col;				// 
				tem_win = 1'b0;					// select template format.
				req = 1'b1;						// read from memory.
			end
		end
		WIND: begin
			if(window_done) begin
				set_count_new = (window_done)? set_count + 8'b1; set_count;
				ns = WRIT;				 		//go to write back result.
			end
			else begin
				activate_window = 1'b1;			// activate template handler, get address ready.
				row = window_row;				//
				col = window_col;				//
				tem_win = 1'b1;					// select template format
				req = 1'b1;
		end
		WRIT: begin // write operation here.
			if()begin // dylan wants to write back.
			
				ns = (set_count == 8'd149)? DONE: WRIT; // finishes 150 sets?
			end
			else begin
				ns = WRIT;
			end
		end
		DONE: begin// signal the finish of a frame.
			set_done = 1'b1;				//finish a frame.
			ns = INIT;
		end
		
	end
	
	always_ff @(posedge clk, negedge rst_n) begin
		if(~rst_n) begin
			cs <= INIT;
			set_count <= 8'b0;
		end
		else begin
			cs <= ns;
			set_count <= set_count_new;
		end
	end

endmodule: user_FPGA_format