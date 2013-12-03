module tree_adder
#(parameter inputSize = 9)
(input logic signed [inputSize-1:0] operand[16][16] ,
output logic signed [inputSize-1+8:0] sum_result);

logic signed [inputSize +1 -1:0] sum_0[128];
logic signed [inputSize +2 -1:0] sum_1[64];
logic signed [inputSize +3 -1:0] sum_2[32];
logic signed [inputSize +4 -1:0] sum_3[16];
logic signed [inputSize +5 -1:0] sum_4[8];
logic signed [inputSize +6 -1:0] sum_5[4];
logic signed [inputSize +7 -1:0] sum_6[2];
logic signed [inputSize +8 -1:0] sum_7;


assign sum_result = sum_7;
//pair off all the values.
// first pairing 256 ==> 128

genvar i;
generate 

	for(i = 0 ; i < 128; i++) begin
	// 128 sum
		adder#(inputSize) stage0(.input_A(operand[i/8][(i%8)*2]),.input_B(operand[i/8][(i%8)*2 +1]),.out(sum_0[i]));

	end
endgenerate

generate 
// second pairing 128 ==>64
for(i = 0; i< 64; i++)begin

adder#(inputSize+1) stage1(.input_A(sum_0[i*2]),.input_B(sum_0[i*2+1]),.out(sum_1[i]));

end
endgenerate

generate
// third pairing 64 ==>32
for(i = 0; i<32; i++)begin

adder#(inputSize+2) stage2(.input_A(sum_1[i*2]),.input_B(sum_1[i*2+1]),.out(sum_2[i]));

end
endgenerate

generate
// forth pairing 32 ==>16
for( i = 0; i<16; i++)begin

adder#(inputSize+3) stage3(.input_A(sum_2[i*2]),.input_B(sum_2[i*2+1]),.out(sum_3[i]));

end
endgenerate

generate
// fifth pairing 16 ==>8

for( i = 0; i <8; i++)begin

adder#(inputSize+4) stage4(.input_A(sum_3[i*2]),.input_B(sum_3[i*2+1]),.out(sum_4[i]));

end
endgenerate
generate
// sixth pairing 8 ==> 4

for( i = 0; i < 4; i++)begin

adder#(inputSize+5) stage5(.input_A(sum_4[i*2]),.input_B(sum_4[i*2+1]),.out(sum_5[i]));

end
endgenerate
generate 
// seventh pairing 4 ==>2

for( i = 0; i <2; i++)begin

adder#(inputSize+6) stage6(.input_A(sum_5[i*2]),.input_B(sum_5[i*2+1]),.out(sum_6[i]));

end
endgenerate

generate
// eigth pairing 2 ==>1

adder#(inputSize+7) stage7(.input_A(sum_6[0]),.input_B(sum_6[1]),.out(sum_7));

endgenerate

endmodule: tree_adder

module adder #(parameter inputSize = 9)(
				input logic signed [inputSize-1:0] input_A,
				input logic signed [inputSize-1:0] input_B,
				output logic signed [inputSize:0] out
);

assign out = input_A + input_B;

endmodule: adder

