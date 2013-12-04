module tree_adder
#(parameter inputSize = 9)
(input logic clk,
input logic rst_n,
input logic enable,
input logic signed [inputSize-1:0] operand[16][16] ,
output logic signed [inputSize-1+8:0] sum_result);

logic signed [inputSize +1 -1:0] sum_0_in[128];
logic signed [inputSize +2 -1:0] sum_1_in[64];
logic signed [inputSize +3 -1:0] sum_2_in[32];
logic signed [inputSize +4 -1:0] sum_3_in[16];
logic signed [inputSize +5 -1:0] sum_4_in[8];
logic signed [inputSize +6 -1:0] sum_5_in[4];
logic signed [inputSize +7 -1:0] sum_6_in[2];
logic signed [inputSize +8 -1:0] sum_7_in;

logic signed [inputSize +1 -1:0] sum_0_out[128];
logic signed [inputSize +2 -1:0] sum_1_out[64];
logic signed [inputSize +3 -1:0] sum_2_out[32];
logic signed [inputSize +4 -1:0] sum_3_out[16];
logic signed [inputSize +5 -1:0] sum_4_out[8];
logic signed [inputSize +6 -1:0] sum_5_out[4];
logic signed [inputSize +7 -1:0] sum_6_out[2];
logic signed [inputSize +8 -1:0] sum_7_out;


assign sum_result = sum_7_out;
//pair off all the values.
// first pairing 256 ==> 128

genvar i;
generate 

	for(i = 0 ; i < 128; i++) begin
	// 128 sum
		adder#(inputSize) stage0(.input_A(operand[i/8][(i%8)*2]),.input_B(operand[i/8][(i%8)*2 +1]),.out(sum_0_in[i]));
		adder_reg#(inputSize) re_0(.clk(clk),.rst_n(rst_n),.in(sum_0_in[i]),.enable(enable),.out(sum_0_out[i]));

	end
endgenerate

generate 
// second pairing 128 ==>64
for(i = 0; i< 64; i++)begin

adder#(inputSize+1) stage1(.input_A(sum_0_out[i*2]),.input_B(sum_0_out[i*2+1]),.out(sum_1_in[i]));
adder_reg#(inputSize+1) re_1(.clk(clk),.rst_n(rst_n),.in(sum_1_in[i]),.enable(enable),.out(sum_1_out[i]));



end
endgenerate

generate
// third pairing 64 ==>32
for(i = 0; i<32; i++)begin

adder#(inputSize+2) stage2(.input_A(sum_1_out[i*2]),.input_B(sum_1_out[i*2+1]),.out(sum_2_in[i]));
adder_reg#(inputSize+2) re_2(.clk(clk),.rst_n(rst_n),.in(sum_2_in[i]),.enable(enable),.out(sum_2_out[i]));


end
endgenerate

generate
// forth pairing 32 ==>16
for( i = 0; i<16; i++)begin

adder#(inputSize+3) stage3(.input_A(sum_2_out[i*2]),.input_B(sum_2_out[i*2+1]),.out(sum_3_in[i]));
adder_reg#(inputSize+3) re_3(.clk(clk),.rst_n(rst_n),.in(sum_3_in[i]),.enable(enable),.out(sum_3_out[i]));


end
endgenerate

generate
// fifth pairing 16 ==>8

for( i = 0; i <8; i++)begin

adder#(inputSize+4) stage4(.input_A(sum_3_out[i*2]),.input_B(sum_3_out[i*2+1]),.out(sum_4_in[i]));
adder_reg#(inputSize+4) re_4(.clk(clk),.rst_n(rst_n),.in(sum_4_in[i]),.enable(enable),.out(sum_4_out[i]));


end
endgenerate
generate
// sixth pairing 8 ==> 4

for( i = 0; i < 4; i++)begin

adder#(inputSize+5) stage5(.input_A(sum_4_out[i*2]),.input_B(sum_4_out[i*2+1]),.out(sum_5_in[i]));
adder_reg#(inputSize+5) re_5(.clk(clk),.rst_n(rst_n),.in(sum_5_in[i]),.enable(enable),.out(sum_5_out[i]));


end
endgenerate
generate 
// seventh pairing 4 ==>2

for( i = 0; i <2; i++)begin

adder#(inputSize+6) stage6(.input_A(sum_5_out[i*2]),.input_B(sum_5_out[i*2+1]),.out(sum_6_in[i]));
adder_reg#(inputSize+6) re_6(.clk(clk),.rst_n(rst_n),.in(sum_6_in[i]),.enable(enable),.out(sum_6_out[i]));


end
endgenerate

generate
// eigth pairing 2 ==>1

adder#(inputSize+7) stage7(.input_A(sum_6_out[0]),.input_B(sum_6_out[1]),.out(sum_7_in));
adder_reg#(inputSize+7) re_7(.clk(clk),.rst_n(rst_n),.in(sum_7_in),.enable(enable),.out(sum_7_out));

endgenerate

endmodule: tree_adder

module adder #(parameter inputSize = 9)(
				input logic signed [inputSize-1:0] input_A,
				input logic signed [inputSize-1:0] input_B,
				output logic signed [inputSize:0] out
);

assign out = input_A + input_B;

endmodule: adder


module adder_reg #(parameter inputSize = 9)
		 (input logic clk,
		  input logic rst_n,
		  input logic signed [inputSize:0] in,
		  input logic enable,
		  output logic signed[inputSize:0] out);

always_ff@(posedge clk,negedge rst_n)begin
	if(~rst_n)begin
		out <= 'd0;
	end
	else if (enable)begin
		out <= in;
	end
	else begin
		out <= out;
	end
end
endmodule: adder_reg
