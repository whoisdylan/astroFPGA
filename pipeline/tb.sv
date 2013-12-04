module numeratorWindowTB;

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
endmodule: numeratorWindowTB


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
