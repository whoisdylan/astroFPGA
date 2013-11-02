module ncc
	#(parameter descSize = 2048,
	 parameter numPixelsDesc = 256,
	 parameter windowSize = 640)
	(input logic clk, rst,
	 input bit [7:0] pciIn,
	output logic iWishIKnew);

	enum logic {WAIT, LOAD_DESC} currStateDesc, nextStateDesc;
	logic loadDesc, enDescCounter, shiftDescReg, doneLoadingDesc, startLoadingDesc;
	logic winWriteA, winWriteB;
	bit [descSize-1:0] descriptor;
	bit [$clog2(numPixelsDesc)-1:0] descCount;

	assign enDescCounter = shiftDescReg || loadDesc;
	assign doneLoadingDesc = descCount == numPixelsDesc;

	bit [7:0][15:0] winDataInA, winDataInB, winDataOutA, winDataOutB;
	bit [9:0][15:0] winAddrA, winAddrB;
	/*bit [9:0] winAddrA1, winAddrA2, winAddrA3, winAddrA4, winAddrA5, winAddrA6,*/
	/*		  winAddrA7, winAddrA8, winAddrA9, winAddrA10, winAddrA11,*/
	/*		  winAddrA12, winAddrA13, winAddrA14, winAddrA15, winAddrA16;*/
	/*bit [9:0] winAddrB1, winAddrB2, winAddrB3, winAddrB4, winAddrB5, winAddrB6,*/
	/*		  winAddrB7, winAddrB8, winAddrB9, winAddrB10, winAddrB11,*/
	/*		  winAddrB12, winAddrB13, winAddrB14, winAddrB15, winAddrB16;*/


	/*assign winAddrA[0] = winAddrA1;*/
	/*assign winAddrA[1] = winAddrA2;*/
	/*assign winAddrA[2] = winAddrA3;*/
	/*assign winAddrA[3] = winAddrA4;*/
	/*assign winAddrA[4] = winAddrA5;*/
	/*assign winAddrA[5] = winAddrA6;*/
	/*assign winAddrA[6] = winAddrA7;*/
	/*assign winAddrA[7] = winAddrA8;*/
	/*assign winAddrA[8] = winAddrA9;*/
	/*assign winAddrA[9] = winAddrA10;*/
	/*assign winAddrA[10] = winAddrA11;*/
	/*assign winAddrA[11] = winAddrA12;*/
	/*assign winAddrA[12] = winAddrA13;*/
	/*assign winAddrA[13] = winAddrA14;*/
	/*assign winAddrA[14] = winAddrA15;*/
	/*assign winAddrA[15] = winAddrA16;*/

	/*assign winAddrB[0] = winAddrB1;*/
	/*assign winAddrB[1] = winAddrB2;*/
	/*assign winAddrB[2] = winAddrB3;*/
	/*assign winAddrB[3] = winAddrB4;*/
	/*assign winAddrB[4] = winAddrB5;*/
	/*assign winAddrB[5] = winAddrB6;*/
	/*assign winAddrB[6] = winAddrB7;*/
	/*assign winAddrB[7] = winAddrB8;*/
	/*assign winAddrB[8] = winAddrB9;*/
	/*assign winAddrB[9] = winAddrB10;*/
	/*assign winAddrB[10] = winAddrB11;*/
	/*assign winAddrB[11] = winAddrB12;*/
	/*assign winAddrB[12] = winAddrB13;*/
	/*assign winAddrB[13] = winAddrB14;*/
	/*assign winAddrB[14] = winAddrB15;*/
	/*assign winAddrB[15] = winAddrB16;*/

	//counter for loading descriptor
	counter #(numPixelsDesc) descCounter(.clk(clk), .rst(rst), .enable(enDescCounter),
									.count(descCount));
	//descriptor register
	shiftRegister #(descSize) descReg(.clk(clk), .rst(rst), .load(loadDescReg), 
									  .shift(shiftDescReg), .in(pciIn), .out(descriptor));
	//bram for window, one per row = 16 brams, 80 pixels per bram
	/*genvar i;
	generate
		for (i='d0; i<'d16; i++) begin
			bram_tdbp #(8, 10) windowRowBram(.a_clk(clk), .a_wr(winWriteA),
				.a_ddr(winAddrA[i]), .a_din(winDataInA[i]), .a_dout(winDataOutA[i]), .b_clk(clk),
				.b_wr(winWriteB), .b_addr(winAddrB[i]), .b_din(winDataInB[i]),
				.b_dout(winDataOutB[i]));
		end
	endgenerate */

	//descriptor shift register fsm
	always_comb begin
		loadDesc = 1'd0;
		shiftDescReg = 1'd0;
		case (currStateDesc)
			WAIT: begin
				if (startLoadingDesc) begin
					loadDesc = 1'd1;
					enDescCounter = 1'd1;
					nextStateDesc = LOAD_DESC;
				end
				else begin
					nextStateDesc = WAIT;
				end
			end
			LOAD_DESC: begin
				if (doneLoadingDesc) begin
					nextStateDesc = WAIT;
				end
				else begin
					shiftDescReg = 1'd1;
					nextStateDesc = LOAD_DESC;
				end
			end
		endcase
	end

	//state register
	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			currStateDesc <= WAIT;
		end
		else begin
			currStateDesc <= nextStateDesc;
		end
	end

endmodule: ncc

module shiftRegister
	#(parameter w = 2048)
	 (input logic clk, rst, load, shift,
	  input bit [7:0] in,
	 output bit [w-1:0] out);

	 bit [w-1:0] val;
	 assign out = val;

	 always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			val <= 'd0;
		end
		else if (load) begin
			val[7:0] <= in;
		end
		else if (shift) begin
			val <= val << 'd8;
		end
	end
