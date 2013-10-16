module fixedPointTest
		(input bit [31:0] data1, data2,
		output bit [$clog2(32)-1:0] index);
		
		findFirstOne logMaker(data1, index);

endmodule: fixedPointTest

module findFirstOne
	(input bit [31:0] dataIn,
	output bit [$clog2(32)-1:0] index);

	bit [4:0] zeros, zeros1, zeros2, zeros3, zeros4, zeros5;
	bit [31:0] temp2, temp3, temp4, temp5;

	assign index = 'd32 - zeros;
	assign zeros = zeros1 + zeros2 + zeros3 + zeros4 + zeros5;

	always_comb begin
		if (dataIn == 'd0) begin
			zeros1 = 'd32;
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
