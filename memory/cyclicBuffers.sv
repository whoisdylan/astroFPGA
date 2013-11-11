module fsmToGun
#(parameter W=8, L=80)
(
    // to user.
    input logic    ready_2_start,
    input logic [31:0] user_rd_data, // read data to send to user.
    input logic clk, reset,
   
    // from user.
    output logic            req,   // requesting a read or write operation.
    output logic            rd_wr,  // deterimine if read or write. read = 0, write = 1
    output logic    [20:0]  user_req_addr, // requested address.
    output logic    [31:0]  user_write_data, // data to write to memory.
    output logic            set_done // complete a set.

    output bit [W-1:0] out1, out2, out3, out4,
    output bit [W-1:0] out5, out6, out7, out8,
    output bit [W-1:0] out9, out10, out11, out12,
    output bit [W-1:0] out13, out14, out15, out16
);

    bit we;
    bit [11:0] count_win_n, count_temp_n;
    bit [11:0] count_win, count_temp;
    bit [20:0] user_req_addr_n;
    bit [31:0] user_write_data_n;
    bit [31:0] user_rd_data_o;

    register count_win_reg #(12) (.newData(count_win_n), .oldData(count_win), .*)
    register count_temp_reg #(12) (.newData(count_temp_n), .oldData(count_temp), .*)
    register user_data #(32) (.newData(user_rd_data_n), .oldData(user_rd_data_o), .*);

    windowStorage ws #(W,L) (.dataIn(user_rd_data), .*);


    enum bit[2:0] {RESET, WAIT, GET_WIN, LOAD1, LOAD2, LOAD3, LOAD4, DONE} c_state, n_state;

    always_comb begin
        n_state = RESET;
        case (c_state)
            RESET: begin
                $display("In state RESET");
                if (ready_2_start) begin
                    n_state = GET_WIN;
                end
                else begin
                    n_state = WAIT;
                end
            end
            WAIT: begin
                $display("In state WAIT");
                if (ready_to_start) begin
                    n_state = GET_WIN;
                end
                else begin
                    n_state = WAIT;
                end
            end
            GET_WIN: begin
                $display("In state GET_WIN");
                if (set_done) begin
                    n_state = RESET;
                end
                else begin
                    n_state = LOAD1;
                end
            end
            LOAD1: begin
                $display("In state LOAD1");
                n_state = LOAD2;
            end
            LOAD2: begin
                $display("In state LOAD2");
                n_state = LOAD3;
            end
            LOAD3: begin
                $display("In state LOAD3");
                n_state = LOAD4;
            end
            LOAD4: begin
                $display("In state LOAD4");
                n_state = GET_WIN;
            end
            DONE: begin
                $display("In state DONE");
                if (ready_2_start) begin
                    n_state = GET_WIN;
                else begin
                    n_state = WAIT;
                end
            end
        end
    end

    always_comb begin

        req = 0;
        rd_wr = 0;
        set_done = 0;
        user_req_addr_n = user_req_addr;
        user_write_addr_n = user_write_addr;
        count_temp_n = count_temp;
        count_win_n = count_win;
        user_rd_data_n = user_rd_data_o;
        we = 0;

        case (c_state)
            RESET: begin
                count_win = 0;
                count_temp = 0;
                user_req_addr = 0;
                user_write_addr = 0;
            end
            WAIT: begin
            end
            GET_WIN: begin
                count_temp_n = count_temp+1;
                if (count_win >= 1600 & count_temp >= 150) begin
                    set_done = 1;
                end
                else begin
                    req = 1;
                end
            end
            LOAD1: begin
                we = 1;
                dataIn = user_rd_data[31:24];
                user_rd_data_n 
                user_rd_data_n = user_rd_data;
            end
            LOAD2: begin
                we = 1;
                dataIn = user_rd_data_o[15:8];
            end
            LOAD3: begin
                we = 1;
                dataIn = user_rd_data_o[23:16];
            end
            LOAD4: begin
                we = 1;
                dataIn = user_rd_data_o[31:24]
            end
            DONE: begin
                count_win_n = count_win+1;
            end
        end
    end

    always_ff @(posedge clk) begin
        c_state <= n_state;
        user_req_addr <= user_req_addr_n;
        user_write_addr <= user_write_addr_n;
    end

endmodule:fsmToGun

