module tb();
	logic clk, rst, desc_data_ready;
	bit [31:0] desc_data_in;
	bit [5:-27] descPixelOut [63:0];
	ncc ncc_inst(clk, rst, desc_data_ready, desc_data_in, descPixelOut);

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	initial begin
		$monitor($stime,,"dataIn1=%b, dataIn2=%b, dataIn3=%b, dataIn4=%b, dataOut1=%b, dataOut2=%b, dataOut3=%b, dataOut4=%b", desc_data_in[31:24], desc_data_in[23:16], desc_data_in[15:8], desc_data_in[7:0], descPixelOut[0], descPixelOut[1], descPixelOut[2], descPixelOut[3]);
		desc_data_in <= {8'd1, 8'd2, 8'd4, 8'd5};
		rst <= 1;
		@(posedge clk)
		rst <= 0;
		@(posedge clk)
		desc_data_ready <= 1'b1;
		@(posedge clk)
		desc_data_ready <= 1'b0;
	end
endmodule: tb
