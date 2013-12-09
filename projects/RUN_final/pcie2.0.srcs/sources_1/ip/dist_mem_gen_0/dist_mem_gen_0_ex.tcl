#-------------------------------------------------------------
# Generated Example Tcl script for IP 'dist_mem_gen_0' (xilinx.com:ip:dist_mem_gen:8.0)
#-------------------------------------------------------------

# Create project
create_project -name dist_mem_gen_0_example -force
set_property part xc7vx485tffg1761-2 [current_project]
set_property target_language verilog [current_project]

# Import the original IP
import_ip -files {c:/Users/z1701Ez/Dropbox/18-545/pcie2.0/pcie2.0.srcs/sources_1/ip/dist_mem_gen_0/dist_mem_gen_0.xci} -name dist_mem_gen_0

# Generate the IP
reset_target {all} [get_ips dist_mem_gen_0]
proc _filter_supported_targets {targets ip} { set all [get_property SUPPORTED_TARGETS $ip]; set res {}; foreach a_target $targets { lappend res {*}[lsearch -all -inline -nocase $all $a_target] }; return $res }
generate_target [_filter_supported_targets {instantiation_template synthesis simulation} [get_ips dist_mem_gen_0]] [get_ips dist_mem_gen_0]

# Add example synthesis HDL files
add_files -scan_for_includes -fileset [current_fileset] { {c:/Users/z1701Ez/Dropbox/18-545/pcie2.0/pcie2.0.srcs/sources_1/ip/dist_mem_gen_0/dist_mem_gen_0/example_design/dist_mem_gen_0_exdes.vhd} }

# Add example XDC files
add_files -fileset [current_fileset -constrset] { {c:/Users/z1701Ez/Dropbox/18-545/pcie2.0/pcie2.0.srcs/sources_1/ip/dist_mem_gen_0/dist_mem_gen_0/example_design/dist_mem_gen_0_exdes.xdc} }

# Add example simulation files
if { [catch {current_fileset -simset} exc] } {
  # Create default simset
  create_fileset -simset sim_1
}
add_files -scan_for_includes -fileset [current_fileset -simset] { {c:/Users/z1701Ez/Dropbox/18-545/pcie2.0/pcie2.0.srcs/sources_1/ip/dist_mem_gen_0/dist_mem_gen_0/simulation/dist_mem_gen_0_tb_pkg.vhd} } { {c:/Users/z1701Ez/Dropbox/18-545/pcie2.0/pcie2.0.srcs/sources_1/ip/dist_mem_gen_0/dist_mem_gen_0/simulation/dist_mem_gen_0_tb_rng.vhd} } { {c:/Users/z1701Ez/Dropbox/18-545/pcie2.0/pcie2.0.srcs/sources_1/ip/dist_mem_gen_0/dist_mem_gen_0/simulation/dist_mem_gen_0_tb_dgen.vhd} } { {c:/Users/z1701Ez/Dropbox/18-545/pcie2.0/pcie2.0.srcs/sources_1/ip/dist_mem_gen_0/dist_mem_gen_0/simulation/dist_mem_gen_0_tb_agen.vhd} } { {c:/Users/z1701Ez/Dropbox/18-545/pcie2.0/pcie2.0.srcs/sources_1/ip/dist_mem_gen_0/dist_mem_gen_0/simulation/dist_mem_gen_0_tb_checker.vhd} } { {c:/Users/z1701Ez/Dropbox/18-545/pcie2.0/pcie2.0.srcs/sources_1/ip/dist_mem_gen_0/dist_mem_gen_0/simulation/dist_mem_gen_0_tb_stim_gen.vhd} } { {c:/Users/z1701Ez/Dropbox/18-545/pcie2.0/pcie2.0.srcs/sources_1/ip/dist_mem_gen_0/dist_mem_gen_0/simulation/dist_mem_gen_0_tb_synth.vhd} } { {c:/Users/z1701Ez/Dropbox/18-545/pcie2.0/pcie2.0.srcs/sources_1/ip/dist_mem_gen_0/dist_mem_gen_0/simulation/dist_mem_gen_0_tb.vhd} }

# Import all files while preserving hierarchy
import_files

# Set top
set_property TOP [lindex [find_top] 0] [current_fileset]

