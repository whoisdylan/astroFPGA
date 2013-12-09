
//-----------------------------------------------------------------------------
// Project    : Series-7 Integrated Block for PCI Express
// File       : PIO_EP_MEM_ACCESS.v
// Version    : 2.1
//--
//-- Description: Endpoint Memory Access Unit. This module provides access functions
//--              to the Endpoint memory aperture.
//--
//--              Read Access: Module returns data for the specifed address and
//--              byte enables selected.
//--
//--              Write Access: Module accepts data, byte enables and updates
//--              data when write enable is asserted. Modules signals write busy
//--              when data write is in progress.
//--
//--------------------------------------------------------------------------------


`timescale 1ps/1ps



module PIO_EP_astroFPGA_MEM  #(
  parameter TCQ = 1
) (

  clk,
  rst_n,

  // Read Access

  rd_addr,     // I [20:0]  Read Address
  rd_be,       // I [3:0]   Read Byte Enable
  rd_data,     // O [31:0]  Read Data

  // Write Access

  wr_addr,     // I [20:0]  Write Address
  wr_be,       // I [7:0]   Write Byte Enable
  wr_data,     // I [31:0]  Write Data
  wr_en,       // I         Write Enable
  wr_busy,      // O         Write Controller Busy
  LEDs

);

  input            clk;
  input            rst_n;

  //  Read Port

  input  logic [20:0]    rd_addr;
  input  logic [3:0]     rd_be;
  output logic [31:0]    rd_data;

  //  Write Port

  input logic [20:0]    wr_addr;
  input logic [7:0]     wr_be;
  input logic [31:0]    wr_data;
  input logic           wr_en;
  output logic          wr_busy;

  output bit [3:0] LEDs;
  
  logic [20:0] pci_req_addr;
  logic [20:0] FPGA_req_addr;
  logic [31:0] input_data;
  logic [31:0] FPGA_data;
  logic [31:0] pci_data;

`define BLOCK_SIZE 8
logic [15:0] pci_req_addr_16;
logic [15:0] FPGA_req_addr_16;
logic [31:0] pci_data_array[`BLOCK_SIZE];
logic [31:0] FPGA_data_array[`BLOCK_SIZE];
logic local_clk;

assign pci_req_addr = (wr_en)? wr_addr:rd_addr;

assign input_data = wr_data;
// FPGA_req_addr = 21'd0;
//assign FPGA_data = 32'd0;
assign wr_busy = ~pci_rd_ready;


logic [3:0] pci_byte_en[`BLOCK_SIZE];
logic [3:0] FPGA_byte_en[`BLOCK_SIZE];
logic [31:0] pci_input_data;
logic [31:0] FPGA_input_data;
logic [31:0] flags, new_flags;
logic FPGA_wr_en;


assign pci_input_data = input_data;

assign pci_req_addr_16 = pci_req_addr[15:0];
assign FPGA_req_addr_16 = FPGA_req_addr[15:0];

