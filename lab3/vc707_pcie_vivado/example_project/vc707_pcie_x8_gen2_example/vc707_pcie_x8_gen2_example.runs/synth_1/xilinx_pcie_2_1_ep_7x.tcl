# 
# Synthesis run script generated by Vivado
# 

  set_param gui.test TreeTableDev
create_project -in_memory -part xc7vx485tffg1761-2
set_param project.compositeFile.enableAutoGeneration 0

read_ip /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2.xci
set_property used_in_implementation false [get_files -all /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/source/vc707_pcie_x8_gen2-PCIE_X1Y0.xdc]
set_property used_in_implementation false [get_files -all /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.srcs/sources_1/ip/vc707_pcie_x8_gen2/synth/vc707_pcie_x8_gen2_ooc.xdc]
set_property is_locked true [get_files /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2.xci]

read_verilog {
  /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.srcs/sources_1/imports/example_design/EP_MEM.v
  /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.srcs/sources_1/imports/example_design/PIO_TX_ENGINE.v
  /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.srcs/sources_1/imports/example_design/PIO_RX_ENGINE.v
  /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.srcs/sources_1/imports/example_design/PIO_EP_MEM_ACCESS.v
  /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.srcs/sources_1/imports/example_design/PIO_TO_CTRL.v
  /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.srcs/sources_1/imports/example_design/PIO_EP.v
  /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.srcs/sources_1/imports/example_design/PIO.v
  /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.srcs/sources_1/imports/example_design/pcie_app_7x.v
  /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.srcs/sources_1/imports/example_design/xilinx_pcie_2_1_ep_7x.v
}
read_xdc /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.srcs/constrs_1/imports/example_design/xilinx_pcie_7x_ep_x8g2_VC707.xdc
set_property used_in_implementation false [get_files /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.srcs/constrs_1/imports/example_design/xilinx_pcie_7x_ep_x8g2_VC707.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.data/wt [current_project]
set_property parent.project_dir /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example [current_project]
synth_design -top xilinx_pcie_2_1_ep_7x -part xc7vx485tffg1761-2
write_checkpoint xilinx_pcie_2_1_ep_7x.dcp
report_utilization -file xilinx_pcie_2_1_ep_7x_utilization_synth.rpt -pb xilinx_pcie_2_1_ep_7x_utilization_synth.pb
