//tb to simulate a row of PEs, just the PEs
module tb();
	logic clk, rst, loadDesc, loadWin, loadAcc;
	bit [5:-27] descIn [3:0];
	bit [7:0] accOut [3:0];
	bit [5:-27] windowIn;
	bit [5:-27] windowOut [3:0];
	bit [5:-27] descPixelOut [63:0];
	processingElement pe1 (descIn[0], windowIn, clk, rst, loadDesc, loadWin, loadAcc, 8'd0, accOut[0], windowOut[0]);
	processingElement pe2 (descIn[1], windowOut[0], clk, rst, loadDesc, loadWin, loadAcc, accOut[0], accOut[1], windowOut[1]);
	processingElement pe3 (descIn[2], windowOut[1], clk, rst, loadDesc, loadWin, loadAcc, accOut[1], accOut[2], windowOut[2]);
	processingElement pe4 (descIn[3], windowOut[2], clk, rst, loadDesc, loadWin, loadAcc, accOut[2], accOut[3], windowOut[3]);

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	initial begin
		$monitor($stime,,"windowOut1=%b, windowOut2=%b, windowOut3=%b, windowOut4=%b\n accTemp1=%b, accTemp2=%b, accTemp3=%b, accTemp4=%b\n accOut1=%b, accOut2=%b, accOut3=%b, accOut4=%b\n tsl=%b, ts=%b", windowOut[0], windowOut[1], windowOut[2], windowOut[3], pe1.accSum, pe2.accSum, pe3.accSum, pe4.accSum, accOut[0], accOut[1], accOut[2], accOut[3], pe1.tempSumLog2, pe1.tempSum);
		descIn[0] =	33'b000001000000000000000000000000000;
		descIn[1] =	33'b000010000000000000000000000000000;
		descIn[2] =	33'b000100000000000000000000000000000;
		descIn[3] =	33'b001000000000000000000000000000000;
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
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		$finish;
	end
endmodule: tb
