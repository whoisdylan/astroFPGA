module myTreeAdderTB;
    logic clk;
    logic rst_n;
    logic enable;
    logic signed [31:0] operand[16][16];
    logic signed [31:0] sum_result;
    logic dataReady;


    tree_adder  #(32) ta (.*);

    initial begin
	    clk = 0;
	    rst_n = 1;
	    forever	#5 clk = ~clk;
    end

    int count, i, j;
    initial begin

        $monitor("sum_result=%d dataReady=%d sum_0=%d sum_1=%d sum_2=%d sum_3=%d sum_4=%d sum_5=%d sum_6=%d sum_7=%d en=%d en0=%d en1=%d en2=%d en3=%d en4=%d en5=%d en6=%d en7=%d", sum_result, dataReady, ta.sum_0_in[4],
        ta.sum_1_in[4], ta.sum_2_in[4], ta.sum_3_in[4], ta.sum_4_in[4], ta.sum_5_in[1],
        ta.sum_6_in[1], ta.sum_7_in[1], ta.enable, enable, ta.en0, ta.en1, ta.en2,
        ta.en3, ta.en4, ta.en5, ta.en6, ta.en7);

	    rst_n = 0;
        enable = 0;

        @(posedge clk);

        rst_n <= 1;
        enable <= 1;

        count = 0;
        for (i = 0; i < 16; i++) begin
            for (j = 0; j < 16; j++) begin
                operand[i][j] = count;
                count = count+1;
            end
        end
        $display("%d", operand[8][8]);


        @(posedge clk);
        enable <= 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);


	    $finish;
    end
endmodule: myTreeAdderTB

