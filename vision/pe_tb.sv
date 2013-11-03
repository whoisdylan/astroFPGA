module tb();
	bit[7:0] accOut[15:0];
	bit[7:0] desc[15:0];
	bit[7:0] window[15:0];
	bit[5:-27] descLog[15:0], windowLog[15:0];
	bit[4:-27] dataOut, dataOut2;
	bit[7:0] dataIn, dataIn2;
	bit signOut, signOut2;

	ncc ncc_inst(clk, rst, loadAccSumReg, loadWinReg, descLog, windowLog, accOut);
	log2 log2_inst(dataIn, dataOut, signOut);
	log2 log2_inst2(dataIn2, dataOut2, signOut2);
	
	initial begin
		forever #5 clk = ~clk;
	end
	initial begin
		for (int i = 0; i < 15; i++) begin
			desc[i] = i;
			window[i] = i+'d1;
		end
	end
	// prepare log2'd pixels
	initial begin	
		for (int i = 0; i < 15; i++) begin
			dataIn = desc[i];
			dataIn2 = window[i];
			#5;
			descLog[i][4:-27] = dataOut;
			descLog[i][5] = signOut;
			windowLog[i][4:-27] = dataOut2;
			windowLog[i][5] = signOut2;
		end
	end
	initial begin
		$monitor($stime,,"a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15", accOut[0], accOut[1], accOut[2], accOut[3], accOut[4], accOut[5], accOut[6], accOut[7], accOut[8], accOut[9], accOut[10], accOut[11], accOut[12], accOut[13], accOut[14], accOut[15]);
		rst <= 0;
		loadAccSumReg <= 0;
		loadWinReg <= 0;
		@(posedge clk)
			loadWinReg <= 1;
		@(posedge clk)
			loadWinReg <= 0;
			loadAccSumReg <= 1;
		@(posedge clk)
			loadAccSumReg <= 0;
	end
endmodule: tb
