// tests the user_FPGA_format code that Gun wrote

module gun_tb;
	logic			clk, rst_n;
	logic	[31:0]	read_data;
	logic			ready_2_start;

	logic			tem_win;
	logic			req;
	logic			rd_wr;
	logic	[31:0]	write_data;
	logic			set_done;
	logic	[6:0]	row, col;
	logic	[9:-54] greatestNCCLog2;
	logic	[9:0]	greatestWindowIndex;

	user_FPGA_format uFF(.*);

	
endmodule:gun_tb
