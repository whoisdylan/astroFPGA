`default_nettype none

module systemTest;
/*
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
*/
	logic			clk;
	logic			rst_n;
	logic [31:0]	rd_data;
	logic			rd_ready;
	logic [31:0]	pci_input_data;
	logic [20:0]	pci_req_addr;
	logic			pci_wr_en;
	logic [31:0]	in_flag;
	
	logic			flag_we;
	logic [31:0]	out_flag;
	logic			rd_req;
	logic [31:0]	write_data;
	logic [20:0]	req_addr;
	logic			FPGA_wr_en;
	logic [9:-54]	greatestNCCLog2;
	logic [8:0]		greatestWindowIndex;

	logic [2**18 -1:0][31:0]	 mem;
	int i,j,k;
    
	logic [6:0]		row_test, col_test;
	logic tem;
	logic [7:0]		set_test;
	logic [20:0]	address;
	

    user_interface uft (.*);
/*
	address_translator ah(row_test, col_test, tem, set_test, address);

	initial begin
		row_test = 0;
		col_test = 0;
		tem = 0;
		set_test = 'd1;
		#1;
		$display("address =%d", address);

	end
*/
always@(posedge clk)begin
	rd_data <=#1 mem[req_addr];
end

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
/*
		$monitor($stime,, "clk=%d, rst_n=%d, req=%d, rd_wr=%d, write_data=%d, read_data=%d, set_done=%d, row=%d, col=%d, tem_win=%d,ready_2_start=%d, greatestNCCLog2=%b, greatestWindowIndex=%d", clk, rst_n, req, rd_wr, write_data, read_data, set_done, row, col, tem_win, ready_2_start, greatestNCCLog2, greatestWindowIndex);
*/	

	$monitor($time, , "address =%d, data = %h, %s tem_win =%b, row =%d col =%d set =%d", req_addr, rd_data, uft.chop.cs,uft.chop.tem_win, uft.chop.row, uft.chop.col, uft.set);


		clk = 0;
        rst_n = 0;
        rst_n <= #1 1;
		forever  #5 clk =~clk;
	end
	
	initial begin
		// set up the memory
		for(i = 0; i < 150; i++)begin
			mem[1665*i]  =  32'h 42;
			for(j = 0; j < 64; j++) begin
				mem[1665*i +j +1] = 32'h FFFF0000 + j;
			end
			for(k = 0; k < 1600; k++) begin
				mem[1665*i +64 +1 + k] = 32'h11110000 + k;
			end
		end
/*	
	#1;
	for(i = 0; i < 249750 ; i++)begin
		$display("%h",mem[i]);
	end
*/

	in_flag = 32'h0001_0000;		//signal to start.



	@(posedge clk);
	in_flag = 32'h0000_0000;

repeat(50) @(posedge clk);

	#85000;
	
	/*
		//rs = new(20);
		for (i = 0; i<10000; i++) begin
            if (~set_done) begin
                read_data =$random(read_data);
				//$display(read_data);
				//$display(i);
				//if(uft.result_ready =='d1) $display($time,," %d", uft.result_ready);
                ready_2_start = 1;
            end
            else begin
                read_data = 0;
                ready_2_start = 0;
            end
			@(posedge clk);
		end
		$stop;
		*/
		$stop;
	end
	
endmodule: systemTest