/*module processingElementTB;
    bit             clk;
    bit             rst;

    //signals for numeratorDescriptor
    bit             numDesc_en;
    bit [35:0]      desc_data_in;
    bit [10:-54]    desc_array_out [15:0] [15:0];

    numeratorDescriptor  nd(.en(numDesc_en), .*);

    //signals for numeratorWindow
    bit             numWin_en;
    bit [8:0]       window_data_in [15:0] [15:0];
    bit [10:-54]    window_data_out [15:0] [15:0];
    bit             en_out;

    numeratorWindow nw(.en(numWin_en), .*);

    // signals for numeratorTop
    bit             numTop_en;
    bit [10:-54]    numTop_window_data_in [15:0][15:0];
    bit [10:-54]    numTop_desc_data_in [15:0][15:0];
    bit             numTop_en_out;
    bit [31:0]      numTop_windowPixelOut [15:0] [15:0];
    bit [31:0]      numTop_descPixelOut [15:0] [15:0];
    bit [10:-54]    numTop_descPixelLog2 [15:0] [15:0];
    bit [10:-54]    numTop_windowPixelLog2 [15:0] [15:0];
    bit [31:0]      accOut [15:0][15:0];

    numeratorTop dut(.en(en_out), .window_data_in(window_data_out),
                .desc_data_in(desc_array_out), .en_out(numTop_en_out),
                .windowPixelOut(numTop_windowPixelOut), .descPixelOut(numTop_descPixelOut),
                .descPixelLog2(numTop_descPixelLog2),
                .windowPixelLog2(numTop_windowPixelLog2), .*);


    initial begin
	    clk = 0;
	    rst = 1;
        numDesc_en = 0;
        numWin_en = 0;
        numTop_en = 0;
	    forever	#5 clk = ~clk;

    end

    bit [8:0] count = 0;
    int i,j;
    initial begin
	    $monitor($time, , "%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n\n", accOut[0][0], accOut[0][1], accOut[0][2], accOut[0][3], accOut[0][4], accOut[0][5], accOut[0][6], accOut[0][7], accOut[0][8], accOut[0][9], accOut[0][10], accOut[0][11], accOut[0][12], accOut[0][13], accOut[0][14], accOut[0][15], accOut[1][0], accOut[1][1], accOut[1][2], accOut[1][3], accOut[1][4], accOut[1][5], accOut[1][6], accOut[1][7], accOut[1][8], accOut[1][9], accOut[1][10], accOut[1][11], accOut[1][12], accOut[1][13], accOut[1][14], accOut[1][15], accOut[2][0], accOut[2][1], accOut[2][2], accOut[2][3], accOut[2][4], accOut[2][5], accOut[2][6], accOut[2][7], accOut[2][8], accOut[2][9], accOut[2][10], accOut[2][11], accOut[2][12], accOut[2][13], accOut[2][14], accOut[2][15], accOut[3][0], accOut[3][1], accOut[3][2], accOut[3][3], accOut[3][4], accOut[3][5], accOut[3][6], accOut[3][7], accOut[3][8], accOut[3][9], accOut[3][10], accOut[3][11], accOut[3][12], accOut[3][13], accOut[3][14], accOut[3][15], accOut[4][0], accOut[4][1], accOut[4][2], accOut[4][3], accOut[4][4], accOut[4][5], accOut[4][6], accOut[4][7], accOut[4][8], accOut[4][9], accOut[4][10], accOut[4][11], accOut[4][12], accOut[4][13], accOut[4][14], accOut[4][15], accOut[5][0], accOut[5][1], accOut[5][2], accOut[5][3], accOut[5][4], accOut[5][5], accOut[5][6], accOut[5][7], accOut[5][8], accOut[5][9], accOut[5][10], accOut[5][11], accOut[5][12], accOut[5][13], accOut[5][14], accOut[5][15], accOut[6][0], accOut[6][1], accOut[6][2], accOut[6][3], accOut[6][4], accOut[6][5], accOut[6][6], accOut[6][7], accOut[6][8], accOut[6][9], accOut[6][10], accOut[6][11], accOut[6][12], accOut[6][13], accOut[6][14], accOut[6][15], accOut[7][0], accOut[7][1], accOut[7][2], accOut[7][3], accOut[7][4], accOut[7][5], accOut[7][6], accOut[7][7], accOut[7][8], accOut[7][9], accOut[7][10], accOut[7][11], accOut[7][12], accOut[7][13], accOut[7][14], accOut[7][15], accOut[8][0], accOut[8][1], accOut[8][2], accOut[8][3], accOut[8][4], accOut[8][5], accOut[8][6], accOut[8][7], accOut[8][8], accOut[8][9], accOut[8][10], accOut[8][11], accOut[8][12], accOut[8][13], accOut[8][14], accOut[8][15], accOut[9][0], accOut[9][1], accOut[9][2], accOut[9][3], accOut[9][4], accOut[9][5], accOut[9][6], accOut[9][7], accOut[9][8], accOut[9][9], accOut[9][10], accOut[9][11], accOut[9][12], accOut[9][13], accOut[9][14], accOut[9][15], accOut[10][0], accOut[10][1], accOut[10][2], accOut[10][3], accOut[10][4], accOut[10][5], accOut[10][6], accOut[10][7], accOut[10][8], accOut[10][9], accOut[10][10], accOut[10][11], accOut[10][12], accOut[10][13], accOut[10][14], accOut[10][15], accOut[11][0], accOut[11][1], accOut[11][2], accOut[11][3], accOut[11][4], accOut[11][5], accOut[11][6], accOut[11][7], accOut[11][8], accOut[11][9], accOut[11][10], accOut[11][11], accOut[11][12], accOut[11][13], accOut[11][14], accOut[11][15], accOut[12][0], accOut[12][1], accOut[12][2], accOut[12][3], accOut[12][4], accOut[12][5], accOut[12][6], accOut[12][7], accOut[12][8], accOut[12][9], accOut[12][10], accOut[12][11], accOut[12][12], accOut[12][13], accOut[12][14], accOut[12][15], accOut[13][0], accOut[13][1], accOut[13][2], accOut[13][3], accOut[13][4], accOut[13][5], accOut[13][6], accOut[13][7], accOut[13][8], accOut[13][9], accOut[13][10], accOut[13][11], accOut[13][12], accOut[13][13], accOut[13][14], accOut[13][15], accOut[14][0], accOut[14][1], accOut[14][2], accOut[14][3], accOut[14][4], accOut[14][5], accOut[14][6], accOut[14][7], accOut[14][8], accOut[14][9], accOut[14][10], accOut[14][11], accOut[14][12], accOut[14][13], accOut[14][14], accOut[14][15], accOut[15][0], accOut[15][1], accOut[15][2], accOut[15][3], accOut[15][4], accOut[15][5], accOut[15][6], accOut[15][7], accOut[15][8], accOut[15][9], accOut[15][10], accOut[15][11], accOut[15][12], accOut[15][13], accOut[15][14], accOut[15][15]);


	    rst = 0;
        numDesc_en = 1;

        for (i = 0; i < 256; i++) begin
                desc_data_in = {count, count+4'd1, count+4'd2, count+4'd3};
                count = count+4;
                @(posedge clk);
	    end
        numDesc_en = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);

        numWin_en = 1;

        for (i = 0; i < 16; i++) begin
            for (j = 0; j < 16; j++) begin
                window_data_in[i][j] = count;
                count = count+1;
            end
        end

        numWin_en = 1;
        @(posedge clk);
        @(posedge clk);

        numWin_en = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);

	    $finish;
    end
endmodule: processingElementTB*/







