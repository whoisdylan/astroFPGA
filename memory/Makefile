CC=vcs

CFLAGS=-sverilog -R -debug_all #+v2k #-assert filter -assert enable_diag
DFLAGS=-sverilog -debug_all

all: cyclicBuffers.sv tests/testBenches.sv
	$(CC) $(CFLAGS) tests/testBenches.sv cyclicBuffers.sv

clean:
	rm -rf simv
	rm -rf simv.daidir
	rm -rf csrc
	rm -rf ucli.key
	rm -rf simv.vdb
	rm -rf DVEfiles
	rm -rf inter.vpd
