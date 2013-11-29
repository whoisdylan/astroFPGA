`default_nettype none

module systemTest;

    bit clk;                //I
    bit rst_n;              //I
    bit req;                //O
    bit rd_wr;              //O
    bit [31:0] write_data;  //O
    bit [31:0] read_data;   //I
    bit set_done;           //O
    bit [6:0] row;          //O
    bit [6:0] col;          //O
    bit tem_win;            //O
    bit ready_2_start;      //I
	bit [9:-54] greatestNCCLog2; //O
	bit [8:0] greatestWindowIndex; //O

	int i;
    
    user_FPGA_format uft (.*);

	initial begin

        $display("hello world");
/*
$monitor($stime,, "clk=%d, rstn=%d, cs=%s wind.cs =%s, store_col =%d store_row=%d, window_data=%h", clk,rst_n,uft.cs,uft.do_wind.cs ,uft.do_wind.store_col, uft.do_wind.store_row, uft.window_data);
*/
/*
		$monitor($stime,, "clk=%d, rstn=%d, cs=%s wind.cs =%s store_col =%d store_row=%d, input =%d", clk,rst_n,uft.cs,uft.do_wind.cs,uft.do_wind.store_col, uft.do_wind.store_row, uft.do_wind.format_space.input_data);
*/
/*
		$monitor($stime,, "clk=%d, rstn=%d, cs=%s template_data =%d do_temp_cs = %s", clk,rst_n,uft.cs, uft.template_data,uft.do_temp.cs);
*/

/*
		$monitor($stime,, "clk=%d, rstn=%d, cs=%s, window_data_ready =%b, desc_data_ready =%b, desc_data_in =%d", clk,rst_n, uft.cs, uft.window_ready, uft.template_ready,uft.template_data);
*/

		$monitor($stime,, "clk=%d, rst_n=%d, req=%d, rd_wr=%d, write_data=%d, read_data=%d, set_done=%d, row=%d, col=%d, tem_win=%d,ready_2_start=%d, greatestNCCLog2=%d, greatestWindowIndex=%d", clk, rst_n, req, rd_wr, write_data, read_data, set_done, row, col, tem_win, ready_2_start, greatestNCCLog2, greatestWindowIndex);
	
		clk = 0;
        rst_n = 0;
        rst_n <= #1 1;
		forever  #5 clk =~clk;
	end
	
	initial begin
		for (i = 0; i<10000; i++) begin
            if (~set_done) begin
                read_data = row*col%256;
                ready_2_start = 1;
            end
            else begin
                read_data = 0;
                ready_2_start = 0;
            end
			@(posedge clk);
		end
		$stop;
	end
	
endmodule: systemTest