/*module numeratorWindowTB;

    bit en;
    bit clk;
    bit rst;
    bit [8:0]      window_data_in [15:0] [15:0];
    bit [10:-54]    d  [15:0] [15:0];
    bit [31:0]      dataOut [15:0] [15:0];

    numeratorWindow dut(.window_data_out(d), .*);

	genvar k,l;
	generate
		for ( k= 0; k < 16; k++) begin
			for (l = 0; l < 16; l++) begin
				ilog2 ilog2_inst(.dataIn(d[k][l][9:-54]),
                .dataOut(dataOut[k][l]));
			end
		end
	endgenerate


    int i,j;


    initial begin

	    clk = 0;
	    rst = 1;
        en = 0;
	    forever	#5 clk = ~clk;

    end

    initial begin
        bit [8:0] count = 0;

        @(posedge clk);

	    rst = 0;
        en = 1;


        for (i = 0; i < 16; i++) begin
            for (j = 0; j < 16; j++) begin
                window_data_in[i][j] = count;
                count = count+1;
            end
        end

        @(posedge clk);
        @(posedge clk);


	    $display($time, , "count=%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n\n", count, dataOut[0][0], dataOut[0][1], dataOut[0][2], dataOut[0][3], dataOut[0][4], dataOut[0][5], dataOut[0][6], dataOut[0][7], dataOut[0][8], dataOut[0][9], dataOut[0][10], dataOut[0][11], dataOut[0][12], dataOut[0][13], dataOut[0][14], dataOut[0][15], dataOut[1][0], dataOut[1][1], dataOut[1][2], dataOut[1][3], dataOut[1][4], dataOut[1][5], dataOut[1][6], dataOut[1][7], dataOut[1][8], dataOut[1][9], dataOut[1][10], dataOut[1][11], dataOut[1][12], dataOut[1][13], dataOut[1][14], dataOut[1][15], dataOut[2][0], dataOut[2][1], dataOut[2][2], dataOut[2][3], dataOut[2][4], dataOut[2][5], dataOut[2][6], dataOut[2][7], dataOut[2][8], dataOut[2][9], dataOut[2][10], dataOut[2][11], dataOut[2][12], dataOut[2][13], dataOut[2][14], dataOut[2][15], dataOut[3][0], dataOut[3][1], dataOut[3][2], dataOut[3][3], dataOut[3][4], dataOut[3][5], dataOut[3][6], dataOut[3][7], dataOut[3][8], dataOut[3][9], dataOut[3][10], dataOut[3][11], dataOut[3][12], dataOut[3][13], dataOut[3][14], dataOut[3][15], dataOut[4][0], dataOut[4][1], dataOut[4][2], dataOut[4][3], dataOut[4][4], dataOut[4][5], dataOut[4][6], dataOut[4][7], dataOut[4][8], dataOut[4][9], dataOut[4][10], dataOut[4][11], dataOut[4][12], dataOut[4][13], dataOut[4][14], dataOut[4][15], dataOut[5][0], dataOut[5][1], dataOut[5][2], dataOut[5][3], dataOut[5][4], dataOut[5][5], dataOut[5][6], dataOut[5][7], dataOut[5][8], dataOut[5][9], dataOut[5][10], dataOut[5][11], dataOut[5][12], dataOut[5][13], dataOut[5][14], dataOut[5][15], dataOut[6][0], dataOut[6][1], dataOut[6][2], dataOut[6][3], dataOut[6][4], dataOut[6][5], dataOut[6][6], dataOut[6][7], dataOut[6][8], dataOut[6][9], dataOut[6][10], dataOut[6][11], dataOut[6][12], dataOut[6][13], dataOut[6][14], dataOut[6][15], dataOut[7][0], dataOut[7][1], dataOut[7][2], dataOut[7][3], dataOut[7][4], dataOut[7][5], dataOut[7][6], dataOut[7][7], dataOut[7][8], dataOut[7][9], dataOut[7][10], dataOut[7][11], dataOut[7][12], dataOut[7][13], dataOut[7][14], dataOut[7][15], dataOut[8][0], dataOut[8][1], dataOut[8][2], dataOut[8][3], dataOut[8][4], dataOut[8][5], dataOut[8][6], dataOut[8][7], dataOut[8][8], dataOut[8][9], dataOut[8][10], dataOut[8][11], dataOut[8][12], dataOut[8][13], dataOut[8][14], dataOut[8][15], dataOut[9][0], dataOut[9][1], dataOut[9][2], dataOut[9][3], dataOut[9][4], dataOut[9][5], dataOut[9][6], dataOut[9][7], dataOut[9][8], dataOut[9][9], dataOut[9][10], dataOut[9][11], dataOut[9][12], dataOut[9][13], dataOut[9][14], dataOut[9][15], dataOut[10][0], dataOut[10][1], dataOut[10][2], dataOut[10][3], dataOut[10][4], dataOut[10][5], dataOut[10][6], dataOut[10][7], dataOut[10][8], dataOut[10][9], dataOut[10][10], dataOut[10][11], dataOut[10][12], dataOut[10][13], dataOut[10][14], dataOut[10][15], dataOut[11][0], dataOut[11][1], dataOut[11][2], dataOut[11][3], dataOut[11][4], dataOut[11][5], dataOut[11][6], dataOut[11][7], dataOut[11][8], dataOut[11][9], dataOut[11][10], dataOut[11][11], dataOut[11][12], dataOut[11][13], dataOut[11][14], dataOut[11][15], dataOut[12][0], dataOut[12][1], dataOut[12][2], dataOut[12][3], dataOut[12][4], dataOut[12][5], dataOut[12][6], dataOut[12][7], dataOut[12][8], dataOut[12][9], dataOut[12][10], dataOut[12][11], dataOut[12][12], dataOut[12][13], dataOut[12][14], dataOut[12][15], dataOut[13][0], dataOut[13][1], dataOut[13][2], dataOut[13][3], dataOut[13][4], dataOut[13][5], dataOut[13][6], dataOut[13][7], dataOut[13][8], dataOut[13][9], dataOut[13][10], dataOut[13][11], dataOut[13][12], dataOut[13][13], dataOut[13][14], dataOut[13][15], dataOut[14][0], dataOut[14][1], dataOut[14][2], dataOut[14][3], dataOut[14][4], dataOut[14][5], dataOut[14][6], dataOut[14][7], dataOut[14][8], dataOut[14][9], dataOut[14][10], dataOut[14][11], dataOut[14][12], dataOut[14][13], dataOut[14][14], dataOut[14][15], dataOut[15][0], dataOut[15][1], dataOut[15][2], dataOut[15][3], dataOut[15][4], dataOut[15][5], dataOut[15][6], dataOut[15][7], dataOut[15][8], dataOut[15][9], dataOut[15][10], dataOut[15][11], dataOut[15][12], dataOut[15][13], dataOut[15][14], dataOut[15][15]);
        
        window_data_in[5][5] = 180;
        @(posedge clk);
        @(posedge clk);

	    $display($time, , "count=%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n\n", count, dataOut[0][0], dataOut[0][1], dataOut[0][2], dataOut[0][3], dataOut[0][4], dataOut[0][5], dataOut[0][6], dataOut[0][7], dataOut[0][8], dataOut[0][9], dataOut[0][10], dataOut[0][11], dataOut[0][12], dataOut[0][13], dataOut[0][14], dataOut[0][15], dataOut[1][0], dataOut[1][1], dataOut[1][2], dataOut[1][3], dataOut[1][4], dataOut[1][5], dataOut[1][6], dataOut[1][7], dataOut[1][8], dataOut[1][9], dataOut[1][10], dataOut[1][11], dataOut[1][12], dataOut[1][13], dataOut[1][14], dataOut[1][15], dataOut[2][0], dataOut[2][1], dataOut[2][2], dataOut[2][3], dataOut[2][4], dataOut[2][5], dataOut[2][6], dataOut[2][7], dataOut[2][8], dataOut[2][9], dataOut[2][10], dataOut[2][11], dataOut[2][12], dataOut[2][13], dataOut[2][14], dataOut[2][15], dataOut[3][0], dataOut[3][1], dataOut[3][2], dataOut[3][3], dataOut[3][4], dataOut[3][5], dataOut[3][6], dataOut[3][7], dataOut[3][8], dataOut[3][9], dataOut[3][10], dataOut[3][11], dataOut[3][12], dataOut[3][13], dataOut[3][14], dataOut[3][15], dataOut[4][0], dataOut[4][1], dataOut[4][2], dataOut[4][3], dataOut[4][4], dataOut[4][5], dataOut[4][6], dataOut[4][7], dataOut[4][8], dataOut[4][9], dataOut[4][10], dataOut[4][11], dataOut[4][12], dataOut[4][13], dataOut[4][14], dataOut[4][15], dataOut[5][0], dataOut[5][1], dataOut[5][2], dataOut[5][3], dataOut[5][4], dataOut[5][5], dataOut[5][6], dataOut[5][7], dataOut[5][8], dataOut[5][9], dataOut[5][10], dataOut[5][11], dataOut[5][12], dataOut[5][13], dataOut[5][14], dataOut[5][15], dataOut[6][0], dataOut[6][1], dataOut[6][2], dataOut[6][3], dataOut[6][4], dataOut[6][5], dataOut[6][6], dataOut[6][7], dataOut[6][8], dataOut[6][9], dataOut[6][10], dataOut[6][11], dataOut[6][12], dataOut[6][13], dataOut[6][14], dataOut[6][15], dataOut[7][0], dataOut[7][1], dataOut[7][2], dataOut[7][3], dataOut[7][4], dataOut[7][5], dataOut[7][6], dataOut[7][7], dataOut[7][8], dataOut[7][9], dataOut[7][10], dataOut[7][11], dataOut[7][12], dataOut[7][13], dataOut[7][14], dataOut[7][15], dataOut[8][0], dataOut[8][1], dataOut[8][2], dataOut[8][3], dataOut[8][4], dataOut[8][5], dataOut[8][6], dataOut[8][7], dataOut[8][8], dataOut[8][9], dataOut[8][10], dataOut[8][11], dataOut[8][12], dataOut[8][13], dataOut[8][14], dataOut[8][15], dataOut[9][0], dataOut[9][1], dataOut[9][2], dataOut[9][3], dataOut[9][4], dataOut[9][5], dataOut[9][6], dataOut[9][7], dataOut[9][8], dataOut[9][9], dataOut[9][10], dataOut[9][11], dataOut[9][12], dataOut[9][13], dataOut[9][14], dataOut[9][15], dataOut[10][0], dataOut[10][1], dataOut[10][2], dataOut[10][3], dataOut[10][4], dataOut[10][5], dataOut[10][6], dataOut[10][7], dataOut[10][8], dataOut[10][9], dataOut[10][10], dataOut[10][11], dataOut[10][12], dataOut[10][13], dataOut[10][14], dataOut[10][15], dataOut[11][0], dataOut[11][1], dataOut[11][2], dataOut[11][3], dataOut[11][4], dataOut[11][5], dataOut[11][6], dataOut[11][7], dataOut[11][8], dataOut[11][9], dataOut[11][10], dataOut[11][11], dataOut[11][12], dataOut[11][13], dataOut[11][14], dataOut[11][15], dataOut[12][0], dataOut[12][1], dataOut[12][2], dataOut[12][3], dataOut[12][4], dataOut[12][5], dataOut[12][6], dataOut[12][7], dataOut[12][8], dataOut[12][9], dataOut[12][10], dataOut[12][11], dataOut[12][12], dataOut[12][13], dataOut[12][14], dataOut[12][15], dataOut[13][0], dataOut[13][1], dataOut[13][2], dataOut[13][3], dataOut[13][4], dataOut[13][5], dataOut[13][6], dataOut[13][7], dataOut[13][8], dataOut[13][9], dataOut[13][10], dataOut[13][11], dataOut[13][12], dataOut[13][13], dataOut[13][14], dataOut[13][15], dataOut[14][0], dataOut[14][1], dataOut[14][2], dataOut[14][3], dataOut[14][4], dataOut[14][5], dataOut[14][6], dataOut[14][7], dataOut[14][8], dataOut[14][9], dataOut[14][10], dataOut[14][11], dataOut[14][12], dataOut[14][13], dataOut[14][14], dataOut[14][15], dataOut[15][0], dataOut[15][1], dataOut[15][2], dataOut[15][3], dataOut[15][4], dataOut[15][5], dataOut[15][6], dataOut[15][7], dataOut[15][8], dataOut[15][9], dataOut[15][10], dataOut[15][11], dataOut[15][12], dataOut[15][13], dataOut[15][14], dataOut[15][15]);
        @(posedge clk);
        en = 0;

	    $display($time, , "count=%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n\n", count, dataOut[0][0], dataOut[0][1], dataOut[0][2], dataOut[0][3], dataOut[0][4], dataOut[0][5], dataOut[0][6], dataOut[0][7], dataOut[0][8], dataOut[0][9], dataOut[0][10], dataOut[0][11], dataOut[0][12], dataOut[0][13], dataOut[0][14], dataOut[0][15], dataOut[1][0], dataOut[1][1], dataOut[1][2], dataOut[1][3], dataOut[1][4], dataOut[1][5], dataOut[1][6], dataOut[1][7], dataOut[1][8], dataOut[1][9], dataOut[1][10], dataOut[1][11], dataOut[1][12], dataOut[1][13], dataOut[1][14], dataOut[1][15], dataOut[2][0], dataOut[2][1], dataOut[2][2], dataOut[2][3], dataOut[2][4], dataOut[2][5], dataOut[2][6], dataOut[2][7], dataOut[2][8], dataOut[2][9], dataOut[2][10], dataOut[2][11], dataOut[2][12], dataOut[2][13], dataOut[2][14], dataOut[2][15], dataOut[3][0], dataOut[3][1], dataOut[3][2], dataOut[3][3], dataOut[3][4], dataOut[3][5], dataOut[3][6], dataOut[3][7], dataOut[3][8], dataOut[3][9], dataOut[3][10], dataOut[3][11], dataOut[3][12], dataOut[3][13], dataOut[3][14], dataOut[3][15], dataOut[4][0], dataOut[4][1], dataOut[4][2], dataOut[4][3], dataOut[4][4], dataOut[4][5], dataOut[4][6], dataOut[4][7], dataOut[4][8], dataOut[4][9], dataOut[4][10], dataOut[4][11], dataOut[4][12], dataOut[4][13], dataOut[4][14], dataOut[4][15], dataOut[5][0], dataOut[5][1], dataOut[5][2], dataOut[5][3], dataOut[5][4], dataOut[5][5], dataOut[5][6], dataOut[5][7], dataOut[5][8], dataOut[5][9], dataOut[5][10], dataOut[5][11], dataOut[5][12], dataOut[5][13], dataOut[5][14], dataOut[5][15], dataOut[6][0], dataOut[6][1], dataOut[6][2], dataOut[6][3], dataOut[6][4], dataOut[6][5], dataOut[6][6], dataOut[6][7], dataOut[6][8], dataOut[6][9], dataOut[6][10], dataOut[6][11], dataOut[6][12], dataOut[6][13], dataOut[6][14], dataOut[6][15], dataOut[7][0], dataOut[7][1], dataOut[7][2], dataOut[7][3], dataOut[7][4], dataOut[7][5], dataOut[7][6], dataOut[7][7], dataOut[7][8], dataOut[7][9], dataOut[7][10], dataOut[7][11], dataOut[7][12], dataOut[7][13], dataOut[7][14], dataOut[7][15], dataOut[8][0], dataOut[8][1], dataOut[8][2], dataOut[8][3], dataOut[8][4], dataOut[8][5], dataOut[8][6], dataOut[8][7], dataOut[8][8], dataOut[8][9], dataOut[8][10], dataOut[8][11], dataOut[8][12], dataOut[8][13], dataOut[8][14], dataOut[8][15], dataOut[9][0], dataOut[9][1], dataOut[9][2], dataOut[9][3], dataOut[9][4], dataOut[9][5], dataOut[9][6], dataOut[9][7], dataOut[9][8], dataOut[9][9], dataOut[9][10], dataOut[9][11], dataOut[9][12], dataOut[9][13], dataOut[9][14], dataOut[9][15], dataOut[10][0], dataOut[10][1], dataOut[10][2], dataOut[10][3], dataOut[10][4], dataOut[10][5], dataOut[10][6], dataOut[10][7], dataOut[10][8], dataOut[10][9], dataOut[10][10], dataOut[10][11], dataOut[10][12], dataOut[10][13], dataOut[10][14], dataOut[10][15], dataOut[11][0], dataOut[11][1], dataOut[11][2], dataOut[11][3], dataOut[11][4], dataOut[11][5], dataOut[11][6], dataOut[11][7], dataOut[11][8], dataOut[11][9], dataOut[11][10], dataOut[11][11], dataOut[11][12], dataOut[11][13], dataOut[11][14], dataOut[11][15], dataOut[12][0], dataOut[12][1], dataOut[12][2], dataOut[12][3], dataOut[12][4], dataOut[12][5], dataOut[12][6], dataOut[12][7], dataOut[12][8], dataOut[12][9], dataOut[12][10], dataOut[12][11], dataOut[12][12], dataOut[12][13], dataOut[12][14], dataOut[12][15], dataOut[13][0], dataOut[13][1], dataOut[13][2], dataOut[13][3], dataOut[13][4], dataOut[13][5], dataOut[13][6], dataOut[13][7], dataOut[13][8], dataOut[13][9], dataOut[13][10], dataOut[13][11], dataOut[13][12], dataOut[13][13], dataOut[13][14], dataOut[13][15], dataOut[14][0], dataOut[14][1], dataOut[14][2], dataOut[14][3], dataOut[14][4], dataOut[14][5], dataOut[14][6], dataOut[14][7], dataOut[14][8], dataOut[14][9], dataOut[14][10], dataOut[14][11], dataOut[14][12], dataOut[14][13], dataOut[14][14], dataOut[14][15], dataOut[15][0], dataOut[15][1], dataOut[15][2], dataOut[15][3], dataOut[15][4], dataOut[15][5], dataOut[15][6], dataOut[15][7], dataOut[15][8], dataOut[15][9], dataOut[15][10], dataOut[15][11], dataOut[15][12], dataOut[15][13], dataOut[15][14], dataOut[15][15]);
        @(posedge clk);
        @(posedge clk);
	    $finish;
    end
endmodule: numeratorWindowTB*/