always_comb begin // BRAM 16bit address, 4 bytes per address
    
	if(wr_en) begin
		pci_byte_en[0] = 'b0;
        pci_byte_en[1] = 'b0;
        pci_byte_en[2] = 'b0;
        pci_byte_en[3] = 'b0;
        pci_byte_en[4] = 'b0;
        pci_byte_en[5] = 'b0;
        pci_byte_en[6] = 'b0;
        pci_byte_en[7] = 'b0;
	case(pci_req_addr[18:16]) 
		3'd0:pci_byte_en[0] = wr_be[3:0];
		3'd1:pci_byte_en[1] = wr_be[3:0];
		3'd2:pci_byte_en[2] = wr_be[3:0];
		3'd3:pci_byte_en[3] = wr_be[3:0];
		3'd4:pci_byte_en[4] = wr_be[3:0];
		3'd5:pci_byte_en[5] = wr_be[3:0];
		3'd6:pci_byte_en[6] = wr_be[3:0];
		3'd7:pci_byte_en[7] = wr_be[3:0];
	endcase
	end
	else begin
		pci_byte_en[0] = 'b0;
        pci_byte_en[1] = 'b0;
        pci_byte_en[2] = 'b0;
        pci_byte_en[3] = 'b0;
        pci_byte_en[4] = 'b0;
        pci_byte_en[5] = 'b0;
        pci_byte_en[6] = 'b0;
        pci_byte_en[7] = 'b0;
	end
	case(pci_req_addr[18:16]) 
		3'd0:pci_data = pci_data_array[0];
		3'd1:pci_data = pci_data_array[1];
		3'd2:pci_data = pci_data_array[2];
		3'd3:pci_data = pci_data_array[3];
		3'd4:pci_data = pci_data_array[4];
		3'd5:pci_data = pci_data_array[5];
		3'd6:pci_data = pci_data_array[6];
		3'd7:pci_data = pci_data_array[7];
	endcase
	FPGA_byte_en[0] = 'b0;
	FPGA_byte_en[1] = 'b0;
	FPGA_byte_en[2] = 'b0;
	FPGA_byte_en[3] = 'b0;
	FPGA_byte_en[4] = 'b0;
	FPGA_byte_en[5] = 'b0;
	FPGA_byte_en[6] = 'b0;
	FPGA_byte_en[7] = 'b0;
	if(FPGA_wr_en) begin
		case(FPGA_req_addr[18:16])
			3'd0:FPGA_byte_en[0] = 4'b1111;
			3'd1:FPGA_byte_en[1] = 4'b1111;
			3'd2:FPGA_byte_en[2] = 4'b1111;
			3'd3:FPGA_byte_en[3] = 4'b1111;
			3'd4:FPGA_byte_en[4] = 4'b1111;
			3'd5:FPGA_byte_en[5] = 4'b1111;
			3'd6:FPGA_byte_en[6] = 4'b1111;
			3'd7:FPGA_byte_en[7] = 4'b1111;
		endcase
	end
	
	//FPGA_data = FPGA_data_array[FPGA_req_addr[18:16]];
	case(FPGA_req_addr[18:16]) 
		3'd0:FPGA_data = FPGA_data_array[0];
		3'd1:FPGA_data = FPGA_data_array[1];
		3'd2:FPGA_data = FPGA_data_array[2];
		3'd3:FPGA_data = FPGA_data_array[3];
		3'd4:FPGA_data = FPGA_data_array[4];
		3'd5:FPGA_data = FPGA_data_array[5];
		3'd6:FPGA_data = FPGA_data_array[6];
		3'd7:FPGA_data = FPGA_data_array[7];
	endcase
end

genvar i;
generate
    for(i = 0; i < 4; i = i+1) begin
        blk_mem_gen_0 block_ram( .douta(pci_data_array[i]),.dina(pci_input_data),.wea(pci_byte_en[i]),.addra(pci_req_addr_16),
                                 .doutb(FPGA_data_array[i]),.dinb(FPGA_input_data),.web(FPGA_byte_en[i]),.addrb(FPGA_req_addr_16),
                                 .clka(clk),.clkb(local_clk));
    end
endgenerate

/*
bram_tdp #(32,18) cake(.a_clk(clk),.a_wr(wr_en),.a_addr(pci_req_addr[17:0]),.a_din(pci_input_data),.a_dout(pci_data),
                            .b_clk(clk),.b_wr(FPGA_wr_en),.b_addr(FPGA_req_addr[17:0]),.b_din(FPGA_input_data),.b_dout(FPGA_data));
*/

enum {IDLE,BUSY0, BUSY1}pci_cs,FPGA_cs,pci_ns,FPGA_ns;
logic pci_rd_ready;
logic FPGA_rd_ready;
logic pci_rd_req;
logic FPGA_rd_req;

//assign FPGA_rd_req = 1'b1;
assign pci_rd_req = wr_en;

//assign pci_rd_ready = 1'b1;
assign FPGA_rd_ready = 1'b1;


always_comb begin
    // memory needs a clock
    unique case(pci_cs)
        IDLE: begin
            pci_rd_ready = 1'b1;
            // no incomnig request, stay idle
            pci_ns = (pci_rd_req)? BUSY0:IDLE; 
        end
        BUSY0: begin
            pci_rd_ready = 1'b0;
            pci_ns = BUSY1;
        end
		BUSY1: begin
			pci_rd_ready = 1'b0;
			pci_ns = IDLE;
			
		end
    endcase
