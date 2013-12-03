module tree_adderTest;

	logic signed[8:0] array[16][16];
	logic signed [16:0] sum_result;
	logic		clk;
	logic		rst_n;


tree_adder #(9) dut(array, sum_result);
int i,j;


initial begin

	$monitor($time, , "array = %d, sum = %d",array[0][0], sum_result);

	clk = 0;
	rst_n = 0;
	rst_n <= #1 1;
	forever	#5 clk = ~clk;

end

initial begin
	for(i = 0; i <16 ; i++)begin
		for(j = 0; j <16 ; j++)begin
			array[i][j] = 9'sd1;
		end
	end

	#100;

	$display($time, , "array = %d, sum = %d",array[0][0], sum_result);


	$finish;
end


endmodule: tree_adderTest
