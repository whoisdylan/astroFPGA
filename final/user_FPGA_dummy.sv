
module user_FPGA_dummy(clk,rst_n,  rd_ready, rd_req, rd_data,FPGA_wr_en,
					write_data,req_addr, pci_input_data, pci_req_addr, pci_wr_en,
					in_flag, flag_we, out_flag);
	
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
	
	logic [20:0] 	 addr_counter, new_addr_counter;
	logic [31:0]	 store_data, new_store_data, progress_counter, new_progress_counter;
	
enum {WAITING, PROCESS0,PROCESS0_1,PROCESS1,PROCESS2, DONE0} cs,ns;
	
	always_comb begin
		rd_req = 1'b0;
		new_addr_counter = addr_counter;
		new_store_data = store_data;
		new_progress_counter = progress_counter;
		FPGA_wr_en = 1'b0;
		flag_we = 1'b0;
		write_data = 32'h0;
		req_addr = 21'b0;
		out_flag = 32'b0;
		ns = cs;
		case(cs)
			WAITING:begin // waiting for data transfer to complete, keep reading flag.
			// there's a write operation to the flag area. find out the instruction.
				if((pci_req_addr == {2'b00,19'h7FFFE})&& pci_wr_en && (pci_input_data == 32'h0001_0000)) begin
					    out_flag = 32'h0000_0002;
					    flag_we = 1'b1;
						new_addr_counter = 21'b0; // set address to 0;
						req_addr = 21'b0;
						ns = PROCESS0;
				    end
				else begin
				    ns = WAITING;
			        new_addr_counter = addr_counter;
			    end
			end
			PROCESS0: begin // address is set up, read out the data.
				rd_req = 1'b1; // set up request flag.
				req_addr = addr_counter;
				new_store_data = rd_data;
				ns = PROCESS0_1;
				//if(rd_ready) ns = PROCESS0; // waiting on ram, stay here.
			end
			PROCESS0_1:begin
			    rd_req =1'b1; // 1 clock cycle memory access delay.
			    req_addr = addr_counter;
			    new_store_data = rd_data;
			 ns = PROCESS1;
			end
			PROCESS1: begin //increment the value in the buffer register.
				req_addr = addr_counter;
				rd_req = 1'b0; //set up the request flag.
				
				{new_store_data[7:0], new_store_data[15:8],new_store_data[23:16],new_store_data[31:24]} = {store_data[7:0], store_data[15:8],store_data[23:16],store_data[31:24]} + 32'b1;
			
				ns = PROCESS2;
			end
			PROCESS2: begin //write out the data to ram.
				rd_req = 1'b1;
				write_data = store_data;
				req_addr = addr_counter;
				FPGA_wr_en = 1'b1; // enable write operation to that address.
				new_progress_counter = progress_counter +'b1; // increment element modified.
				ns = (progress_counter == 21'h03CF96)? DONE0:PROCESS0; //h3CF96 = 999000 in dec
				new_addr_counter = addr_counter +'d1;
				//if(rd_ready) begin 
				//	ns = PROCESS2; // waiting on ram, stay here.
				//	new_progress_counter = progress_counter;
				//end
			end

			DONE0: begin // write operation completed. Set the flag and proceed to WAITING.
				// clear all data
				new_addr_counter = 21'b0;
				new_store_data = 32'b0;
				new_progress_counter = 'h0;
				req_addr = {2'b00,19'h7FFFFE};
				write_data = 32'b0010;
				flag_we = 1'b1;
				out_flag = 32'h0000_0004;
			ns = WAITING;
			end
		endcase
	end
	
	
	
	always_ff@(posedge clk, negedge rst_n)begin
		if(~rst_n)begin
			cs <= WAITING;
			addr_counter<= 21'b00;
			store_data <= 32'b0;
			progress_counter <=32'b0;
		end
		else begin
			cs <= ns;
			addr_counter <= new_addr_counter;
			store_data <= new_store_data;
			progress_counter <= new_progress_counter;
		end
	end
endmodule: user_FPGA_dummy