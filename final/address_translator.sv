module address_translator (row, col, tem_win, set, 
							address, inst);
							
	input logic [6:0]	row, col;		//
	input logic			tem_win;		
	input logic	[7:0]	set;			// total of 150 sets
	input logic			inst;			// select the 32 bit instruction.
	output logic [20:0] address;

	logic [20:0] set_temp;

	assign set_temp = {13'd0, set};
	always_comb begin
		address = set_temp* 21'd1665;
		if(tem_win) begin
			address = address + 21'd65 + (row*21'd20) +col;
		end
		else if(~inst) begin
			address = address + (row <<2) + col + 'd1;
		end
		else begin
			address = address;
		end
	end
endmodule: address_translator
