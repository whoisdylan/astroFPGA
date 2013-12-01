module log2Test;

logic signed	[31:0]			a_in;
logic			[10:-54]		a_out;
logic signed	[31:0]			inverse;
logic [31:0]					int_mem[500];
logic [31:0]					log_mem[500];

log2 dut1(.dataIn(a_in),.dataOut(a_out));
ilog2 dut2(.dataIn(a_out),.dataOut(inverse));

int i;

initial begin
$monitor($time, , "input = %h, logOutput = %b, inverse =%h, ref_input =%h, ref_output=%h",a_in, a_out, inverse, int_mem[i], log_mem[i]);

/*
	a_in = -32'sd50;
	#1;
	a_in = -32'sd100;
	#1;
	a_in = 32'd50;
	#1;
	a_in = 32'd100;
*/
	$readmemh("randInts.txt", int_mem);
	$readmemh("log2Nums.txt", log_mem);
	
	#10;
	for( i = 0; i <500 ; i ++)begin
		a_in = int_mem[i];
		#10;		
	end

	//$display("a_in =%h", int_mem[5]);

/*
	a_in = 2;
	#1;
	a_in = 4;
	#1;
	a_in = 8;
	*/
end


endmodule: log2Test
