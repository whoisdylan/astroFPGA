module fixedPointTest
		(input bit [31:0] data1, data2,
		output bit [$clog2(32)-1:0] index);
		
		findFirstOne logMaker(data1, index);

endmodule: fixedPointTest

module findFirstOne
	(input bit [31:0] dataIn,
	output bit [$clog2(32)-1:0] index);

	bit [31:0] zeros;
	bit [31:0] temp;

	assign index = 'd32 - 'd1 - zeros;

	always_comb begin
		temp  = dataIn;
		if (temp == 'd0) begin
			zeros = 'd31;
		end
		else begin
			if (temp <= 'hffff) begin
				zeros = zeros + 'd16;
				temp = temp << 'd16;
			end
			if (temp <= 'hffffff) begin
				zeros = zeros + 'd8;
				temp = temp << 'd8;
			end
			if (temp <= 'hfffffff) begin
				zeros = zeros + 'd4;
				temp = temp << 'd4;
			end
			if (temp <= 'h3fffffff) begin
				zeros = zeros + 'd2;
				temp = temp << 'd2;
			end
			if (temp <= 'h7fffffff) begin
				zeros = zeros + 'd1;
			end
		end
	end
endmodule: findFirstOne

module tb();
	
	bit [4:-27] data1, data2;
	bit [$clog2(32)-1:0] index;
	fixedPointTest dut(data1, data2, index);
	initial begin
		$monitor($stime,,"data1=%b , index=%d", data1, index);
		data1 = 32'b0;
		#10;
		data1 = {31'b0, 1'b1};
		#10;
		data1 = {30'b0, 2'b10};
		#10;
		data1 = {29'b0, 3'b100};
		#10;
		data1 = {28'b0, 4'b1000};
		#10;
		data1 = {27'b0, 5'b10000};
		#10;
	end
endmodule: tb
