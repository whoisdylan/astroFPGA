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
/*
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
*/
	logic [2**18 -1:0][31:0]	 mem;
	int i,j,k,icount;
    
	logic [20:0]	address;


	int				count;


	logic				clk, rst_n;
	logic [15:0][15:0][7:0] window_data;
	logic				window_ready;
	logic				en;
	logic [31:0]		input_data;
	logic [6:0]			row;
	logic [6:0]			col;
	logic				done;
	logic				ack;
	logic				receive;
	logic [31:0]		rd_data;
	logic [20:0]		req_addr;
    logic [3:0]         LEDs;

	address_translator trans(row,col, 1'b1,8'b0,address, 1'b0);
	window_handler dut(.*);
assign input_data = rd_data;
assign req_addr = address;
/*
always @(posedge clk) begin
//	$display($time, , "state = %s",uft.cs);
	if(uft.cs == 'b100)begin
		$display($time, ," write back is good!!");
	end
	if(uft.chop.set_done == 1) begin
		$display($time, , "set_done = %b", uft.chop.set_done);
		$display($time, , "the state is = %s", uft.cs);
	end
	if(out_flag == 32'h0000_0004) begin
		$display("receive set complete flag");
	end

	if(uft.rd_wr == 1'b1) begin			// there's a write operation
		$display($time, ,"writing to address %h",req_addr);
	end
	if(uft.chop.window_ready) count++;
end
*/
always@(posedge clk)begin
	rd_data <=#1 mem[req_addr];
end

	initial begin

        $display("hello world");

		$monitor($time, ,"cs = %s, address[dec] = %d, row =%d, col =%d, done =%b, input_data = %h store_row =%d, store_col =%d window_data = \n %h, %h, %h, %h,\n %h, %h, %h, %h,\n %h, %h, %h, %h,\n %h, %h, %h, %h,\n %h, %h, %h, %h,\n %h, %h, %h, %h,\n %h, %h, %h, %h,\n %h, %h, %h, %h,\n %h, %h, %h, %h,\n %h, %h, %h, %h,\n %h, %h, %h, %h,\n %h, %h, %h, %h,\n %h, %h, %h, %h,\n %h, %h, %h, %h,\n %h, %h, %h, %h,\n %h, %h, %h, %h,", dut.cs, address, row,col,done,input_data, dut.store_row, dut.store_col,window_data[0][3:0],window_data[0][7:4],window_data[0][11:8],window_data[0][15:12],   window_data[1][3:0],window_data[1][7:4],window_data[1][11:8],window_data[1][15:12],  window_data[2][3:0],window_data[2][7:4],window_data[2][11:8],window_data[2][15:12],  window_data[3][3:0],window_data[3][7:4],window_data[3][11:8],window_data[3][15:12],  window_data[4][3:0],window_data[4][7:4],window_data[4][11:8],window_data[4][15:12],  window_data[5][3:0],window_data[5][7:4],window_data[5][11:8],window_data[5][15:12],  window_data[6][3:0],window_data[6][7:4],window_data[6][11:8],window_data[6][15:12],  window_data[7][3:0],window_data[7][7:4],window_data[7][11:8],window_data[7][15:12],  window_data[8][3:0],window_data[8][7:4],window_data[8][11:8],window_data[8][15:12],  window_data[9][3:0],window_data[9][7:4],window_data[9][11:8],window_data[9][15:12],  window_data[10][3:0],window_data[10][7:4],window_data[10][11:8],window_data[10][15:12],  window_data[11][3:0],window_data[11][7:4],window_data[11][11:8],window_data[11][15:12],  window_data[12][3:0],window_data[12][7:4],window_data[12][11:8],window_data[12][15:12],  window_data[13][3:0],window_data[13][7:4],window_data[13][11:8],window_data[13][15:12],  window_data[14][3:0],window_data[14][7:4],window_data[14][11:8],window_data[14][15:12],  window_data[15][3:0],window_data[15][7:4],window_data[15][11:8],window_data[15][15:12]);
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
		$monitor($stime,, "clk=%d, rst_n=%d, req=%d, rd_wr=%d, write_data=%d, read_data=%d, set_done=%d, row=%d, col=%d, tem_win=%d,ready_2_start=%d, greatestNCCLog2=%b, greatestWindowIndex=%d, count =%d", clk, rst_n, req, rd_wr, write_data, read_data, set_done, row, col, tem_win, ready_2_start, greatestNCCLog2, greatestWindowIndex, count);
*/	
/*
	$monitor($time, , "address =%d, data = %h, %s tem_win =%b, row =%d col =%d set =%d greatestNCC =%d.%b\nnum=%b.%b\nden=%b.%b\ncorrCoeffLog2=%b.%b\ndsos=%d, wsos=%d\ndesc_in=%b,%b,%b,%b\nwin_in=%b,%b,%b,%b\nwin_hand_data_in=%b,%b,%b,%b\nwin_hand_data_out=%h, count = %d", req_addr, rd_data, uft.chop.cs,uft.chop.tem_win, uft.chop.row, uft.chop.col, uft.set,$signed(uft.chop.greatestNCCLog2[31:0]),uft.chop.greatestNCCLog2[-1:-32], uft.chop.ncci.numeratorLog2[9:0], uft.chop.ncci.numeratorLog2[-1:-54], uft.chop.ncci.denomLog2[9:0], uft.chop.ncci.denomLog2[-1:-54], uft.chop.ncci.corrCoeffLog2[9:0], uft.chop.ncci.corrCoeffLog2[-1:-54], uft.chop.ncci.descSumOfSquares, uft.chop.ncci.winSumOfSquares, uft.chop.ncci.desc_data_in[35:27], uft.chop.ncci.desc_data_in[26:18], uft.chop.ncci.desc_data_in[17:9], uft.chop.ncci.desc_data_in[8:0], uft.chop.ncci.window_data_in[0][0], uft.chop.ncci.window_data_in[0][1], uft.chop.ncci.window_data_in[0][2], uft.chop.ncci.window_data_in[0][3], uft.chop.do_wind.input_data[31:24], uft.chop.do_wind.input_data[23:16], uft.chop.do_wind.input_data[15:8], uft.chop.do_wind.input_data[7:0],uft.chop.do_wind.window_data, count); 
*/

/*
	uft.chop.do_wind.window_data[0][4], uft.chop.do_wind.window_data[0][5], uft.chop.do_wind.window_data[0][6], uft.chop.do_wind.window_data[0][7]);
*/

		clk = 0;
		count = 0;
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
				mem[1665*i +64 +1 + k] = k;
			end
		end
/*	
	#1;
	for(i = 0; i < 249750 ; i++)begin
		$display("%h",mem[i]);
	end
//repeat (10000) @(posedge clk);
*/

//	$display($time, ,"count is =%d", count);


	en = 1;
#10;
	en = 0;

	$display("mem[63] = %h", mem[63]);
	$display("mem[64] = %h", mem[64]);
	$display("mem[65] = %h", mem[65]);
	$display("mem[66] = %h", mem[66]);
	$display("mem[67] = %h", mem[67]);



//repeat(1601) @(posedge clk);
repeat(14401) @(posedge clk);


	    rst_n = 0;
        rst_n <= #1 1;
        en <= 1;
        
        @(posedge clk);
        en <= 0;

        @(posedge clk);
repeat(14401) @(posedge clk);
	
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

/*
        $display("%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d", dut.window_data_mem[0][0], dut.window_data_mem[0][1], dut.window_data_mem[0][2], dut.window_data_mem[0][3], dut.window_data_mem[0][4], dut.window_data_mem[0][5], dut.window_data_mem[0][6], dut.window_data_mem[0][7], dut.window_data_mem[0][8], dut.window_data_mem[0][9], dut.window_data_mem[0][10], dut.window_data_mem[0][11], dut.window_data_mem[0][12], dut.window_data_mem[0][13], dut.window_data_mem[0][14], dut.window_data_mem[0][15], dut.window_data_mem[79][76], dut.window_data_mem[79][77], {dut.window_data_mem[79][78], dut.window_data_mem[79][79]});
		*/
         /*dut.window_data_mem[0][0], dut.window_data_mem[0][1], dut.window_data_mem[0][2], dut.window_data_mem[0][3], dut.window_data_mem[0][4], dut.window_data_mem[0][5], dut.window_data_mem[0][6], dut.window_data_mem[0][7], dut.window_data_mem[0][8], dut.window_data_mem[0][9], dut.window_data_mem[0][10]
       dut.window_data_mem[0][0], dut.window_data_mem[0][1], dut.window_data_mem[0][2], dut.window_data_mem[0][3], dut.window_data_mem[0][4], dut.window_data_mem[0][5], dut.window_data_mem[0][6], dut.window_data_mem[0][7], dut.window_data_mem[0][8], dut.window_data_mem[0][9], dut.window_data_mem[0][10]
        dut.window_data_mem[0][0], dut.window_data_mem[0][1], dut.window_data_mem[0][2], dut.window_data_mem[0][3], dut.window_data_mem[0][4], dut.window_data_mem[0][5], dut.window_data_mem[0][6], dut.window_data_mem[0][7], dut.window_data_mem[0][8], dut.window_data_mem[0][9], dut.window_data_mem[0][10]
        dut.window_data_mem[0][0], dut.window_data_mem[0][1], dut.window_data_mem[0][2], dut.window_data_mem[0][3], dut.window_data_mem[0][4], dut.window_data_mem[0][5], dut.window_data_mem[0][6], dut.window_data_mem[0][7], dut.window_data_mem[0][8], dut.window_data_mem[0][9], dut.window_data_mem[0][10]
        dut.window_data_mem[0][0], dut.window_data_mem[0][1], dut.window_data_mem[0][2], dut.window_data_mem[0][3], dut.window_data_mem[0][4], dut.window_data_mem[0][5], dut.window_data_mem[0][6], dut.window_data_mem[0][7], dut.window_data_mem[0][8], dut.window_data_mem[0][9], dut.window_data_mem[0][10]
        dut.window_data_mem[0][0], dut.window_data_mem[0][1], dut.window_data_mem[0][2], dut.window_data_mem[0][3], dut.window_data_mem[0][4], dut.window_data_mem[0][5], dut.window_data_mem[0][6], dut.window_data_mem[0][7], dut.window_data_mem[0][8], dut.window_data_mem[0][9], dut.window_data_mem[0][10]
        dut.window_data_mem[0][0], dut.window_data_mem[0][1], dut.window_data_mem[0][2], dut.window_data_mem[0][3], dut.window_data_mem[0][4], dut.window_data_mem[0][5], dut.window_data_mem[0][6], dut.window_data_mem[0][7], dut.window_data_mem[0][8], dut.window_data_mem[0][9], dut.window_data_mem[0][10]
        dut.window_data_mem[0][0], dut.window_data_mem[0][1], dut.window_data_mem[0][2], dut.window_data_mem[0][3], dut.window_data_mem[0][4], dut.window_data_mem[0][5], dut.window_data_mem[0][6], dut.window_data_mem[0][7], dut.window_data_mem[0][8], dut.window_data_mem[0][9], dut.window_data_mem[0][10]*/
		$finish;
	end
	
endmodule: systemTest
