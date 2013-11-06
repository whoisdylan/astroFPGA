module ncc
	#(parameter descSize = 2048,
	 parameter numPixelsDesc = 256,
	 parameter windowSize = 640)
	(input logic clk, rst, loadAccSumReg, loadWinReg,
	input bit[5:-27] desc[15:0], windowIn,
	output bit[7:0] accOut[15:0]);

	enum logic {DESC_WAIT, DESC_LOAD} currStateDesc, nextStateDesc;
	logic winWriteA, winWriteB;

	// create PE array
	/*bit [7:0][15:0][15:0] accIn, accOut;*/

	/*genvar i, j;*/
	/*generate*/
	/*	for (i='d0; i < 'd16; i++) begin*/
	/*		for (j='d0; j < 'd16; j++) begin*/
	/*			if (j == 0) begin*/
	/*				processingElement(desc[i][4:-27], windowRows[i], desc[i][5], clk, rst, loadWinRegs, loadAccSumRegs, 'd0, accIn[i+1], window[i-1],*/
	/*			end*/
	/*			else if (i == 'd15) begin*/
	/*				processingElement(desc[i][4:-27], window[i], desc[i][5], clk, rst, loadWinRegs, loadAccSumRegs, accIn[i], , window[i-1],*/
	/*			end*/
	/*			else if (i%*/
	/*			else begin*/
	/*				processingElement(desc[i][4:-27], window[i], desc[i][5], clk, rst, loadWinRegs, loadAccSumRegs, accIn[i], accIn[i+1], window[i-1],*/
	/*			end*/
	/*		end*/
	/*	end*/
	/*endgenerate*/

	genvar i;
	generate
		for (i='d0; i < 'd16; i++) begin
			if (i == 'd0) begin
				processingElement PE_inst(.clk, .rst, .descPixel(desc[i][4:-27]), .windowPixelIn(windowIn), .descSignBit(desc[i][5]), .loadWinReg, .loadAccSumReg, .accIn('d0), .accOut(accOut[i]), .windowPixelOut(window[i]));
			end
			else if (i == 'd15) begin
				processingElement PE_inst(.clk, .rst, .descPixel(desc[i][4:-27]), .windowPixelIn(window[i-1]), .descSignBit(desc[i][5]), .loadWinReg, .loadAccSumReg, .accIn(accOut[i-1]), .accOut(accOut[i]));
			end
			else begin
				processingElement PE_inst(.clk, .rst, .descPixel(desc[i][4:-27]), .windowPixelIn(window[i-1]), .descSignBit(desc[i][5]), .loadWinReg, .loadAccSumReg, .accIn(accOut[i-1]), .accOut(accOut[i]), .windowPixelOut(window[i]));
			end
		end
	endgenerate

	//descriptor loading datapath hardware
	logic enDescRowC, enDescColC, loadDescGroup1, loadDescGroup2, loadDescGroup3, loadDescGroup4;
	bit [3:0] descRowC;
	bit [1:0] descColC;
	counter #(4) descRowCounter(clk, rst, enDescRowC, descRowC);
	counter #(2) descColCounter(clk, rst, enDescColC, descColC);

	log2 descLog2_inst1({24'd0, desc_data_in[31:24]}, descLog2_1);
	log2 descLog2_inst2({24'd0, desc_data_in[23:16]}, descLog2_2);
	log2 descLog2_inst3({24'd0, desc_data_in[15:8]}, descLog2_3);
	log2 descLog2_inst4({24'd0, desc_data_in[7:0]}, descLog2_4);

	decoder #(4) desc_decoder(descColC, {load1, load2, load3, load4});
	decoder #(16) desc_row_decoder_1(descRowC,
	mux #(2) desc_mux_1({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_2({load2, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_3({load3, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_4({load4, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_5({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_6({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_7({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_8({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_9({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_10({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_11({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_12({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_13({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_14({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_15({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_16({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_17({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_18({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_19({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_20({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_21({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_22({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_23({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_24({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_25({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_26({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_27({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_28({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_29({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_30({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_31({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_32({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_33({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_34({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_35({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_36({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_37({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_38({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_39({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_40({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_41({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_42({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_43({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_44({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_45({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_46({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_47({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_48({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_49({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_50({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_51({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_52({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_53({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_54({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_55({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_56({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_57({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_58({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_59({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_60({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_61({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_62({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_63({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
	mux #(2) desc_mux_64({load1, 1'b0}, descRowC == 4'd0, loadDescGroup1);
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

module mux
	#(parameter w = 4)
	(input bit [w-1:0] in,
	input bit [$clog2(w)-1:0] sel,
	output bit out)
	
	assign out = in[sel];

endmodule: mux

module demux
	#(parameter w = 4)
	(input bit in,
	input bit [$clog2(w)-1:0] sel,
	output bit [w-1:-] out)

	assign out[sel] = in;

endmodule: demux

module decoder
	#(parameter w = 4)
	(input bit [$clog2(w)-1:0] sel,
	output bit [w-1:0] out)

	always_comb begin
		out = 'd0;
		out[sel] = 1'b1;
	end

endmodule: decoder

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
	(input bit	[5:-27]	descPixel,
	 input bit	[5:-27]	windowPixelIn,
	 input bit			clk, rst, loadWinReg, loadAccSumReg,
	 input bit	[7:0]	accIn,
	 output bit	[7:0]	accOut,
	 output bit	[5:-27] windowPixelOut);
	
	bit [4:-27] tempSumLog2, accSumLog2;
	bit [31:0] tempSum;
	bit descSignBit;
	assign descSignBit = descPixel[5];

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
	assign signBit = dataIn[31];

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
