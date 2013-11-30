module average( window_data, avg_window_data);

input logic [15:0][15:0][7:0] window_data;		//incoming data
output logic [8:0]avg_window_data [15:0][15:0];
logic [15:0]	sum;
logic [7:0]		avg;
int i,j;

always_comb begin
	// sum up everything
	sum = 0;
	for(i = 0; i <16; i++)begin
		for(j = 0; j <16; j++)begin
			sum = sum + window_data[i][j];
		end
	end
	avg = sum[15:8];	// division by 256 is right shift by8

	for(i = 0; i <16 ; i++) begin
		for(j = 0; j <16; j++) begin
			avg_window_data[i][j] = $signed({1'b0, window_data[i][j]}) - {1'b0,avg};
		end
	end
end

endmodule: average
