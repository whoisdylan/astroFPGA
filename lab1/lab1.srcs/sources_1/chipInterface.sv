module chipInterface(SYSCLK_P, SYSCLK_N, 
			   GPIO_SW_C,			   
			   GPIO_SW_E,			   
			   GPIO_SW_S,			   
			   GPIO_SW_W,			   
			   GPIO_LED_3_LS, GPIO_LED_2_LS, GPIO_LED_1_LS, GPIO_LED_0_LS,
			   LCD_RS_LS, LCD_RW_LS, LCD_E_LS,
			   LCD_DB7_LS, LCD_DB6_LS, LCD_DB5_LS, LCD_DB4_LS);
	input SYSCLK_P, SYSCLK_N;
	
	// input	   USER_CLK; virtex-5
	/* switch C is reset, E is clear, S is resetFSM, W is nextString */
	input	   GPIO_SW_C, GPIO_SW_E, GPIO_SW_S, GPIO_SW_W;	
	output     GPIO_LED_3_LS, GPIO_LED_2_LS, GPIO_LED_1_LS, GPIO_LED_0_LS;
	output	   LCD_RW_LS, LCD_RS_LS, LCD_E_LS, LCD_DB7_LS, LCD_DB6_LS, LCD_DB5_LS, LCD_DB4_LS;
	
	logic		[2:0]	control_out; //rs, rw, en
	logic		[3:0]   out;
	logic				reset;
	
	
	logic	writeStart;
	logic	writeDone;
	logic	initDone;
	logic[7:0]	data;
	logic	clearAll;
	logic	resetFSM;
	logic	nextString;
	logic sysClock;
	logic sysClock_buffer;
	bit[3:0] count;
	bit incrEn, decrEn;
	//fancy stuff for clock here
	IBUFDS #( .DIFF_TERM("TRUE"),
			.IBUF_LOW_PWR("TRUE"),
			.IOSTANDARD("DEFAULT"))
	clk_ibufds ( .O(sysClock_buffer),
				.I(SYSCLK_P),
				.IB(SYSCLK_N)
				);
	always_ff @(posedge sysClock_buffer, posedge reset) begin
		if(reset)
				sysClock = 0;
		else
			sysClock = ~sysClock;
	end
	
	//
	assign reset = GPIO_SW_E;
	//assign resetFSM = GPIO_SW_S;
	//assign clearAll = GPIO_SW_E;
	//assign nextString = GPIO_SW_W;
	
	assign LCD_DB7_LS = out[3];
	assign LCD_DB6_LS = out[2];
	assign LCD_DB5_LS = out[1];
	assign LCD_DB4_LS = out[0];	
	
	assign LCD_RS_LS = control_out[2];
	assign LCD_RW_LS = control_out[1];
	assign LCD_E_LS  = control_out[0];
	assign {GPIO_LED_3_LS, GPIO_LED_2_LS, GPIO_LED_1_LS, GPIO_LED_0_LS} = count;
	
	/*
	rst, clk, 
    control:  				LCD_RS, LCD_RW, LCD_E
							LCD_RS:	
							LCD_RW:
							LCD_E: 
							
    sf_d:					LCD data bus, 4 bit interface.
    initDone:		output   assert high when initialization completes
    writeStart:		input	 when to start writing.
    writeDone:		output 	 assert high when writing of infomation completes
    dataIn:			input[8] char
    clearAll:		input	clear all data in the LCD module
	
	*/
	counterTop		county(.clk(sysClock), .rst(reset), .incrCount(GPIO_SW_C), .decrCount(GPIO_SW_W), .*);
	lcd_control		lcd(.rst(reset), .clk(sysClock), .control(control_out), .sf_d(out),
							 .writeStart(writeStart), .initDone(initDone), .writeDone(writeDone),
							 .dataIn(data), 
							 .clearAll(clearAll));
							 						
	testFSM			myTestFsm(.clkFSM(sysClock), .resetFSM(reset), .data(data),
							.initDone(initDone), .writeStart(writeStart),
							.writeDone(writeDone), .input_data(count), .update(incrEn|decrEn),
							.lcd_clear(clearAll));

endmodule: chipInterface
