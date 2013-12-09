//testbench for ilog2_negatives module
module tb();
	bit signed [31:-32] result;
	bit [10:-54] dataIn;
	ilog2_negatives dut2(dataIn, result);

	initial begin
		$monitor($stime,,"**********\ndataIn=%b.%b\nresult=%d.%b", dataIn[10:0], dataIn[-1:-54], result[31:0], result[-1:-32]);
		dataIn = {11'b11111111101,3'b101,51'd0};
		#10;
	end
endmodule: tb
