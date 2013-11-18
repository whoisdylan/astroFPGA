//tb to simulate a row of PEs, just the PEs
`default_nettype none
module tb();
	logic clk, rst, desc_data_ready, window_data_ready, done_with_window_data, done_with_desc_data;
	bit [31:0] descIn;
	bit [7:0] windowIn [15:0] [15:0];
	bit [31:0] greatestNCC;
	bit [8:0] greatestWinIndex;
	bit [31:0] accRowTotal [15:0];
	bit [31:0] num, denom;

	ncc ncc_inst(clk, rst, window_data_ready, desc_data_ready, descIn, windowIn, 
		done_with_window_data, done_with_desc_data, greatestNCC, greatestWinIndex, num, denom, accRowTotal);

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	initial begin
		$monitor($stime,,"********************************************************************************\nart1=%d, art15=%d, art16=%d, numTot=%d, greatestNCC=%d, winIndex=%d\nnum=%b, denom=%b\ndsos=%d, wsos=%d", accRowTotal[0], accRowTotal[14], accRowTotal[15], ncc.accPatchSum, greatestNCC, greatestWinIndex, num, denom, ncc.descSumOfSquares, ncc.winSumOfSquares);
		descIn[31:24] = 8'd3;
		descIn[23:16] = 8'd4;
		descIn[15:8] = 8'd5;
		descIn[7:0] = 8'd6;
		for (int row = 0; row < 16; row++) begin
			for (int col = 0; col < 16; col++) begin
				windowIn[row][col] = 8'd2;
			end
		end
		rst <= 1'b1;
		@(posedge clk)
		rst <= 1'b0;
		desc_data_ready = 1'b1;
		repeat (64) @(posedge clk);
		desc_data_ready = 1'b0;
		@(posedge clk)
		window_data_ready = 1'b1;
		@(posedge clk)
		window_data_ready = 1'b0;
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		$finish;
	end
endmodule: tb
