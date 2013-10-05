proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param gui.test TreeTableDev
  create_project -in_memory -part xc7vx485tffg1761-2
  set_property board xilinx.com:virtex7:vc707:2.0 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/vc707_pcie_vivado.data/wt [current_project]
  set_property parent.project_dir /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado [current_project]
  add_files /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/vc707_pcie_vivado.runs/synth_1/vc707_pcie_x8_gen2.dcp
  read_xdc -mode out_of_context -ref vc707_pcie_x8_gen2 -cells inst /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/vc707_pcie_vivado.srcs/sources_1/ip/vc707_pcie_x8_gen2/synth/vc707_pcie_x8_gen2_ooc.xdc
  read_xdc -ref vc707_pcie_x8_gen2 -cells inst /afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/vc707_pcie_vivado.srcs/sources_1/ip/vc707_pcie_x8_gen2/vc707_pcie_x8_gen2/source/vc707_pcie_x8_gen2-PCIE_X1Y0.xdc
  link_design -top vc707_pcie_x8_gen2 -part xc7vx485tffg1761-2
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force vc707_pcie_x8_gen2_opt.dcp
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  place_design 
  catch { report_io -file vc707_pcie_x8_gen2_io_placed.rpt }
  catch { report_clock_utilization -file vc707_pcie_x8_gen2_clock_utilization_placed.rpt }
  catch { report_utilization -file vc707_pcie_x8_gen2_utilization_placed.rpt -pb vc707_pcie_x8_gen2_utilization_placed.pb }
  catch { report_control_sets -verbose -file vc707_pcie_x8_gen2_control_sets_placed.rpt }
  write_checkpoint -force vc707_pcie_x8_gen2_placed.dcp
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  catch { report_drc -file vc707_pcie_x8_gen2_drc_routed.rpt -pb vc707_pcie_x8_gen2_drc_routed.pb }
  catch { report_power -file vc707_pcie_x8_gen2_power_routed.rpt -pb vc707_pcie_x8_gen2_power_summary_routed.pb }
  catch { report_route_status -file vc707_pcie_x8_gen2_route_status.rpt -pb vc707_pcie_x8_gen2_route_status.pb }
  catch { report_timing_summary -file vc707_pcie_x8_gen2_timing_summary_routed.rpt -pb vc707_pcie_x8_gen2_timing_summary_routed.pb }
  write_checkpoint -force vc707_pcie_x8_gen2_routed.dcp
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

