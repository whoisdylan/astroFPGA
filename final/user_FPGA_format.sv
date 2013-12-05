module user_FPGA_format( clk, rst_n, req, rd_wr, write_data, read_data,
 set_done, row, col, tem_win, ready_2_start, greatestNCCLog2,
 greatestWindowIndex,set_count, wr_index, inst, LEDs);


		input logic			clk, rst_n; // standard signals.
		input logic [31:0]	read_data;	// data read from memory.
        input logic         ready_2_start;


		output logic 		tem_win; 	// 0 = want template, 1 = want window.
		output logic		req;		// 1 = want to use memory.
		output logic		rd_wr;		// 0 = read, 1 = write
		output logic[31:0]	write_data; // 32 bits to write into memory.
		output logic		set_done;	// once complete a set, this is asserted.
		output logic[6:0]	row,col;	// 7 bits information of which row, col.
        output logic[31:-32] greatestNCCLog2;
        output logic[12:0] greatestWindowIndex;
		output logic[7:0]	set_count;	// count how many sets have been done.
		output logic[1:0]	wr_index;
		output logic		inst;
		output bit [3:0] LEDs;

		logic [35:0]	template_data;  // template data to send to Dylan
		logic 			template_ready; // ready signal saying data line is valid
		//logic			tem_win;		// switch to determine which address to get.
		logic			window_ready;	//	
		
		logic [6:0]		template_row, template_col; 	//row and col requested for template.
		logic [6:0]		window_row, window_col;			//row and col requested for window.
		
		logic 			template_done;					//template_handler is done.
		logic			window_done;					//window_handler is done.

		logic 			activate_template;				//enable signal
		logic			activate_window;				//
		logic			template_ack;
		logic			window_ack;
		logic			window_receive;					// 1 indicate it can accept the next data.
		logic			template_receive;				//
		logic 			result_ready;					// computation result is ready.
		
		logic [15:0][15:0][7:0] window_data;			// 16x16 bytes for a patch.

		logic signed [8:0]	avg_window_data[15:0][15:0];
		logic [2:0][31:0] write_back, write_back_new; 


average mean(window_data, avg_window_data);

/*
ncc ncci(.clk(clk), .rst(~rst_n), .window_data_ready(window_ready), .desc_data_ready(template_ready),
                .desc_data_in(template_data), .window_data_in(avg_window_data),
                .done_with_window_data(result_ready), .done_with_desc_data(), 
                .greatestNCC(greatestNCCLog2), 
                .greatestWindowIndex(greatestWindowIndex)
                );
 */              
template_handler do_temp(.clk(clk),.rst_n(rst_n),.template_data(template_data), .template_ready(template_ready),
					.en(activate_template), .input_data(read_data), .row(template_row), .col(template_col),
					.done(template_done), .ack(template_ack), .receive(template_receive),.inst(inst)
					);

window_handler do_wind( .clk(clk), .rst_n(rst_n), .window_data(window_data), .window_ready(window_ready),
				.en(activate_window), .input_data(read_data), .row(window_row), .col(window_col),
				.done(window_done), .ack(window_ack), .receive(window_receive), .LEDs(LEDs)
				);

bit windowCountClr, windowCountEn;
counter_local #(8) window_counter_inst(clk, rst_n, windowCountClr, windowCountEn, set_count);

	enum {INIT,TEMP,WIND, WRIT0,WRIT1,WRIT2,WRIT, DONE} cs,ns;
		
	always_comb begin // task selector between template and window handler.
		set_done = 1'b0;
		activate_template = 1'b0;
		activate_window = 1'b0;
		row = 32'b0;
		col = 32'b0;
		tem_win =1'b0;
		req = 1'b0;
		write_back_new = write_back;
		rd_wr = 1'b0;
		wr_index = 'd0;
		windowCountClr = 1'b0;
		windowCountEn = 1'b0;
		//LEDs = 4'd0;
		case(cs)
		INIT: begin
			windowCountClr = 1'b1;
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
			//LEDs = 4'd0;
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
			//LEDs = 4'd1;
		end
		WIND: begin
			if(window_done) begin
				windowCountEn = 1'b1;
				ns = WRIT0;				 		//go to write back result.
				write_back_new = {greatestNCCLog2,greatestWindowIndex, 19'b0};
			end
			else begin
				activate_window = 1'b1;			// activate template handler, get address ready.
				row = window_row;				//
				col = window_col;				//
				tem_win = 1'b1;					// select template format
				req = 1'b1;
				ns = WIND;
		      end
		      //LEDs = 4'd2;
		end
		WRIT0:begin
				req = 1'b1;
				rd_wr =1'b1;
				write_data = write_back[0];
				ns = WRIT1;
				wr_index = 'd0;
				//LEDs = 4'd3;
		end
		WRIT1:begin
				req = 1'b1;
				rd_wr = 1'b1;
				write_data = write_back[1];
				ns = WRIT2;
				wr_index ='d1;
				//LEDs = 4'd4;
		end
		WRIT2:begin
				req = 1'b1;
				rd_wr = 1'b1;
				write_data = write_back[2];
				ns = WRIT;
				wr_index ='d2;
				//LEDs = 4'd5;
		end
		WRIT: begin // write operation here.
				if(set_count == 8'd149)begin
					ns = DONE;
					windowCountClr = 1'b1;
					req = 1'b1;
				end
				else begin
					ns = TEMP;
					activate_template = 1'b1;		//activate template handler, get address ready.
					row = template_row;				//
					col = template_col;				// 
					tem_win = 1'b0;					// select template format.
					req = 1'b1;						// want to use memory
				end
				//LEDs = 4'd6;
		end
		DONE: begin// signal the finish of a frame.
			set_done = 1'b1;				//finish a frame.
			ns = INIT;
			//LEDs = 4'd7;
		end
		endcase
end
	
	always_ff @(posedge clk, negedge rst_n) begin
		if(~rst_n) begin
			cs <= INIT;
			write_back <= 96'b0;
		end
		else begin
			cs <= ns;
			write_back <= write_back_new;
		end
	end

endmodule: user_FPGA_format

module counter_local
    #(parameter w = 256)
    (input logic clk, rst_n, clr, enable,
    output bit [w-1:0] count);
    
    always_ff @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            count <= 'd0;
        end
        else if (clr) begin
            count <= 'd0;
        end
        else if (enable) begin
            count <= count + 'd1;
        end
    end
endmodule: counter_local

