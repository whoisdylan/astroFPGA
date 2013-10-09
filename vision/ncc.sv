module ncc
	#(parameter descSize = 256)
	(input logic clk, rst,
	 input bit   pciIn,
	output logic iWishIKnew);

	enum logic {WAIT, LOAD_DESC} currStateDesc, nextStateDesc;
	logic loadDesc, currStateDesc, nextStateDesc, enDescCounter, shiftDescReg, doneLoadingDesc;
	bit [descSize-1:0] descriptor;
	bit [$clog2(descSize)-1:0] descCount;

	assign enDescCounter = shiftDescReg || loadDesc;
	assign doneLoadingDesc = descCount == descSize;

	//counter for loading descriptor
	counter #(descSize) descCounter(.clk(clk), .rst(rst), .enable(enDescCounter),
									.count(descCount));
	//descriptor register
	shiftRegister #(descSize) descReg(.clk(clk), .rst(rst), .load(loadDescReg), 
									  .shift(shiftDescReg), .in(pciIn), .out(descriptor));

	//descriptor shift register fsm
	always_comb begin
		loadDesc = 1'd0;
		shiftDescReg = 1'd0;
		case (currStateDesc)
			WAIT: begin
				if (startLoadingDesc) begin
					loadDesc = 1'd1;
					enDescCounter = 1'd1;
					nextStateDesc = LOAD_DESC;
				end
				else begin
					nextStateDesc = WAIT;
				end
			end
			LOAD_DESC: begin
				if (doneLoadingDesc) begin
					nextStateDesc = WAIT
				end
				else begin
					shiftDescReg = 1'd1;
					nextStateDesc = LOAD_DESC;
				end
			end
		endcase
	end

	//state register
	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			currStateDesc <= WAIT;
		end
		else begin
			currStateDesc <= nextStateDesc;
		end
	end

endmodule: ncc

module shiftRegister
	#(parameter w = 256)
	 (input logic clk, rst, load, shift,
	  input bit in,
	 output bit [w-1:0] out);

	 bit [w-1:0] val;
	 assign out = val;

	 always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			val <= 'd0;
		end
		else if (load) begin
			val <= in;
		end
		else if (shift) begin
			val <= val << 1;
		end
	end
endmodule: shiftRegister

module counter
	#(parameter w = 256)
	(input logic clk, rst, enable,
	output bit [$clog2(w)-1:0] count);

	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			count <= 'd0;
		end
		else if (enable) begin
			count <= count + 'd1;
		end
	end
endmodule: counter
