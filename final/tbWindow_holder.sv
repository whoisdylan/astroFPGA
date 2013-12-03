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
	logic [31:-32]	greatestNCCLog2;
	logic [11:0]		greatestWindowIndex;

	logic [2**18 -1:0][31:0]	 mem;
	int i,j,k;
    
	logic [6:0]		row, col;
	logic			new_row;
	logic			load;
	logic [15:0][15:0][7:0]	window_data;
	logic [20:0]	address;
	logic [31:0]	input_data;
	logic [6:0]		window_offset;
	

	window_holder dut(clk,rst_n,rd_data,window_offset,row,col,new_row,load,window_data);



	address_translator ah(row, col, 1'b1, 8'd0, req_addr,1'b0);

/*
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
	$monitor($time, , "row = %d, col =%d, addr =%d, rd_data = %h, storage=%h", row, col, req_addr,rd_data,window_data);

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
/*
	$monitor($time, , "address =%d, data = %h, %s tem_win =%b, row =%d col =%d set =%d greatestNCC =%d.%b\nnum=%b.%b\nden=%b.%b\ncorrCoeffLog2=%b.%b\ndsos=%d, wsos=%d\ndesc_in=%b,%b,%b,%b\nwin_in=%b,%b,%b,%b\nwin_hand_data_in=%b,%b,%b,%b\nwin_hand_data_out=%b,%b,%b,%b", req_addr, rd_data, uft.chop.cs,uft.chop.tem_win, uft.chop.row, uft.chop.col, uft.set,$signed(uft.chop.greatestNCCLog2[31:0]),uft.chop.greatestNCCLog2[-1:-32], uft.chop.ncci.numeratorLog2[9:0], uft.chop.ncci.numeratorLog2[-1:-54], uft.chop.ncci.denomLog2[9:0], uft.chop.ncci.denomLog2[-1:-54], uft.chop.ncci.corrCoeffLog2[9:0], uft.chop.ncci.corrCoeffLog2[-1:-54], uft.chop.ncci.descSumOfSquares, uft.chop.ncci.winSumOfSquares, uft.chop.ncci.desc_data_in[35:27], uft.chop.ncci.desc_data_in[26:18], uft.chop.ncci.desc_data_in[17:9], uft.chop.ncci.desc_data_in[8:0], uft.chop.ncci.window_data_in[0][0], uft.chop.ncci.window_data_in[0][1], uft.chop.ncci.window_data_in[0][2], uft.chop.ncci.window_data_in[0][3], uft.chop.do_wind.input_data[31:24], uft.chop.do_wind.input_data[23:16], uft.chop.do_wind.input_data[15:8], uft.chop.do_wind.input_data[7:0], uft.chop.do_wind.window_data[0][4], uft.chop.do_wind.window_data[0][5], uft.chop.do_wind.window_data[0][6], uft.chop.do_wind.window_data[0][7]);
*/

		clk = 0;
        rst_n = 0;
        rst_n <= #1 1;
		forever  #5 clk =~clk;
	end
	
	initial begin
		// set up the memory
		for(i = 0; i < 1; i++)begin
			mem[1665*i]  =  {24'd0, 8'h42};
			for(j = 0; j < 64; j++) begin
				//mem[1665*i +j +1] = 32'h FFFF0000 + j;
				mem[1665*i +j +1] = 32'h41434143;
			end
			for(k = 0; k < 1600; k++) begin
				//mem[1665*i +64 +1 + k] = 32'h11110000 + k;
				mem[1665*i +64 +1 + k] = 32'h41434143;
			end
		end
	#200;
	/*
	row = 0;
	col = 0;
	new_row = 1'b0;
	load = 1'b1;
	window_offset = 0;
	@(posedge clk);
	row = 0;
	col = 1;
*/
	for(i = 0 ; i <16 ; i++)begin
		for( j = 0; j < 4 ; j++)begin
			row = i;
			col = j;
			new_row = 1'b0;
			load = 1'b1;
			window_offset = 0;
			#20;
		end
	end




repeat(50) @(posedge clk);
	
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
		$finish;
	end
	
endmodule: systemTest