end
/* 
   unique case(FPGA_cs)
            IDLE: begin
                FPGA_rd_ready = 1'b0;
                FPGA_ns = (FPGA_rd_req)? BUSY:IDLE; 
            end
            BUSY: begin
                FPGA_rd_ready = 1'b1;
                FPGA_ns = IDLE;
            end
        endcase    
end
*/


always_ff@(posedge clk, negedge rst_n) begin
    if(~rst_n)begin
         pci_cs <= IDLE;
         FPGA_cs <=IDLE;
		 flags <= 32'b0;
        end
    else begin
        pci_cs <= pci_ns;
        FPGA_cs<=FPGA_ns;
		flags <= new_flags;
        end
end
    
	logic [31:0] in_flag, in_flag_out, out_flag_in, out_flag_out;
	logic        flag_we_in, flag_we_out;
	always_comb begin
        new_flags = flags;
        rd_data = pci_data;	
		// incoming instruction
		if((pci_req_addr[18:0] == 19'h7FFFE) && wr_en)begin
		  new_flags = pci_input_data;
		  rd_data = pci_data;
		
		end
		// reading the instruction
		else if((pci_req_addr[18:0] == 19'h7FFFE)&& ~wr_en) begin
			// read operation
				rd_data = flags;
				// clear the flag
		end
		
		else rd_data = pci_data; // set to be memory as usual
		
		// FPGA wants to write to instruction block.
		if(flag_we_out)begin
		      // set the lower 16 
		      new_flags = (flags & 32'hFFFF0000) | (out_flag_out & 32'h0000FFFF);
		
		end
		
		/*
		if((FPGA_req_addr[18:0] == 19'h7FFFE) && FPGA_wr_en) begin
			new_flags = FPGA_input_data;
		end
		else new_flags = flags;
		*/
	end
assign in_flag = flags;
/*
user_FPGA_dummy dut(.clk(clk), .rst_n(rst_n), .rd_ready(FPGA_rd_ready), .rd_req(FPGA_rd_req),
					.write_data(FPGA_input_data),.req_addr(FPGA_req_addr),.rd_data(FPGA_data),
					.pci_input_data(pci_input_data),.pci_req_addr(pci_req_addr),.pci_wr_en(wr_en),
					.FPGA_wr_en(FPGA_wr_en), .out_flag(out_flag), .in_flag(in_flag), .flag_we(flag_we)
					);
*/


clk_wiz_0 clock_gen(.clk_in1(clk),.clk_out1(local_clk));

sync_reg #(32)       deal_out_flag(.clk_A(clk),.clk_B(clk),.rst_n(1'b1),.enable(1'b1),.in(out_flag_in),.out(out_flag_out));
sync_reg #(1)        deal_flag_we(.clk_A(clk),.clk_B(clk),.rst_n(1'b1),.enable(1'b1),.in(flag_we_in),.out(flag_we_out));
sync_reg #(32)       deal_in_flag(.clk_A(local_clk),.clk_B(local_clk),.rst_n(1'b1),.enable(1'b1),.in(in_flag),.out(in_flag_out));

user_interface     dut(.clk(local_clk), .rst_n(rst_n), .rd_ready(FPGA_rd_ready), .rd_req(FPGA_rd_req),
					.write_data(FPGA_input_data),.req_addr(FPGA_req_addr),.rd_data(FPGA_data),
					.pci_input_data(pci_input_data),.pci_req_addr(pci_req_addr),.pci_wr_en(wr_en),
					.FPGA_wr_en(FPGA_wr_en), .out_flag(out_flag_in), .in_flag(in_flag_out), .flag_we(flag_we_in),
					.LEDs(LEDs)
					);


endmodule

module sync_reg#(parameter size =8)
        (input logic clk_A,clk_B, rst_n,enable,
        input logic [size-1:0] in,
		output logic [size-1:0] out);

 (*DONT_TOUCH = "TRUE" *) (*ASYNC_REG = "TRUE" *)logic [1:0][size-1:0] hold;
       
assign out = hold;
// two flip-flops to handle clk.       
 always_ff@(posedge clk_A, negedge rst_n)begin
        if(~rst_n) begin
            hold <= 'd0;
            end
        else if(enable)begin
            hold[0] <= in;
			hold[1] <= hold[0];
        end    
        else begin
            hold <= hold;    
        end
 end

endmodule: sync_reg
