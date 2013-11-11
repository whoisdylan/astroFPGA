//tb to simulate a row of PEs, just the PEs
module tb();
	logic clk, rst, loadDesc, loadWin, loadAcc;
	bit [5:-27] descIn [3:0];
	bit [7:0] accOut [3:0];
	bit [5:-27] windowIn;
	bit [5:-27] windowOut [3:0];
	bit [5:-27] descPixelOut [63:0];
	processingElement (descIn[0], windowIn, clk, rst, loadDesc, loadWin, loadAcc, 'd0, accOut[0], windowOut[0]);
	processingElement (descIn[1], windowOut[0], clk, rst, loadDesc, loadWin, loadAcc, accOut[0], accOut[1], windowOut[1]);
	processingElement (descIn[2], windowOut[1], clk, rst, loadDesc, loadWin, loadAcc, accOut[1], accOut[2], windowOut[2]);
	processingElement (descIn[3], windowOut[2], clk, rst, loadDesc, loadWin, loadAcc, accOut[2], accOut[3], windowOut[3]);

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	initial begin
		$monitor($stime,,"accOut1=%b, accOut2=%b, accOut3=%b, accOut4=%b", accOut[0], accOut[1], accOut[2], accOut[3]);
		desc[0] =	33'b000001000000000000000000000000000;
		desc[1] =	33'b000010000000000000000000000000000;
		desc[2] =	33'b000100000000000000000000000000000;
		desc[3] =	33'b001000000000000000000000000000000;
		windowIn =	33'b010000000000000000000000000000000;
		rst <= 1'b1;
		@(posedge clk)
		rst <= 1'b0;
		loadDesc <= 1'b1;
		@(posedge clk)
		loadDesc <= 1'b0;
		loadWin <= 1'b1;
		@(posedge clk)
		loadWin <= 1'b0;
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
