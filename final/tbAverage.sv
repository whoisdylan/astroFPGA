`default_nettype none

module averageTest;

logic [15:0][15:0][7:0]		window_data;
logic signed [8:0]					avg_window_data[15:0][15:0];


average mean(.*);
int i,j;

initial begin
	for(i = 0; i < 16; i++)begin
		for(j = 0; j<16; j++)begin
			window_data[i][j] = i*j;
		end
	end
	#1;
	for(i = 0; i <16; i++) begin
		for(j = 0; j<16; j++)begin
			$display("row =%d, col =%d, average =%d, pixel =%d",i,j, avg_window_data[i][j],window_data[i][j]);
		end
	end
	$display("avereage = %d", mean.avg);
end


endmodule: averageTest
