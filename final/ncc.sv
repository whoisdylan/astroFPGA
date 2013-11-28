`default_nettype none
module ncc
	#(parameter descSize = 2048,
	 parameter numPixelsDesc = 256,
	 parameter windowSize = 640)
	(input logic clk, rst, window_data_ready, desc_data_ready,
	input bit [31:0] desc_data_in,
	input bit [7:0] window_data_in[15:0][15:0],
	output logic done_with_window_data, done_with_desc_data,
	output bit [9:-54] greatestNCCLog2,
	output bit [8:0] greatestWindowIndex,
	output bit [31:0] accRowTotal [15:0]);

	enum logic {DESC_WAIT, DESC_LOAD} currStateDesc, nextStateDesc;
	enum logic {WIN_WAIT, WIN_LOAD} currStateWin, nextStateWin;
	logic winWriteA, winWriteB;

	//descriptor loading datapath hardware
	logic incDescRowC, incDescColC, loadDescGroup1, loadDescGroup2, loadDescGroup3, loadDescGroup4;
	logic loadDescNow, loadWinReg;
	logic [15:0] loadRow;
	logic [3:0] loadColGroup;
	bit [31:0] accOut [239:0];
	bit [3:0] descRowC;
	bit [1:0] descColC;
	/*bit [10:-54] descLog2_1, descLog2_2, descLog2_3, descLog2_4;*/
	bit [10:-54] descLog2 [3:0];
	bit [10:-54] windowLog2 [15:0] [15:0];
	bit [31:0] descPixelOut [255:0];
	bit [31:0] winPixelOut [255:0];
	counter #(4) descRowCounter(clk, rst, 1'b0, incDescRowC, descRowC);
	counter #(2) descColCounter(clk, rst, 1'b0, incDescColC, descColC);

	//descriptor log2 hardware
	log2 descLog2_inst1({24'd0, desc_data_in[31:24]}, descLog2[0]);
	log2 descLog2_inst2({24'd0, desc_data_in[23:16]}, descLog2[1]);
	log2 descLog2_inst3({24'd0, desc_data_in[15:8]}, descLog2[2]);
	log2 descLog2_inst4({24'd0, desc_data_in[7:0]}, descLog2[3]);

	decoder #(4) desc_decoder_col(descColC, loadColGroup);
	decoder #(16) desc_decoder_row(descRowC, loadRow);

	//window log2 hardware
	genvar i, j;
	generate
		for (i = 0; i < 16; i++) begin
			for (j = 0; j < 16; j++) begin
				log2 windowLog2_inst({24'd0, window_data_in[i][j]}, windowLog2[i][j]);
			end
		end
	endgenerate

	//generate 16x16 PE grid
	generate
		for (i = 0; i < 16; i++) begin
			for (j = 0; j < 16; j++) begin
				int k = j/4;
				if (j == 0) begin
					//set accIn = 0 for first PE in row
					processingElement PE_inst(.clk(clk), .rst(rst), .descPixelLog2In(descLog2[j%4]), .windowPixelLog2In(windowLog2[i][j]), .loadDescReg(loadColGroup[k]&loadRow[i]&loadDescNow), .loadWinReg(loadWinReg), .accIn('d0), .descPixelOut(descPixelOut[j+i*16]), .windowPixelOut(winPixelOut[j+i*16]), .accOut(accOut[j+i*15]));
				end
				else if (j == 'd15) begin
					processingElement PE_inst(.clk(clk), .rst(rst), .descPixelLog2In(descLog2[j%4]), .windowPixelLog2In(windowLog2[i][j]), .loadDescReg(loadColGroup[k]&loadRow[i]&loadDescNow), .loadWinReg(loadWinReg), .accIn(accOut[j-1+i*15]), .descPixelOut(descPixelOut[j+i*16]), .windowPixelOut(winPixelOut[j+i*16]), .accOut(accRowTotal[i]));
				end
				else begin
					processingElement PE_inst(.clk(clk), .rst(rst), .descPixelLog2In(descLog2[j%4]), .windowPixelLog2In(windowLog2[i][j]), .loadDescReg(loadColGroup[k]&loadRow[i]&loadDescNow), .loadWinReg(loadWinReg), .accIn(accOut[j-1+i*15]), .descPixelOut(descPixelOut[j+i*16]), .windowPixelOut(winPixelOut[j+i*16]), .accOut(accOut[j+i*15]));
				end
			end
		end
	endgenerate

	bit [31:0] accPatchSum;
	//bit [31:0] correlationCoefficient;
	bit [9:-54] denomLog2, corrCoeffLog2;
	bit [31:0] descSumOfSquares, winSumOfSquares;
	bit [10:-54] descSumOfSquaresLog2, winSumOfSquaresLog2;
	bit [10:-54] numeratorLog2;
	/*bit [31:0] accTotalSum;*/

	assign accPatchSum = accRowTotal[0] + accRowTotal[1] + accRowTotal[2] + accRowTotal[3] + accRowTotal[4] + accRowTotal[5] + accRowTotal[6] + accRowTotal[7] + accRowTotal[8] + accRowTotal[9] + accRowTotal[10] + accRowTotal[11] + accRowTotal[12] + accRowTotal[13] + accRowTotal[14] + accRowTotal[15];
	log2 num_log2_inst (accPatchSum, numeratorLog2);

	//compute denominator
	//compute sum of squares for denominator
	always_comb begin
		descSumOfSquares = 0;
		winSumOfSquares = 0;
		for (int rowI = 0; rowI < 16; rowI++) begin
			for (int colI = 0; colI < 16; colI++) begin
				//$display("descVal=%b\nwinVal=%b",descPixelOut[rowI*16+colI],winPixelOut[rowI*16+colI]);
				//$display("dval=%d\n",descPixelOut[rowI*16+colI]);
				descSumOfSquares = descSumOfSquares + descPixelOut[rowI*16 + colI];
				winSumOfSquares = winSumOfSquares + winPixelOut[rowI*16 + colI];
				//$display("dsos=%b\nwsos=%b",descSumOfSquares,winSumOfSquares);
			end
		end
	end
	log2 denom_desc_log2_inst (descSumOfSquares, descSumOfSquaresLog2);
	log2 denom_win_log2_inst (winSumOfSquares, winSumOfSquaresLog2);

	//part 2 of denominator
	assign denomLog2 = (descSumOfSquaresLog2[9:-54] + winSumOfSquaresLog2[9:-54]) >> 1;

	//final computation
	always_comb begin
		corrCoeffLog2 = numeratorLog2[9:-54] - denomLog2;
		if (corrCoeffLog2 > numeratorLog2[9:-54]) begin
			corrCoeffLog2 = 32'b1;
		end
	end
	//assign corrCoeffLog2 = numeratorLog2[9:-54] - denomLog2;
	//ilog2 denom_ilog2_inst (corrCoeffLog2, correlationCoefficient);
	
	//register to store the entire patch acc total sum
	//register #(32) accReg (accPatchSum, clk, rst, loadAccSumReg, accTotalSum);

	logic loadGreatestReg, clearWinCount;
	bit [8:0] windowCount;
	//register to store greatest correlation coefficient and window index
	priorityRegister #(9) greatestNCCReg (corrCoeffLog2, windowCount, clk, rst, loadGreatestReg, greatestNCCLog2, greatestWindowIndex);
	counter #(9) windowCounter (clk, rst, clearWinCount, loadGreatestReg, windowCount);

	//descriptor loading fsm
	always_comb begin
		done_with_desc_data = 1'b0;
		loadDescNow = 1'b0;
		incDescColC = 1'b0;
		incDescRowC = 1'b0;
		case (currStateDesc)
			DESC_WAIT: begin
				if (desc_data_ready) begin
					loadDescNow = 1'b1;
					incDescColC = 1'b1;
					if (descColC == 'd3) begin
						incDescRowC = 1'b1;
					end
					nextStateDesc = DESC_WAIT;
				end
				else begin
					nextStateDesc = DESC_WAIT;
				end
			end
			/*DESC_LOAD: begin*/
			/*	if (descColC == 'd3) begin*/
			/*		incDescRowC = 1'b1;*/
			/*	end*/
			/*	incDescColC = 1'b1;*/
			/*	nextStateDesc = DESC_WAIT;*/
			/*end*/
			default: nextStateDesc = DESC_WAIT;
		endcase
	end

	//window loading fsm
	always_comb begin
		done_with_window_data = 1'b0;
		loadWinReg = 1'b0;
		loadGreatestReg = 1'b0;
		clearWinCount = 1'b0;
		case (currStateWin)
			WIN_WAIT: begin
				if (window_data_ready) begin
					loadWinReg = 1'b1;
					nextStateWin = WIN_LOAD;
				end
				else begin
					nextStateWin = WIN_WAIT;
				end
			end
			WIN_LOAD: begin
				loadGreatestReg = 1'b1;
				done_with_window_data = 1'b1;
				if (windowCount >= (149)) begin
					clearWinCount = 1'b1;
				end
				nextStateWin = WIN_WAIT;
			end
			default: nextStateWin = WIN_WAIT;
		endcase
	end

	// greatest ncc reg fsm
	/*always_comb begin*/
	/*	loadGreatestReg = 1'b0;*/
	/*	case (currStatePrio)*/
	/*		PRIO_WAIT: begin*/
	/*			if (loadAccReg) begin*/
	/*				loadGreatestReg = 1'b1;*/
	/*				nextStatePrio = PRIO_WAIT;*/
	/*			end*/
	/*			else*/
	/*				nextStatePrio = PRIO_WAIT;*/
	/*			end*/
	/*		end*/
	/*		default: nextStatePrio = PRIO_WAIT;*/
	/*	endcase*/
	/*end*/

	//state register
	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			currStateDesc <= DESC_WAIT;
			currStateWin <= WIN_WAIT;
		end
		else begin
			currStateDesc <= nextStateDesc;
			currStateWin <= nextStateWin;
		end
	end

endmodule: ncc

module mux
	#(parameter w = 4)
	(input bit [w-1:0] in,
	input bit [$clog2(w)-1:0] sel,
	output bit out);
	
	assign out = in[sel];

endmodule: mux

/*module demux*/
/*	#(parameter w = 4)*/
/*	(input bit in,*/
/*	input bit [$clog2(w)-1:0] sel,*/
/*	output bit [w-1:0] out);*/
/**/
/*	assign out[sel] = in;*/
/**/
/*endmodule: demux*/

module decoder
	#(parameter w = 4)
	(input bit [$clog2(w)-1:0] sel,
	output bit [w-1:0] out);

	always_comb begin
		out = 'd1 << sel;
	end

endmodule: decoder

module counter
	#(parameter w = 256)
	(input logic clk, rst, clr, enable,
	output bit [w-1:0] count);

	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			count <= 'd0;
		end
		else if (clr) begin
			count <= 'd0;
		end
		else if (enable) begin
			count <= count + 'd1;
		end
	end
endmodule: counter

module processingElement
	(input bit	[10:-54]	descPixelLog2In,
	 input bit	[10:-54]	windowPixelLog2In,
	 input bit			clk, rst, loadDescReg, loadWinReg,
	 input bit	[31:0]	accIn,
	 output bit [31:0] descPixelOut,
	 output bit [31:0] windowPixelOut,
	 output bit	[31:0]	accOut);
	
	bit [10:-54] descPixelLog2Out, windowPixelLog2Out;
	bit [9:-54] tempSumLog2, descPixelLog2, windowPixelLog2;
	bit [31:0] tempSum;
	bit [31:0] accSum;
	bit descSignBit;
	assign descSignBit = descPixelLog2Out[10];

	ilog2 ilog2_inst (tempSumLog2, tempSum);

	//register for descriptor pixel
	registerLog2 #(10) descReg (descPixelLog2In, clk, rst, loadDescReg, descPixelLog2Out);
	//register for storing "LTC"
	registerLog2 #(10) windowReg (windowPixelLog2In, clk, rst, loadWinReg, windowPixelLog2Out);
	//register for "ACCin + ltc*f
	//register #(32) accReg (accSum, clk, rst, loadAccSumReg, accOut);

	//output the ilog2 of the square of the pixels for denominator computation
	assign descPixelLog2 = descPixelLog2Out[9:-54] << 1;
	assign windowPixelLog2 = windowPixelLog2Out[9:-54] << 1;
	ilog2 ilog2_desc_inst (descPixelLog2, descPixelOut);
	ilog2 ilog2_win_inst (windowPixelLog2, windowPixelOut);

	assign tempSumLog2 = descPixelLog2Out[9:-54] + windowPixelLog2Out[9:-54];
	assign accOut = (descSignBit ^ windowPixelLog2Out[10]) ?
					(accIn - tempSum) : (accIn + tempSum);

endmodule: processingElement

module log2
	(input bit [31:0] dataIn,
	output bit [10:-54] dataOut);

	bit [31:0] fraction;

	bit [4:0] oneIndex;
	findFirstOne #(32) firstOneFinder(dataIn, oneIndex);
	
	assign fraction = dataIn << (32-oneIndex);
	assign dataOut = {dataIn[31], 5'd0, oneIndex, fraction, 22'd0};

endmodule: log2

module ilog2
	(input bit [9:-54] dataIn,
	output bit [31:0] dataOut);
	always_comb begin
		dataOut = 32'd1 << dataIn[9:0];
		unique case (dataIn[9:0])
			10'd0: begin
			end
			10'd1: begin
				dataOut[0] = dataIn[-1];
			end
			10'd2: begin
				dataOut[1:0] = dataIn[-1:-2];
			end
			10'd3: begin
				dataOut[2:0] = dataIn[-1:-3];
			end
			10'd4: begin
				dataOut[3:0] = dataIn[-1:-4];
			end
			10'd5: begin
				dataOut[4:0] = dataIn[-1:-5];
			end
			10'd6: begin
				dataOut[5:0] = dataIn[-1:-6];
			end
			10'd7: begin
				dataOut[6:0] = dataIn[-1:-7];
			end
			10'd8: begin
				dataOut[7:0] = dataIn[-1:-8];
			end
			10'd9: begin
				dataOut[8:0] = dataIn[-1:-9];
			end
			10'd10: begin
				dataOut[9:0] = dataIn[-1:-10];
			end
			10'd11: begin
				dataOut[10:0] = dataIn[-1:-11];
			end
			10'd12: begin
				dataOut[11:0] = dataIn[-1:-12];
			end
			10'd13: begin
				dataOut[12:0] = dataIn[-1:-13];
			end
			10'd14: begin
				dataOut[13:0] = dataIn[-1:-14];
			end
			10'd15: begin
				dataOut[14:0] = dataIn[-1:-15];
			end
			10'd16: begin
				dataOut[15:0] = dataIn[-1:-16];
			end
			10'd17: begin
				dataOut[16:0] = dataIn[-1:-17];
			end
			10'd18: begin
				dataOut[17:0] = dataIn[-1:-18];
			end
			10'd19: begin
				dataOut[18:0] = dataIn[-1:-19];
			end
			10'd20: begin
				dataOut[19:0] = dataIn[-1:-20];
			end
			10'd21: begin
				dataOut[20:0] = dataIn[-1:-21];
			end
			10'd22: begin
				dataOut[21:0] = dataIn[-1:-22];
			end
			10'd23: begin
				dataOut[22:0] = dataIn[-1:-23];
			end
			10'd24: begin
				dataOut[23:0] = dataIn[-1:-24];
			end
			10'd25: begin
				dataOut[24:0] = dataIn[-1:-25];
			end
			10'd26: begin
				dataOut[25:0] = dataIn[-1:-26];
			end
			10'd27: begin
				dataOut[26:0] = dataIn[-1:-27];
			end
			10'd28: begin
				dataOut[27:0] = {dataIn[-1:-28]};
			end
			10'd29: begin
				dataOut[28:0] = {dataIn[-1:-29]};
			end
			10'd30: begin
				dataOut[29:0] = {dataIn[-1:-30]};
			end
			10'd31: begin
				dataOut[30:0] = {dataIn[-1:-31]};
			end
		endcase
	end
endmodule: ilog2

/*module ilog2*/
/*	(input bit [9:-54] dataIn,*/
/*	output bit [31:0] dataOut);*/
/*	always_comb begin*/
/*		dataOut = 32'd1 << dataIn[4:0];*/
/*		if (dataIn[4:0]) begin*/
/*			dataOut[dataIn[4:0]:0] = dataIn[-1:-1+dataIn[4:0]];*/
/*		end*/
/*	end*/
/*endmodule: ilog2*/

module findFirstOne
	#(parameter w = 32)
	(input bit [w-1:0] dataIn,
	output bit [$clog2(w)-1:0] index);

	bit [$clog2(w)-1:0] zeros, zeros1, zeros2, zeros3, zeros4, zeros5;
	bit [w-1:0] temp2, temp3, temp4, temp5;

	assign index = 'd31 - zeros;
	assign zeros = zeros1 + zeros2 + zeros3 + zeros4 + zeros5;

	always_comb begin
		if (dataIn == 'd0) begin
			zeros1 = 'd31;
			temp2 = 'hffffffff;
		end
		else begin
			if (dataIn <= 'hffff) begin
				zeros1 = 'd16;
				temp2 = dataIn << 'd16;
			end
			else begin
				zeros1 = 'd0;
				temp2 = dataIn;
			end
		end
	end
	always_comb begin
		if (temp2 <= 'hffffff) begin
			zeros2 = 'd8;
			temp3 = temp2 << 'd8;
		end
		else begin
			zeros2 = 'd0;
			temp3 = temp2;
		end
	end
	always_comb begin
		if (temp3 <= 'hfffffff) begin
			zeros3 = 'd4;
			temp4 = temp3 << 'd4;
		end
		else begin
			zeros3 = 'd0;
			temp4 = temp3;
		end
	end
	always_comb begin
		if (temp4 <= 'h3fffffff) begin
			zeros4 = 'd2;
			temp5 = temp4 << 'd2;
		end
		else begin
			zeros4 = 'd0;
			temp5 = temp4;
		end
	end
	always_comb begin
		if (temp5 <= 'h7fffffff) begin
			zeros5 = 'd1;
		end
		else begin
			zeros5 = 'd0;
		end
	end
endmodule: findFirstOne

module absoluteValue
	(input bit [31:0] dataIn,
	output bit [31:0] dataOut,
	output bit dataSign);

	assign dataSign = dataIn[31];
	assign dataOut = (dataIn[31]) ? ~dataIn + 1 : dataIn;

endmodule: absoluteValue

module register
	#(parameter w = 32)
	(input bit	[w-1:0]	dataIn,
	 input bit			clk, rst, load,
	 output bit	[w-1:0] dataOut);

	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			dataOut <= 'd0;
		end
		else if (load) begin
			dataOut <= dataIn;
		end
	end

endmodule: register

module priorityRegister
	#(parameter w2 = 9)
	(input bit	[9:-54] dataIn,
	input bit	[w2-1:0] dataIn2,
	input bit	clk, rst, load,
	output bit	[9:-54] dataOut,
	output bit	[w2-1:0] dataOut2);

	bit [9:-54] data;
	bit [w2-1:0] data2;
	assign data = (dataIn > dataOut) ? dataIn : dataOut;
	assign data2 = (dataIn > dataOut) ? dataIn2 : dataOut2;
	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			dataOut <= 'd0;
			dataOut2 <= 'd0;
		end
		else if (load) begin
			/*dataOut = (dataIn > dataOut) ? dataIn : dataOut;*/
			dataOut <= data;
			dataOut2 <= data2;
		end
	end
endmodule: priorityRegister

module registerLog2
	#(parameter w = 10)
	(input bit	[w:-54]	dataIn,
	 input bit			clk, rst, load,
	 output bit	[w:-54] dataOut);

	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			dataOut <= 'd0;
		end
		else if (load) begin
			dataOut <= dataIn;
		end
	end
endmodule: registerLog2
