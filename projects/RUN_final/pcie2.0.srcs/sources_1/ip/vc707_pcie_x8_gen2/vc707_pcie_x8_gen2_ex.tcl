#-------------------------------------------------------------
# Generated Example Tcl script for IP 'vc707_pcie_x8_gen2' (xilinx.com:ip:pcie_7x:2.1)
#-------------------------------------------------------------

# Create project
create_project -name vc707_pcie_x8_gen2_example -force
set_property part xc7vx485tffg1761-2 [current_project]
set_property target_language verilog [current_project]

# Import the original IP
import_ip -files {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2.xci} -name vc707_pcie_x8_gen2

# Generate the IP
reset_target {all} [get_ips vc707_pcie_x8_gen2]
proc _filter_supported_targets {targets ip} { set all [get_property SUPPORTED_TARGETS $ip]; set res {}; foreach a_target $targets { lappend res {*}[lsearch -all -inline -nocase $all $a_target] }; return $res }
generate_target [_filter_supported_targets {instantiation_template synthesis simulation} [get_ips vc707_pcie_x8_gen2]] [get_ips vc707_pcie_x8_gen2]

# Add example synthesis HDL files
add_files -scan_for_includes -fileset [current_fileset] { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/example_design/EP_MEM.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/example_design/PIO_EP_MEM_ACCESS.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/example_design/PIO_EP.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/example_design/PIO_RX_ENGINE.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/example_design/PIO_TO_CTRL.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/example_design/PIO_TX_ENGINE.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/example_design/PIO.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/example_design/pcie_app_7x.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/example_design/xilinx_pcie_2_1_ep_7x.v} }

# Add example XDC files
add_files -fileset [current_fileset -constrset] { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/example_design/xilinx_pcie_7x_ep_x8g2_VC707.xdc} }

# Add example simulation files
if { [catch {current_fileset -simset} exc] } {
  # Create default simset
  create_fileset -simset sim_1
}
add_files -scan_for_includes -fileset [current_fileset -simset] { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/simulation/dsport/pci_exp_expect_tasks.vh} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/simulation/dsport/pci_exp_usrapp_cfg.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/simulation/dsport/pci_exp_usrapp_com.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/simulation/dsport/pci_exp_usrapp_pl.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/simulation/dsport/pci_exp_usrapp_rx.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/simulation/dsport/pci_exp_usrapp_tx.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/simulation/functional/sys_clk_gen_ds.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/simulation/functional/sys_clk_gen.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/simulation/dsport/pcie_axi_trn_bridge.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/simulation/functional/board.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/simulation/functional/board_common.vh} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/simulation/tests/sample_tests1.vh} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/simulation/tests/tests.vh} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/simulation/dsport/pcie_2_1_rport_7x.v} } { {c:/Users/z1701Ez/Dropbox/18-545/project/pcie2.0/pcie2.0.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/simulation/dsport/xilinx_pcie_2_1_rport_7x.v} }

# Import all files while preserving hierarchy
import_files

# Set top
set_property TOP [lindex [find_top] 0] [current_fileset]

