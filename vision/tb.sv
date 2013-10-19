module tb();
	bit [31:0] dataIn;
	bit [4:-27] dataOut;
	log2It dut(dataIn, dataOut);

	initial begin
		$monitor($stime,,"dataIn=%d, dataOut=%b", dataIn, dataOut);
		dataIn = 32'd0;
		#10;
		dataIn = 32'd1;
		#10;
		dataIn = 32'd10;
		#10;
		dataIn = 32'd167;
		#10;
	end
endmodule: tb
