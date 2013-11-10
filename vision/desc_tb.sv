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
		$monitor($stime,,"dataIn1=%b, dataIn2=%b, dataIn3=%b, dataIn4=%b\n, dataOut1=%b, dataOut2=%b, dataOut3=%b, dataOut4=%b, dataOut5=%b, dataOut6=%b, dataOut7=%b, dataOut8=%b\n, dataOut9=%b, dataOut10=%b, dataOut11=%b, dataOut12=%b, dataOut13=%b, dataOut14=%b, dataOut15=%b, dataOut16=%b\n, dataOut17=%b, dataOut18=%b, dataOut19=%b, dataOut20=%b, dataOut21=%b, dataOut22=%b, dataOut23=%b, dataOut24=%b\n, dataOut25=%b, dataOut26=%b, dataOut27=%b, dataOut28=%b, dataOut29=%b, dataOut30=%b, dataOut31=%b, dataOut32=%b\n, dataOut33=%b, dataOut34=%b, dataOut35=%b, dataOut36=%b, dataOut37=%b, dataOut38=%b, dataOut39=%b, dataOut40=%b\n, dataOut41=%b, dataOut42=%b, dataOut43=%b, dataOut44=%b, dataOut45=%b, dataOut46=%b, dataOut47=%b, dataOut48=%b\n, dataOut49=%b, dataOut50=%b, dataOut51=%b, dataOut52=%b, dataOut53=%b, dataOut54=%b, dataOut55=%b, dataOut56=%b\n, dataOut57=%b, dataOut58=%b, dataOut59=%b, dataOut60=%b, dataOut61=%b, dataOut62=%b, dataOut63=%b, dataOut64=%b\n, descRowCount=%d", desc_data_in[31:24], desc_data_in[23:16], desc_data_in[15:8], desc_data_in[7:0], descPixelOut[0], descPixelOut[1], descPixelOut[2], descPixelOut[3], descPixelOut[4], descPixelOut[5], descPixelOut[6], descPixelOut[7], descPixelOut[8], descPixelOut[9], descPixelOut[10], descPixelOut[11], descPixelOut[12], descPixelOut[13], descPixelOut[14], descPixelOut[15], descPixelOut[16], descPixelOut[17], descPixelOut[18], descPixelOut[19], descPixelOut[20], descPixelOut[21], descPixelOut[22], descPixelOut[23], descPixelOut[24], descPixelOut[25], descPixelOut[26], descPixelOut[27], descPixelOut[28], descPixelOut[29], descPixelOut[30], descPixelOut[31], descPixelOut[32], descPixelOut[33], descPixelOut[34], descPixelOut[35], descPixelOut[36], descPixelOut[37], descPixelOut[38], descPixelOut[39], descPixelOut[40], descPixelOut[41], descPixelOut[42], descPixelOut[43], descPixelOut[44], descPixelOut[45], descPixelOut[46], descPixelOut[47], descPixelOut[48], descPixelOut[49], descPixelOut[50], descPixelOut[51], descPixelOut[52], descPixelOut[53], descPixelOut[54], descPixelOut[55], descPixelOut[56], descPixelOut[57], descPixelOut[58], descPixelOut[59], descPixelOut[60], descPixelOut[61], descPixelOut[62], descPixelOut[63], ncc_inst.descRowC);
		desc_data_in <= {8'd1, 8'd2, 8'd4, 8'd5};
		rst <= 1;
		@(posedge clk)
		rst <= 0;
		@(posedge clk)
		desc_data_ready <= 1'b1;
		@(posedge clk)
		desc_data_ready <= 1'b0;
		desc_data_in <= {8'd8, 8'd16, 8'd32, 8'd64};
		@(posedge clk)
		desc_data_ready <= 1'b1;
		@(posedge clk)
		desc_data_ready <= 1'b0;
		@(posedge clk)
		desc_data_ready <= 1'b1;
		@(posedge clk)
		desc_data_ready <= 1'b0;
		@(posedge clk)
		desc_data_ready <= 1'b1;
		@(posedge clk)
		desc_data_ready <= 1'b0;
		@(posedge clk)
		desc_data_ready <= 1'b1;
		@(posedge clk)
		desc_data_ready <= 1'b0;
		@(posedge clk)
		$finish;
	end
endmodule: tb
