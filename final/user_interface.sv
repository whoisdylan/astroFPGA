
module user_interface(clk,rst_n,  rd_ready, rd_req, rd_data,FPGA_wr_en,
					write_data,req_addr, pci_input_data, pci_req_addr, pci_wr_en,
					in_flag, flag_we, out_flag, greatestNCCLog2, greatestWindowIndex);
	
	input logic			 clk, rst_n;
	input logic [31:0] 	 rd_data;
	input logic			 rd_ready;
	input logic [31:0]	 pci_input_data;
	input logic [20:0]	 pci_req_addr;
	input logic			 pci_wr_en;
	input logic [31:0]   in_flag;
	
	output logic         flag_we;
	output logic [31:0]  out_flag;
	output	logic		 rd_req;     //request to read, or write.
	output  logic [31:0] write_data;
	output  logic [20:0] req_addr;
	output  logic 	 	 FPGA_wr_en;
	
	output logic [31:-32] greatestNCCLog2;
	output logic [11:0]	 greatestWindowIndex;
	//testing signals.
	
	// to user.
	logic 			ready_2_start;
	logic [31:0]	user_rd_data;	// read data to send to user.
	
	// from user.
	logic			req;   // requesting a read or write operation.
	logic			rd_wr;		// deterimine if read or write. read = 0, write = 1
	logic	[20:0]	user_req_addr;	// requested address.
	logic 	[31:0]	user_write_data;	// data to write to memory.
	logic			set_done;	// complete a set.
	
	logic [6:0]		row,col;
	logic			tem_win;
	logic			frame, store_frame; 		// 0 or 1.
	logic [7:0]		set;
	logic [20:0]	user_rd_req_addr;
	logic [20:0]	user_wr_req_addr;
	logic [1:0]		wr_index;
	logic			inst;				//select the instruction register.

	// deal with endianess
	assign user_rd_data = {rd_data[7:0], rd_data[15:8],rd_data[23:16], rd_data[31:24]};
	assign {write_data[7:0], write_data[15:8], write_data[23:16], write_data[31:24]} = user_write_data;
	
	
user_FPGA_format chop( clk, rst_n, req, rd_wr, user_write_data,user_rd_data,
 set_done, row, col, tem_win, ready_2_start, greatestNCCLog2, greatestWindowIndex, set,wr_index, inst);

address_translator translator(row, col, tem_win,set,user_rd_req_addr, inst);
	
assign user_req_addr = (rd_wr)? user_wr_req_addr: user_rd_req_addr;
assign user_wr_req_addr = 21'h03CF96 + {19'b0 ,wr_index} + {11'b0,set,2'b00}; //set *4
	
	enum {INIT, WAIT, READ, WRITE, DONE=3'b100} cs,ns;
    	
    	always_comb begin
    		rd_req = 1'b0;
    		FPGA_wr_en = 1'b0;
    		flag_we = 1'b0;
    		out_flag = 32'b0;
			ready_2_start = 1'b0;
    		ns = cs;
			req_addr = user_req_addr;
    		case(cs)
    			INIT:begin // waiting for data transfer to complete, keep reading flag.
    			// there's a write operation to the flag area. find out the instruction.
    				if(in_flag == 32'h0001_0000) begin
    					    out_flag = 32'h0000_0002;
    					    flag_we = 1'b1;
    						req_addr = 21'b0;
    						ns = WAIT;
							if(store_frame == 'd0) begin
								frame = 'd1;
							end
							else begin
								frame = 'd0;
							end
    				    end
    				else begin
    				    ns = INIT;
    			    end
					// not ready to start yet
					ready_2_start = 1'b0;
    			end
				WAIT: begin
				
						if(req&&rd_wr) FPGA_wr_en =1'b1; // next operation is write
						
						ready_2_start =1'b1;
						if(req) ns = (rd_wr)? WRITE:READ;
						else ns = WAIT;
						if(set_done) begin
							ns = DONE;
							ready_2_start = 1'b0;
						end

				end
				READ: begin
						ready_2_start =1'b1;
						if(req&&rd_wr) FPGA_wr_en =1'b1; // next operation is write
						
						if(set_done) begin
							ns = DONE;
							ready_2_start = 1'b0;
						end
						else if(req) ns = (rd_wr)? WRITE:READ;
						else ns = WAIT;
				end
				
				WRITE: begin
						ready_2_start =1'b1;
						if(req&&rd_wr) FPGA_wr_en =1'b1; // next operation is write
						
						if(set_done)begin
							ns = DONE;
							ready_2_start = 1'b0;
						end
						else if(req) ns = (rd_wr)? WRITE:READ;
						else ns = WAIT;
				end
				
				DONE: begin
					ready_2_start =1'b0;
					req_addr = {2'b00,19'h7FFFE};
    				flag_we = 1'b1;
    				out_flag = 32'h0000_0004;
					ns = INIT;
				end	
    	endcase
    end
    	always_ff@(posedge clk, negedge rst_n)begin
    		if(~rst_n)begin
    			cs <= INIT;
				store_frame <= 'd1;
    		end
    		else begin
    			cs <= ns;
				store_frame <= frame;
    		end
    	end
    endmodule: user_interface
