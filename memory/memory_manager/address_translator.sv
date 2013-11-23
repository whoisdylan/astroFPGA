module address_translator (row, col, tem_win, frame, 
							address);
							
	input logic [6:0]	row, col;		//
	input logic			tem_win;		
	input logic	[7:0]	set;			// total of 150 sets
	input logic			frame;			// frame 0 or frame 1
	output logic [20:0] address;
	always_comb begin
		address = ((frame)? 21'h3CF96: 21'h0) + set*21'd1665 + (tem_win)? (21'd65 +(row*21'd20)+col):((row<<2) + col);
	end
	
endmodule: address_translator