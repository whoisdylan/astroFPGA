module ncc
	#(parameter descSize = 2048,
	 parameter numPixelsDesc = 256,
	 parameter windowSize = 640,
	 parameter );
	(input logic clk, rst,
	 input bit [7:0] pciIn,
	output logic iWishIKnew);

	enum logic {WAIT, LOAD_DESC} currStateDesc, nextStateDesc;
	logic loadDesc, currStateDesc, nextStateDesc, enDescCounter, shiftDescReg, doneLoadingDesc;
	logic winWriteA, winWriteB;
	bit [descSize-1:0] descriptor;
	bit [$clog2(descSize)-1:0] descCount;

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
	generate
		for (i='d0; i<'d16; i++) begin
			bram_tdbp #(8, 10) windowRowBram(.a_clk(clk), .a_wr(winWriteA),
				.a_ddr(winAddrA[i]), .a_din(winDataInA[i]), .a_dout(winDataOutA[i]), .b_clk(clk),
				.b_wr(winWriteB), .b_addr(winAddrB[i]), .b_din(winDataInB[i]),
				.b_dout(winDataOutB[i]));
		end
	endgenerate

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
					nextStateDesc = WAIT
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