/*module numeratorDescriptorTB;

    bit en;
    bit clk;
    bit rst;
    bit [35:0]      desc_data_in;
    bit [10:-54]    d  [15:0] [15:0];
    bit [31:0]      dataOut [15:0] [15:0];
    bit [9:-54]     arr;
    bit [31:0]      out;


    numeratorDescriptor dut(.desc_array_out(d), .*);
    ilog2 i2 (.dataIn(arr), .dataOut(out));

	genvar k,l;
	generate
		for ( k= 0; k < 16; k++) begin
			for (l = 0; l < 16; l++) begin
				ilog2 ilog2_inst(.dataIn(d[k][l][9:-54]),
                .dataOut(dataOut[k][l]));
			end
		end
	endgenerate


    int i,j;


    initial begin

	    clk = 0;
	    rst = 1;
        en = 0;
	    forever	#5 clk = ~clk;

    end

    initial begin
        bit [8:0] count = 0;

	    rst = 0;
        en = 1;


        for (i = 0; i < 256; i++) begin
                desc_data_in = {count, count+4'd1, count+4'd2, count+4'd3};
                count = count+4;



	    $display($time, , "count=%d byte0=%d byte1=%d byte3=%d byte4=%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n\n", count, dut.descLog2_inst1.dataIn, dut.descLog2_inst2.dataIn, dut.descLog2_inst3.dataIn, dut.descLog2_inst4.dataIn, dataOut[0][0], dataOut[0][1], dataOut[0][2], dataOut[0][3], dataOut[0][4], dataOut[0][5], dataOut[0][6], dataOut[0][7], dataOut[0][8], dataOut[0][9], dataOut[0][10], dataOut[0][11], dataOut[0][12], dataOut[0][13], dataOut[0][14], dataOut[0][15], dataOut[1][0], dataOut[1][1], dataOut[1][2], dataOut[1][3], dataOut[1][4], dataOut[1][5], dataOut[1][6], dataOut[1][7], dataOut[1][8], dataOut[1][9], dataOut[1][10], dataOut[1][11], dataOut[1][12], dataOut[1][13], dataOut[1][14], dataOut[1][15], dataOut[2][0], dataOut[2][1], dataOut[2][2], dataOut[2][3], dataOut[2][4], dataOut[2][5], dataOut[2][6], dataOut[2][7], dataOut[2][8], dataOut[2][9], dataOut[2][10], dataOut[2][11], dataOut[2][12], dataOut[2][13], dataOut[2][14], dataOut[2][15], dataOut[3][0], dataOut[3][1], dataOut[3][2], dataOut[3][3], dataOut[3][4], dataOut[3][5], dataOut[3][6], dataOut[3][7], dataOut[3][8], dataOut[3][9], dataOut[3][10], dataOut[3][11], dataOut[3][12], dataOut[3][13], dataOut[3][14], dataOut[3][15], dataOut[4][0], dataOut[4][1], dataOut[4][2], dataOut[4][3], dataOut[4][4], dataOut[4][5], dataOut[4][6], dataOut[4][7], dataOut[4][8], dataOut[4][9], dataOut[4][10], dataOut[4][11], dataOut[4][12], dataOut[4][13], dataOut[4][14], dataOut[4][15], dataOut[5][0], dataOut[5][1], dataOut[5][2], dataOut[5][3], dataOut[5][4], dataOut[5][5], dataOut[5][6], dataOut[5][7], dataOut[5][8], dataOut[5][9], dataOut[5][10], dataOut[5][11], dataOut[5][12], dataOut[5][13], dataOut[5][14], dataOut[5][15], dataOut[6][0], dataOut[6][1], dataOut[6][2], dataOut[6][3], dataOut[6][4], dataOut[6][5], dataOut[6][6], dataOut[6][7], dataOut[6][8], dataOut[6][9], dataOut[6][10], dataOut[6][11], dataOut[6][12], dataOut[6][13], dataOut[6][14], dataOut[6][15], dataOut[7][0], dataOut[7][1], dataOut[7][2], dataOut[7][3], dataOut[7][4], dataOut[7][5], dataOut[7][6], dataOut[7][7], dataOut[7][8], dataOut[7][9], dataOut[7][10], dataOut[7][11], dataOut[7][12], dataOut[7][13], dataOut[7][14], dataOut[7][15], dataOut[8][0], dataOut[8][1], dataOut[8][2], dataOut[8][3], dataOut[8][4], dataOut[8][5], dataOut[8][6], dataOut[8][7], dataOut[8][8], dataOut[8][9], dataOut[8][10], dataOut[8][11], dataOut[8][12], dataOut[8][13], dataOut[8][14], dataOut[8][15], dataOut[9][0], dataOut[9][1], dataOut[9][2], dataOut[9][3], dataOut[9][4], dataOut[9][5], dataOut[9][6], dataOut[9][7], dataOut[9][8], dataOut[9][9], dataOut[9][10], dataOut[9][11], dataOut[9][12], dataOut[9][13], dataOut[9][14], dataOut[9][15], dataOut[10][0], dataOut[10][1], dataOut[10][2], dataOut[10][3], dataOut[10][4], dataOut[10][5], dataOut[10][6], dataOut[10][7], dataOut[10][8], dataOut[10][9], dataOut[10][10], dataOut[10][11], dataOut[10][12], dataOut[10][13], dataOut[10][14], dataOut[10][15], dataOut[11][0], dataOut[11][1], dataOut[11][2], dataOut[11][3], dataOut[11][4], dataOut[11][5], dataOut[11][6], dataOut[11][7], dataOut[11][8], dataOut[11][9], dataOut[11][10], dataOut[11][11], dataOut[11][12], dataOut[11][13], dataOut[11][14], dataOut[11][15], dataOut[12][0], dataOut[12][1], dataOut[12][2], dataOut[12][3], dataOut[12][4], dataOut[12][5], dataOut[12][6], dataOut[12][7], dataOut[12][8], dataOut[12][9], dataOut[12][10], dataOut[12][11], dataOut[12][12], dataOut[12][13], dataOut[12][14], dataOut[12][15], dataOut[13][0], dataOut[13][1], dataOut[13][2], dataOut[13][3], dataOut[13][4], dataOut[13][5], dataOut[13][6], dataOut[13][7], dataOut[13][8], dataOut[13][9], dataOut[13][10], dataOut[13][11], dataOut[13][12], dataOut[13][13], dataOut[13][14], dataOut[13][15], dataOut[14][0], dataOut[14][1], dataOut[14][2], dataOut[14][3], dataOut[14][4], dataOut[14][5], dataOut[14][6], dataOut[14][7], dataOut[14][8], dataOut[14][9], dataOut[14][10], dataOut[14][11], dataOut[14][12], dataOut[14][13], dataOut[14][14], dataOut[14][15], dataOut[15][0], dataOut[15][1], dataOut[15][2], dataOut[15][3], dataOut[15][4], dataOut[15][5], dataOut[15][6], dataOut[15][7], dataOut[15][8], dataOut[15][9], dataOut[15][10], dataOut[15][11], dataOut[15][12], dataOut[15][13], dataOut[15][14], dataOut[15][15]);
                @(posedge clk);
	    end
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
	    $finish;
    end
endmodule: numeratorDescriptorTB*/


