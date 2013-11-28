CC=vcs

CFLAGS=-sverilog -R -debug_all #+v2k #-assert filter -assert enable_diag
DFLAGS=-sverilog -debug_all

all: user_FPGA_format.sv address_translator.sv user_FPGA_test.sv window_handler.sv window_holder.sv ncc.sv template_handler.sv testBenches.sv
	$(CC) $(CFLAGS) user_FPGA_format.sv address_translator.sv user_FPGA_test.sv window_handler.sv window_holder.sv ncc.sv template_handler.sv testBenches.sv


clean:
	rm -rf simv
	rm -rf simv.daidir
	rm -rf csrc
	rm -rf ucli.key
	rm -rf simv.vdb
	rm -rf DVEfiles
	rm -rf inter.vpd