module register 
    #(parameter W = 32)
    (input bit clk, reset,
     input bit [W-1:0] newData,
     output bit [W-1:0] oldData);

    always_ff @(posedge clk) begin
        if (reset) oldData <= 0;
        else oldData <= newData;
        $display("cl=%d ld=%d readPtr = %d", cl, ld, newData);
    end
endmodule

module windowStorage
    #( parameter W = 8, L = 80)
    (input bit [W-1:0] dataIn,
     input bit we, clk, reset,

     output bit [W-1:0] out1, out2, out3, out4,
     output bit [W-1:0] out5, out6, out7, out8,
     output bit [W-1:0] out9, out10, out11, out12,
     output bit [W-1:0] out13, out14, out15, out16
    );


    cyclicBuffers cb1 (.dataOut(out1), .dataIn(dataIn), .*);
    cyclicBuffers cb2 (.dataOut(out2), .dataIn(out1), .*);
    cyclicBuffers cb3 (.dataOut(out3), .dataIn(out2), .*);
    cyclicBuffers cb4 (.dataOut(out4), .dataIn(out3), .*);
    cyclicBuffers cb5 (.dataOut(out5), .dataIn(out4), .*);
    cyclicBuffers cb6 (.dataOut(out6), .dataIn(out5), .*);
    cyclicBuffers cb7 (.dataOut(out7), .dataIn(out6), .*);
    cyclicBuffers cb8 (.dataOut(out8), .dataIn(out7), .*);
    cyclicBuffers cb9 (.dataOut(out9), .dataIn(out8), .*);
    cyclicBuffers cb10 (.dataOut(out10), .dataIn(out9), .*);
    cyclicBuffers cb11 (.dataOut(out11), .dataIn(out10), .*);
    cyclicBuffers cb12 (.dataOut(out12), .dataIn(out11), .*);
    cyclicBuffers cb13 (.dataOut(out13), .dataIn(out12), .*);
    cyclicBuffers cb14 (.dataOut(out14), .dataIn(out13), .*);
    cyclicBuffers cb15 (.dataOut(out15), .dataIn(out14), .*);
    cyclicBuffers cb16 (.dataOut(out16), .dataIn(out15), .*);

endmodule:windowStorage

module cyclicBuffers
    #(  parameter W = 8, L = 80)
	(input	bit	[W-1:0]	dataIn,
	 input	bit	we, clk, reset,				//write enable
	 output	bit	[W-1:0] dataOut
	);
	
	bit	[6:0]		ptr, oldPtr;
	
    bram_tdp #(72,W-1) BRAM  (.a_clk(clk), .a_wr(we), 
                            .a_addr(oldPtr),
                            .a_din(dataIn),
                            .a_dout(dataOut));

    always_comb begin
        if (reset)
            ptr = 7'd0;
        else if (we) begin
            if (ptr == L - 7'd2) begin
                ptr = 7'd0;
            end
            else 
                ptr = oldPtr+1'd1;
            end
        end
	
	always_ff @(posedge clk, posedge reset) begin
		if (reset) begin
			oldPtr <= 0;
		end
		else begin
			oldPtr <= ptr;
		end
	end
endmodule: cyclicBuffers


// A parameterized, inferable, true dual-port, dual-clock block RAM in Verilog.

module bram_tdp #(
    parameter DATA = 72,
    parameter ADDR = 10
) (
    // Port A
    input   bit                 a_clk,
    input   bit                 a_wr,
    input   bit     [ADDR-1:0]  a_addr,
    input   bit     [DATA-1:0]  a_din,
    output  bit     [DATA-1:0]  a_dout,

    // Port B
    input   bit                 b_clk,
    input   bit                 b_wr,
    input   bit     [ADDR-1:0]  b_addr,
    input   bit     [DATA-1:0]  b_din,
    output  bit     [DATA-1:0]  b_dout
);

    // Shared memory
    bit [DATA-1:0] mem [(2**ADDR)-1:0];

    // Port A
    always @(posedge a_clk) begin
        a_dout  <=  mem[a_addr];
        if(a_wr) begin
            //a_dout  <=  a_din;
            mem[a_addr] <=  a_din;
        end
    end

    // Port B
    always @(posedge b_clk) begin
        b_dout  <=   mem[b_addr];
        if(b_wr) begin
            //b_dout <= b_din;
            mem[b_addr] <= b_din;
        end
    end
endmodule
