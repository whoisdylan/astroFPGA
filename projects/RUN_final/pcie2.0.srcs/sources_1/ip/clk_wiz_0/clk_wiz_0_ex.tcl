#-------------------------------------------------------------
# Generated Example Tcl script for IP 'clk_wiz_0' (xilinx.com:ip:clk_wiz:5.0)
#-------------------------------------------------------------

# Create project
create_project -name clk_wiz_0_example -force
set_property part xc7vx485tffg1761-2 [current_project]
set_property target_language verilog [current_project]

# Import the original IP
import_ip -files {/afs/ece.cmu.edu/usr/gcharnma/Private/18-545/test/pcie2.0_new/pcie2.0.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci} -name clk_wiz_0

# Generate the IP
reset_target {all} [get_ips clk_wiz_0]
proc _filter_supported_targets {targets ip} { set all [get_property SUPPORTED_TARGETS $ip]; set res {}; foreach a_target $targets { lappend res {*}[lsearch -all -inline -nocase $all $a_target] }; return $res }
generate_target [_filter_supported_targets {instantiation_template synthesis simulation} [get_ips clk_wiz_0]] [get_ips clk_wiz_0]

# Add example synthesis HDL files
add_files -scan_for_includes -fileset [current_fileset] { {/afs/ece.cmu.edu/usr/gcharnma/Private/18-545/test/pcie2.0_new/pcie2.0.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0/example_design/clk_wiz_0_exdes.v} }

# Add example XDC files
add_files -fileset [current_fileset -constrset] { {/afs/ece.cmu.edu/usr/gcharnma/Private/18-545/test/pcie2.0_new/pcie2.0.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0/example_design/clk_wiz_0_exdes.xdc} }

# Add example simulation files
if { [catch {current_fileset -simset} exc] } {
  # Create default simset
  create_fileset -simset sim_1
}
add_files -scan_for_includes -fileset [current_fileset -simset] { {/afs/ece.cmu.edu/usr/gcharnma/Private/18-545/test/pcie2.0_new/pcie2.0.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0/simulation/clk_wiz_0_tb.v} }

# Import all files while preserving hierarchy
import_files

# Set top
set_property TOP [lindex [find_top] 0] [current_fileset]

