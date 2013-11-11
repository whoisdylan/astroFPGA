`default_nettype none

module cyclicBufferstb;
	bit	[7:0]	inValue; 

    bit [7:0]  out1, out2, out3, out4;
    bit [7:0]  out5, out6, out7, out8;
    bit [7:0]  out9, out10, out11, out12;
    bit [7:0]  out13, out14, out15, out16;

    bit we, clk, reset;
	int i;

    windowStorage ws (.dataIn(inValue), .we(we), .clk(clk), .reset(reset), .*);
	
	initial begin

        $display("hello world");
		$monitor($stime,, "i=%3d, inValue=%d, reset=%d, out1=%d, out2=%d, out3=%d, out4=%d, out5=%d, out6=%d, out7=%d, out8=%d, out9=%d, out10=%d, out11=%d, out12=%d, out13=%d, out14=%d, out15=%d, out16=%d", i, inValue, reset, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15, out16);

		clk = 0;
		reset = 1;
		reset <= #1 0;
		repeat (2000) #5 clk = ~clk;
	end
	
	initial begin
		we = 1;
		for (i = 0; i<1362; i++) begin
			inValue = i;
			@(posedge clk);
		end
	end
	
endmodule: cyclicBufferstb