endmodule: shiftRegister

module counter
	#(parameter w = 256)
	(input logic clk, rst, enable,
	output bit [$clog2(w)-1:0] count);

	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			count <= 'd0;
		end
		else if (enable) begin
			count <= count + 'd1;
		end
	end
endmodule: counter

module processingElement
	(input bit	[4:-27]	descPixel,
	 input bit	[5:-27]	windowPixelIn,
	 input bit			descSignBit,
	 input bit			clk, rst, loadWinReg, loadAccSumReg,
	 input bit	[7:0]	accIn,
	 output bit	[7:0]	accOut,
	 output bit	[5:-27] windowPixelOut);
	
	bit [4:-27] tempSumLog2, accSumLog2;
	bit [31:0] tempSum;

	ilog2 ilog2_inst (tempSumLog2, tempSum);

	//register for storing "LTC"
	registerLog2 #(5) windowReg (windowPixelIn, clk, rst, loadWinReg, windowPixelOut);
	//register for "ACCin + ltc*f
	register #(8) accReg (accSum, clk, rst, loadAccSumReg, accOut);

	assign tempSumLog2 = descPixel + windowPixelOut[4:-27];
	assign accSum = (descSignBit ^ windowPixelOut[5]) ?
					(accIn - tempSum[7:0]) : (accIn + tempSum[7:0]);

endmodule: processingElement

module log2
	(input bit [31:0] dataIn,
	output bit [4:-27] dataOut,
	output bit		   signBit);

	bit [31:0] fraction;

	bit [4:0] oneIndex;
	findFirstOne #(32) firstOneFinder(dataIn, oneIndex);
	
	assign fraction = dataIn << (32-oneIndex);
	assign dataOut = {oneIndex, fraction[31:5]};
	assign signBit = dataIn[w-1];

endmodule: log2

module ilog2
	(input bit [4:-27] dataIn,
	output bit [31:0] dataOut);
	bit [4:0] oneIndex;
	always_comb begin
		dataOut = 32'd1 << dataIn[4:0];
		unique case (dataIn[4:0])
			5'd0: begin
			end
			5'd1: begin
				dataOut[0] = dataIn[-1];
			end
			5'd2: begin
				dataOut[1:0] = dataIn[-1:-2];
			end
			5'd3: begin
				dataOut[2:0] = dataIn[-1:-3];
			end
			5'd4: begin
				dataOut[3:0] = dataIn[-1:-4];
			end
			5'd5: begin
				dataOut[4:0] = dataIn[-1:-5];
			end
			5'd6: begin
				dataOut[5:0] = dataIn[-1:-6];
			end
			5'd7: begin
				dataOut[6:0] = dataIn[-1:-7];
			end
			5'd8: begin
				dataOut[7:0] = dataIn[-1:-8];
			end
			5'd9: begin
				dataOut[8:0] = dataIn[-1:-9];
			end
			5'd10: begin
				dataOut[9:0] = dataIn[-1:-10];
			end
			5'd11: begin
				dataOut[10:0] = dataIn[-1:-11];
			end
			5'd12: begin
				dataOut[11:0] = dataIn[-1:-12];
			end
			5'd13: begin
				dataOut[12:0] = dataIn[-1:-13];
			end
			5'd14: begin
				dataOut[13:0] = dataIn[-1:-14];
			end
			5'd15: begin
				dataOut[14:0] = dataIn[-1:-15];
			end
			5'd16: begin
				dataOut[15:0] = dataIn[-1:-16];
			end
			5'd17: begin
				dataOut[16:0] = dataIn[-1:-17];
			end
			5'd18: begin
				dataOut[17:0] = dataIn[-1:-18];
			end
			5'd19: begin
				dataOut[18:0] = dataIn[-1:-19];
			end
			5'd20: begin
				dataOut[19:0] = dataIn[-1:-20];
			end
			5'd21: begin
				dataOut[20:0] = dataIn[-1:-21];
			end
			5'd22: begin
				dataOut[21:0] = dataIn[-1:-22];
			end
			5'd23: begin
				dataOut[22:0] = dataIn[-1:-23];
			end
			5'd24: begin
				dataOut[23:0] = dataIn[-1:-24];
			end
			5'd25: begin
				dataOut[24:0] = dataIn[-1:-25];
			end
			5'd26: begin
				dataOut[25:0] = dataIn[-1:-26];
			end
			5'd27: begin
				dataOut[26:0] = dataIn[-1:-27];
			end
			5'd28: begin
				dataOut[27:0] = {dataIn[-1:-27], 1'd0};
			end
			5'd29: begin
				dataOut[28:0] = {dataIn[-1:-27], 2'd0};
			end
			5'd30: begin
				dataOut[29:0] = {dataIn[-1:-27], 3'd0};
			end
			5'd31: begin
				dataOut[30:0] = {dataIn[-1:-27], 4'd0};
			end
		endcase
	end
endmodule: ilog2

/*module ilog2*/
/*	(input bit [4:-27] dataIn,*/
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
			dataOut = 'd0;
		end
		else if (load) begin
			dataOut = dataIn;
		end
	end

endmodule: register

module registerLog2
	#(parameter w = 5)
	(input bit	[w:-27]	dataIn,
	 input bit			clk, rst, load,
	 output bit	[w:-27] dataOut);

	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			dataOut = 'd0;
		end
		else if (load) begin
			dataOut = dataIn;
		end
	end

endmodule: registerLog2