/*module tb;

    bit en;
    bit clk;
    bit rst;
    bit [31:0]          dataIn;
    bit [10:-54]        dataOut;
    bit [31:0]          dataOut2;



    log2 l2 (.*);
	ilog2 ilog2_inst(.dataIn(dataOut), .dataOut(dataOut2));

    int i,j;
    
    initial begin
	    $monitor($time, , "%d\t%d\t%d", dataIn, dataOut, dataOut2); 

	    clk = 0;
	    rst = 1;
        en = 0;
	    forever	#5 clk = ~clk;

    end

    initial begin
        bit [8:0] count = 0;


	    rst <= #1 0;
        en <= #1 1;

        @(posedge clk);

        for (i = 0; i < 65000; i++) begin
            dataIn = i;
            @(posedge clk);
	    end
        
	    $finish;
    end
endmodule: tb*/






/*module tb;

    bit en;
    bit clk;
    bit rst;
    bit [10:-54]    desc_data_in    [3:0];
    bit [10:-54]    d  [15:0] [15:0];


    latchNumDesc dut(.desc_array_out(d), .*);

    int i,j;


    initial begin

	    $monitor($time, , "en=%d i=%d j=%d: %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n\n", en, dut.iCounterOld, dut.jCounterOld, d[0][0], d[0][1], d[0][2], d[0][3], d[0][4], d[0][5], d[0][6], d[0][7], d[0][8], d[0][9], d[0][10], d[0][11], d[0][12], d[0][13], d[0][14], d[0][15], d[1][0], d[1][1], d[1][2], d[1][3], d[1][4], d[1][5], d[1][6], d[1][7], d[1][8], d[1][9], d[1][10], d[1][11], d[1][12], d[1][13], d[1][14], d[1][15], d[2][0], d[2][1], d[2][2], d[2][3], d[2][4], d[2][5], d[2][6], d[2][7], d[2][8], d[2][9], d[2][10], d[2][11], d[2][12], d[2][13], d[2][14], d[2][15], d[3][0], d[3][1], d[3][2], d[3][3], d[3][4], d[3][5], d[3][6], d[3][7], d[3][8], d[3][9], d[3][10], d[3][11], d[3][12], d[3][13], d[3][14], d[3][15], d[4][0], d[4][1], d[4][2], d[4][3], d[4][4], d[4][5], d[4][6], d[4][7], d[4][8], d[4][9], d[4][10], d[4][11], d[4][12], d[4][13], d[4][14], d[4][15], d[5][0], d[5][1], d[5][2], d[5][3], d[5][4], d[5][5], d[5][6], d[5][7], d[5][8], d[5][9], d[5][10], d[5][11], d[5][12], d[5][13], d[5][14], d[5][15], d[6][0], d[6][1], d[6][2], d[6][3], d[6][4], d[6][5], d[6][6], d[6][7], d[6][8], d[6][9], d[6][10], d[6][11], d[6][12], d[6][13], d[6][14], d[6][15], d[7][0], d[7][1], d[7][2], d[7][3], d[7][4], d[7][5], d[7][6], d[7][7], d[7][8], d[7][9], d[7][10], d[7][11], d[7][12], d[7][13], d[7][14], d[7][15], d[8][0], d[8][1], d[8][2], d[8][3], d[8][4], d[8][5], d[8][6], d[8][7], d[8][8], d[8][9], d[8][10], d[8][11], d[8][12], d[8][13], d[8][14], d[8][15], d[9][0], d[9][1], d[9][2], d[9][3], d[9][4], d[9][5], d[9][6], d[9][7], d[9][8], d[9][9], d[9][10], d[9][11], d[9][12], d[9][13], d[9][14], d[9][15], d[10][0], d[10][1], d[10][2], d[10][3], d[10][4], d[10][5], d[10][6], d[10][7], d[10][8], d[10][9], d[10][10], d[10][11], d[10][12], d[10][13], d[10][14], d[10][15], d[11][0], d[11][1], d[11][2], d[11][3], d[11][4], d[11][5], d[11][6], d[11][7], d[11][8], d[11][9], d[11][10], d[11][11], d[11][12], d[11][13], d[11][14], d[11][15], d[12][0], d[12][1], d[12][2], d[12][3], d[12][4], d[12][5], d[12][6], d[12][7], d[12][8], d[12][9], d[12][10], d[12][11], d[12][12], d[12][13], d[12][14], d[12][15], d[13][0], d[13][1], d[13][2], d[13][3], d[13][4], d[13][5], d[13][6], d[13][7], d[13][8], d[13][9], d[13][10], d[13][11], d[13][12], d[13][13], d[13][14], d[13][15], d[14][0], d[14][1], d[14][2], d[14][3], d[14][4], d[14][5], d[14][6], d[14][7], d[14][8], d[14][9], d[14][10], d[14][11], d[14][12], d[14][13], d[14][14], d[14][15], d[15][0], d[15][1], d[15][2], d[15][3], d[15][4], d[15][5], d[15][6], d[15][7], d[15][8], d[15][9], d[15][10], d[15][11], d[15][12], d[15][13], d[15][14], d[15][15]);

	    clk = 0;
	    rst = 1;
        en = 0;
	    forever	#5 clk = ~clk;

    end

    initial begin
        int count = 1;

	    rst <= #1 0;
        en <= #1 1;

        @(posedge clk);

        for (i = 0; i < 64; i++) begin
			    desc_data_in[0] = count;
                desc_data_in[1] = count+4'd1;
                desc_data_in[2] = count+4'd2;
                desc_data_in[3] = count+4'd3;
                count = count+4;
                @(posedge clk);
	    end
        en = 0;
        @(posedge clk);
        rst <= 1;
        en <= 0;
        
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
	    $finish;
    end
endmodule: tb*/
