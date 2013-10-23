module tb();
	bit [31:0] dataIn, result;
	bit [4:-27] dataOut;
	log2 dut1(dataIn, dataOut);
	ilog2 dut2(dataOut, result);

	initial begin
		$monitor($stime,,"dataIn=%b, dataOut=%b, result=%b", dataIn, dataOut, result);
		dataIn = 32'd0;
		#10;
		dataIn = 32'd1;
		#10;
		dataIn = 32'd10;
		#10;
		dataIn = 32'd167;
		#10;
		dataIn = 32'd1234134123;
		#10;
	end
endmodule: tb
