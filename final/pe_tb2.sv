//tb to simulate a row of PEs, just the PEs
module tb();
	logic clk, rst, loadDesc, loadWin, loadAcc;
	bit [5:-27] descIn [3:0];
	bit [31:0] accOut [3:0];
	bit [31:0] accTotal;
	bit [5:-27] windowIn [3:0];
	bit [5:-27] descPixelOut [63:0];
	processingElement pe1 (descIn[0], windowIn[0], clk, rst, loadDesc, loadWin, loadAcc, 32'd0, accOut[0]);
	processingElement pe2 (descIn[1], windowIn[1], clk, rst, loadDesc, loadWin, loadAcc, accOut[0], accOut[1]);
	processingElement pe3 (descIn[2], windowIn[2], clk, rst, loadDesc, loadWin, loadAcc, accOut[1], accOut[2]);
	processingElement pe4 (descIn[3], windowIn[3], clk, rst, loadDesc, loadWin, loadAcc, accOut[2], accOut[3]);
	register #(32) accReg (accOut[3], clk, rst, loadAcc, accTotal);

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	initial begin
		$monitor($stime,,"********************************************************************************\naccTemp1=%b, accTemp2=%b, accTemp3=%b, accTemp4=%b\n accOut1=%d, accOut2=%d, accOut3=%d, accOut4=%d, accTot=%d\n tsl=%b, ts=%d", pe1.accSum, pe2.accSum, pe3.accSum, pe4.accSum, accOut[0], accOut[1], accOut[2], accOut[3], accTotal, pe1.tempSumLog2, pe1.tempSum);
		descIn[0] =		33'b000001000000000000000000000000000;
		descIn[1] =		33'b000010000000000000000000000000000;
		descIn[2] =		33'b000011000000000000000000000000000;
		descIn[3] =		33'b000100000000000000000000000000000;
		windowIn[0] =	33'b000101000000000000000000000000000;
		windowIn[1] =	33'b000110000000000000000000000000000;
		windowIn[2] =	33'b000111000000000000000000000000000;
		windowIn[3] =	33'b000111000000000000000000000000000;
		rst <= 1'b1;
		@(posedge clk)
		rst <= 1'b0;
		loadDesc <= 1'b1;
		@(posedge clk)
		loadDesc <= 1'b0;
		loadWin <= 1'b1;
		@(posedge clk)
		loadWin <= 1'b0;
		loadAcc <= 1'b1;
		@(posedge clk)
		loadAcc <= 1'b0;
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
