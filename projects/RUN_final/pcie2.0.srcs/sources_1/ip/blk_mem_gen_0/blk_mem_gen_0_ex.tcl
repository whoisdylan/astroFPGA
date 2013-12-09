#-------------------------------------------------------------
# Generated Example Tcl script for IP 'blk_mem_gen_0' (xilinx.com:ip:blk_mem_gen:8.0)
#-------------------------------------------------------------

# Create project
create_project -name blk_mem_gen_0_example -force
set_property part xc7vx485tffg1761-2 [current_project]
set_property target_language verilog [current_project]

# Import the original IP
import_ip -files {/afs/ece.cmu.edu/usr/gcharnma/Private/18-545/test/pcie2.0_new/pcie2.0.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0.xci} -name blk_mem_gen_0

# Generate the IP
reset_target {all} [get_ips blk_mem_gen_0]
proc _filter_supported_targets {targets ip} { set all [get_property SUPPORTED_TARGETS $ip]; set res {}; foreach a_target $targets { lappend res {*}[lsearch -all -inline -nocase $all $a_target] }; return $res }
generate_target [_filter_supported_targets {instantiation_template synthesis simulation} [get_ips blk_mem_gen_0]] [get_ips blk_mem_gen_0]

# Add example synthesis HDL files
add_files -scan_for_includes -fileset [current_fileset] { {/afs/ece.cmu.edu/usr/gcharnma/Private/18-545/test/pcie2.0_new/pcie2.0.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0/example_design/blk_mem_gen_0_exdes.vhd} }

# Add example XDC files
add_files -fileset [current_fileset -constrset] { {/afs/ece.cmu.edu/usr/gcharnma/Private/18-545/test/pcie2.0_new/pcie2.0.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0/example_design/blk_mem_gen_0_exdes.xdc} }

# Add example simulation files
if { [catch {current_fileset -simset} exc] } {
  # Create default simset
  create_fileset -simset sim_1
}
add_files -scan_for_includes -fileset [current_fileset -simset] { {/afs/ece.cmu.edu/usr/gcharnma/Private/18-545/test/pcie2.0_new/pcie2.0.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0/simulation/bmg_tb_pkg.vhd} } { {/afs/ece.cmu.edu/usr/gcharnma/Private/18-545/test/pcie2.0_new/pcie2.0.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0/simulation/random.vhd} } { {/afs/ece.cmu.edu/usr/gcharnma/Private/18-545/test/pcie2.0_new/pcie2.0.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0/simulation/addr_gen.vhd} } { {/afs/ece.cmu.edu/usr/gcharnma/Private/18-545/test/pcie2.0_new/pcie2.0.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0/simulation/data_gen.vhd} } { {/afs/ece.cmu.edu/usr/gcharnma/Private/18-545/test/pcie2.0_new/pcie2.0.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0/simulation/checker.vhd} } { {/afs/ece.cmu.edu/usr/gcharnma/Private/18-545/test/pcie2.0_new/pcie2.0.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0/simulation/bmg_stim_gen.vhd} } { {/afs/ece.cmu.edu/usr/gcharnma/Private/18-545/test/pcie2.0_new/pcie2.0.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0/simulation/blk_mem_gen_0_synth.vhd} } { {/afs/ece.cmu.edu/usr/gcharnma/Private/18-545/test/pcie2.0_new/pcie2.0.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0/simulation/blk_mem_gen_0_tb.vhd} }

# Import all files while preserving hierarchy
import_files

# Set top
set_property TOP [lindex [find_top] 0] [current_fileset]

