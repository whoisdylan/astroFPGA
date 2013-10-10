Date: September 1, 2007

This directory contains working example bitstreams for use with the ML555
board.

routed_x4_verilog_20.bit - 4-lane design using Verilog PIO design example.
routed_x8_verilog_20.bit - 8-lane design using Verilog PIO design example.
routed_x4_vhdl_20.bit    - 4-lane design using VHDL PIO design example.
routed_x8_vhdl_20.bit    - 8-lane design using VHDL PIO design example.

PROM_FILES - This sub-directory contains MCS files that can be loaded on the
             ML555 PROM.

Block_Plus_x4_x8_verilog.mcs - 4-lane and 8-lane Verilog example.
Block_Plus_x4_x8_vhdl.mcs    - 4-lane and 8-lane VHDL example.

Note that the Verilog and VHDL designs are functionally equivalent. The bitstreams
were created following the recommendations in XAPP 1022 using 9.2i SP2 IP Update 1
and v1.4 of the Block Plus Endpoint Wrapper.

For information on programming the ML555 card, please refer to the User Guide at:
http://direct.xilinx.com/bvdocs/userguides/ug201.pdf