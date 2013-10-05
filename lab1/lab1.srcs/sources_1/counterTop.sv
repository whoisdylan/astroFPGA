module counterTop(input bit clk, rst, incrCount, decrCount,
				  output bit incrEn, decrEn, bit[3:0] count);
    
    enum logic[1:0] {WAIT = 2'd0, incr = 2'd1, decr = 2'd2} currState, nextState;
    
	always_comb begin
		incrEn = 1'd0;
		decrEn = 1'd0;
		case (currState)
			WAIT: begin
				if (incrCount)
					nextState = incr;
				else if (decrCount)
					nextState = decr;
				else
					nextState = WAIT;
			end
			incr: begin
				if (!incrCount & !decrCount) begin
					nextState = WAIT;
					incrEn = 1'd1;
				end
				else
					nextState = incr;
			end
			decr: begin
				if (!incrCount & !decrCount) begin
					nextState = WAIT;
					decrEn = 1'd1;
				end
				else
					nextState = decr;
			end
		endcase
	end

	//counter
	always_ff @(posedge clk, posedge rst) begin
		if (rst)
			count <= 4'd0;
		else if (incrEn)
			count = count + 4'd1;
		else if (decrEn)
			count = count - 4'd1;
	end

    always_ff @(posedge clk, posedge rst) begin
		if (rst)
			currState <= WAIT;
		else
			currState <= nextState;
	end
    
endmodule: counterTop
