
6
Command: %s
53*	vivadotcl2
place_designZ4-113
x
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
Implementation2
	xc7vx485tZ17-347
h
0Got license for feature '%s' and/or device '%s'
310*common2
Implementation2
	xc7vx485tZ17-349
U
,Running DRC as a precondition to command %s
22*	vivadotcl2
place_designZ4-22
5
Running DRC with %s threads
24*drc2
4Z23-27
;
DRC finished with %s
79*	vivadotcl2

0 ErrorsZ4-198
\
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199
:

Starting %s Task
103*constraints2
PlacerZ18-103
b
BMultithreading enabled for place_design using a maximum of %s CPUs12*	placeflow2
4Z30-611
I

Phase %s%s
101*constraints2
1 2
Placer InitializationZ18-101
³
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2
00:00:00.012
00:00:00.012

1083.9692
0.000Z17-268
R

Phase %s%s
101*constraints2
1.1 2
Mandatory Logic OptimizationZ18-101
1
Pushed %s inverter(s).
98*opt2
0Z31-138
I
=Phase 1.1 Mandatory Logic Optimization | Checksum: 1048b54bd
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.20 ; elapsed = 00:00:00.20 . Memory (MB): peak = 1083.969 ; gain = 0.000
]

Phase %s%s
101*constraints2
1.2 2)
'Build Super Logic Region (SLR) DatabaseZ18-101
T
HPhase 1.2 Build Super Logic Region (SLR) Database | Checksum: 1048b54bd
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.35 ; elapsed = 00:00:00.35 . Memory (MB): peak = 1083.969 ; gain = 0.000
E

Phase %s%s
101*constraints2
1.3 2
Add ConstraintsZ18-101
<
0Phase 1.3 Add Constraints | Checksum: 1048b54bd
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.35 ; elapsed = 00:00:00.35 . Memory (MB): peak = 1083.969 ; gain = 0.000
R

Phase %s%s
101*constraints2
1.4 2
Routing Based Site ExclusionZ18-101
I
=Phase 1.4 Routing Based Site Exclusion | Checksum: 1048b54bd
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.35 ; elapsed = 00:00:00.35 . Memory (MB): peak = 1083.969 ; gain = 0.000
B

Phase %s%s
101*constraints2
1.5 2
Build MacrosZ18-101
8
,Phase 1.5 Build Macros | Checksum: 826b98b5
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.72 ; elapsed = 00:00:00.73 . Memory (MB): peak = 1083.969 ; gain = 0.000
V

Phase %s%s
101*constraints2
1.6 2"
 Implementation Feasibility checkZ18-101
L
@Phase 1.6 Implementation Feasibility check | Checksum: 826b98b5
*common
t

%s
*constraints2]
[Time (s): cpu = 00:00:01 ; elapsed = 00:00:01 . Memory (MB): peak = 1083.969 ; gain = 0.000
E

Phase %s%s
101*constraints2
1.7 2
Pre-Place CellsZ18-101
;
/Phase 1.7 Pre-Place Cells | Checksum: 826b98b5
*common
t

%s
*constraints2]
[Time (s): cpu = 00:00:01 ; elapsed = 00:00:01 . Memory (MB): peak = 1083.969 ; gain = 0.000
h

Phase %s%s
101*constraints2
1.8 24
2IO Placement/ Clock Placement/ Build Placer DeviceZ18-101
ö
IO Placement failed due to overutilization. This design contains %s I/O ports
 while the target %s, contains only %s available user I/O. The target device has %s usable I/O pins of which %s are already occupied by user-locked I/Os.
 To rectify this issue:
 1. Ensure you are targeting the correct device and package.  Select a larger device or different package if necessary.
 2. Check the top-level ports of the design to ensure the correct number of ports are specified.
 3. Consider design changes to reduce the number of I/Os necessary.
415*place2
10892#
! device: 7vx485t package: ffg17612
7002
7002
0Z30-415
d
Instance %s (%s) is not placed
68*place2#
cfg_aer_ecrc_check_en_OBUF_inst2
OBUF8Z30-68
b
Instance %s (%s) is not placed
68*place2!
cfg_aer_ecrc_gen_en_OBUF_inst2
OBUF8Z30-68
j
Instance %s (%s) is not placed
68*place2)
%cfg_aer_interrupt_msgnum_IBUF[0]_inst2
IBUF8Z30-68
j
Instance %s (%s) is not placed
68*place2)
%cfg_aer_interrupt_msgnum_IBUF[1]_inst2
IBUF8Z30-68
j
Instance %s (%s) is not placed
68*place2)
%cfg_aer_interrupt_msgnum_IBUF[2]_inst2
IBUF8Z30-68
j
Instance %s (%s) is not placed
68*place2)
%cfg_aer_interrupt_msgnum_IBUF[3]_inst2
IBUF8Z30-68
j
Instance %s (%s) is not placed
68*place2)
%cfg_aer_interrupt_msgnum_IBUF[4]_inst2
IBUF8Z30-68
p
Instance %s (%s) is not placed
68*place2/
+cfg_aer_rooterr_corr_err_received_OBUF_inst2
OBUF8Z30-68
t
Instance %s (%s) is not placed
68*place23
/cfg_aer_rooterr_corr_err_reporting_en_OBUF_inst2
OBUF8Z30-68
q
Instance %s (%s) is not placed
68*place20
,cfg_aer_rooterr_fatal_err_received_OBUF_inst2
OBUF8Z30-68
u
Instance %s (%s) is not placed
68*place24
0cfg_aer_rooterr_fatal_err_reporting_en_OBUF_inst2
OBUF8Z30-68
u
Instance %s (%s) is not placed
68*place24
0cfg_aer_rooterr_non_fatal_err_received_OBUF_inst2
OBUF8Z30-68
y
Instance %s (%s) is not placed
68*place28
4cfg_aer_rooterr_non_fatal_err_reporting_en_OBUF_inst2
OBUF8Z30-68
a
Instance %s (%s) is not placed
68*place2 
cfg_bridge_serr_en_OBUF_inst2
OBUF8Z30-68
`
Instance %s (%s) is not placed
68*place2
cfg_bus_number_OBUF[0]_inst2
OBUF8Z30-68
`
Instance %s (%s) is not placed
68*place2
cfg_bus_number_OBUF[1]_inst2
OBUF8Z30-68
`
Instance %s (%s) is not placed
68*place2
cfg_bus_number_OBUF[2]_inst2
OBUF8Z30-68
`
Instance %s (%s) is not placed
68*place2
cfg_bus_number_OBUF[3]_inst2
OBUF8Z30-68
`
Instance %s (%s) is not placed
68*place2
cfg_bus_number_OBUF[4]_inst2
OBUF8Z30-68
`
Instance %s (%s) is not placed
68*place2
cfg_bus_number_OBUF[5]_inst2
OBUF8Z30-68
`
Instance %s (%s) is not placed
68*place2
cfg_bus_number_OBUF[6]_inst2
OBUF8Z30-68
`
Instance %s (%s) is not placed
68*place2
cfg_bus_number_OBUF[7]_inst2
OBUF8Z30-68
]
Instance %s (%s) is not placed
68*place2
cfg_command_OBUF[0]_inst2
OBUF8Z30-68
^
Instance %s (%s) is not placed
68*place2
cfg_command_OBUF[10]_inst2
OBUF8Z30-68
^
Instance %s (%s) is not placed
68*place2
cfg_command_OBUF[11]_inst2
OBUF8Z30-68
^
Instance %s (%s) is not placed
68*place2
cfg_command_OBUF[12]_inst2
OBUF8Z30-68
^
Instance %s (%s) is not placed
68*place2
cfg_command_OBUF[13]_inst2
OBUF8Z30-68
^
Instance %s (%s) is not placed
68*place2
cfg_command_OBUF[14]_inst2
OBUF8Z30-68
^
Instance %s (%s) is not placed
68*place2
cfg_command_OBUF[15]_inst2
OBUF8Z30-68
]
Instance %s (%s) is not placed
68*place2
cfg_command_OBUF[1]_inst2
OBUF8Z30-68
]
Instance %s (%s) is not placed
68*place2
cfg_command_OBUF[2]_inst2
OBUF8Z30-68
]
Instance %s (%s) is not placed
68*place2
cfg_command_OBUF[3]_inst2
OBUF8Z30-68
]
Instance %s (%s) is not placed
68*place2
cfg_command_OBUF[4]_inst2
OBUF8Z30-68
]
Instance %s (%s) is not placed
68*place2
cfg_command_OBUF[5]_inst2
OBUF8Z30-68
]
Instance %s (%s) is not placed
68*place2
cfg_command_OBUF[6]_inst2
OBUF8Z30-68
]
Instance %s (%s) is not placed
68*place2
cfg_command_OBUF[7]_inst2
OBUF8Z30-68
]
Instance %s (%s) is not placed
68*place2
cfg_command_OBUF[8]_inst2
OBUF8Z30-68
]
Instance %s (%s) is not placed
68*place2
cfg_command_OBUF[9]_inst2
OBUF8Z30-68
_
Instance %s (%s) is not placed
68*place2
cfg_dcommand2_OBUF[0]_inst2
OBUF8Z30-68
`
Instance %s (%s) is not placed
68*place2
cfg_dcommand2_OBUF[10]_inst2
OBUF8Z30-68
`
Instance %s (%s) is not placed
68*place2
cfg_dcommand2_OBUF[11]_inst2
OBUF8Z30-68
`
Instance %s (%s) is not placed
68*place2
cfg_dcommand2_OBUF[12]_inst2
OBUF8Z30-68
`
Instance %s (%s) is not placed
68*place2
cfg_dcommand2_OBUF[13]_inst2
OBUF8Z30-68
`
Instance %s (%s) is not placed
68*place2
cfg_dcommand2_OBUF[14]_inst2
OBUF8Z30-68
`
Instance %s (%s) is not placed
68*place2
cfg_dcommand2_OBUF[15]_inst2
OBUF8Z30-68
_
Instance %s (%s) is not placed
68*place2
cfg_dcommand2_OBUF[1]_inst2
OBUF8Z30-68
_
Instance %s (%s) is not placed
68*place2
cfg_dcommand2_OBUF[2]_inst2
OBUF8Z30-68
_
Instance %s (%s) is not placed
68*place2
cfg_dcommand2_OBUF[3]_inst2
OBUF8Z30-68
_
Instance %s (%s) is not placed
68*place2
cfg_dcommand2_OBUF[4]_inst2
OBUF8Z30-68
_
Instance %s (%s) is not placed
68*place2
cfg_dcommand2_OBUF[5]_inst2
OBUF8Z30-68
_
Instance %s (%s) is not placed
68*place2
cfg_dcommand2_OBUF[6]_inst2
OBUF8Z30-68
_
Instance %s (%s) is not placed
68*place2
cfg_dcommand2_OBUF[7]_inst2
OBUF8Z30-68
_
Instance %s (%s) is not placed
68*place2
cfg_dcommand2_OBUF[8]_inst2
OBUF8Z30-68
_
Instance %s (%s) is not placed
68*place2
cfg_dcommand2_OBUF[9]_inst2
OBUF8Z30-68
^
Instance %s (%s) is not placed
68*place2
cfg_dcommand_OBUF[0]_inst2
OBUF8Z30-68
_
Instance %s (%s) is not placed
68*place2
cfg_dcommand_OBUF[10]_inst2
OBUF8Z30-68
_
Instance %s (%s) is not placed
68*place2
cfg_dcommand_OBUF[11]_inst2
OBUF8Z30-68
_
Instance %s (%s) is not placed
68*place2
cfg_dcommand_OBUF[12]_inst2
OBUF8Z30-68
_
Instance %s (%s) is not placed
68*place2
cfg_dcommand_OBUF[13]_inst2
OBUF8Z30-68
_
Instance %s (%s) is not placed
68*place2
cfg_dcommand_OBUF[14]_inst2
OBUF8Z30-68
_
Instance %s (%s) is not placed
68*place2
cfg_dcommand_OBUF[15]_inst2
OBUF8Z30-68
^
Instance %s (%s) is not placed
68*place2
cfg_dcommand_OBUF[1]_inst2
OBUF8Z30-68
^
Instance %s (%s) is not placed
68*place2
cfg_dcommand_OBUF[2]_inst2
OBUF8Z30-68
^
Instance %s (%s) is not placed
68*place2
cfg_dcommand_OBUF[3]_inst2
OBUF8Z30-68
^
Instance %s (%s) is not placed
68*place2
cfg_dcommand_OBUF[4]_inst2
OBUF8Z30-68
^
Instance %s (%s) is not placed
68*place2
cfg_dcommand_OBUF[5]_inst2
OBUF8Z30-68
^
Instance %s (%s) is not placed
68*place2
cfg_dcommand_OBUF[6]_inst2
OBUF8Z30-68
^
Instance %s (%s) is not placed
68*place2
cfg_dcommand_OBUF[7]_inst2
OBUF8Z30-68
^
Instance %s (%s) is not placed
68*place2
cfg_dcommand_OBUF[8]_inst2
OBUF8Z30-68
^
Instance %s (%s) is not placed
68*place2
cfg_dcommand_OBUF[9]_inst2
OBUF8Z30-68
c
Instance %s (%s) is not placed
68*place2"
cfg_device_number_OBUF[0]_inst2
OBUF8Z30-68
c
Instance %s (%s) is not placed
68*place2"
cfg_device_number_OBUF[1]_inst2
OBUF8Z30-68
c
Instance %s (%s) is not placed
68*place2"
cfg_device_number_OBUF[2]_inst2
OBUF8Z30-68
c
Instance %s (%s) is not placed
68*place2"
cfg_device_number_OBUF[3]_inst2
OBUF8Z30-68
c
Instance %s (%s) is not placed
68*place2"
cfg_device_number_OBUF[4]_inst2
OBUF8Z30-68
c
Instance %s (%s) is not placed
68*place2"
cfg_ds_bus_number_IBUF[0]_inst2
IBUF8Z30-68
c
Instance %s (%s) is not placed
68*place2"
cfg_ds_bus_number_IBUF[1]_inst2
IBUF8Z30-68
c
Instance %s (%s) is not placed
68*place2"
cfg_ds_bus_number_IBUF[2]_inst2
IBUF8Z30-68
c
Instance %s (%s) is not placed
68*place2"
cfg_ds_bus_number_IBUF[3]_inst2
IBUF8Z30-68
c
Instance %s (%s) is not placed
68*place2"
cfg_ds_bus_number_IBUF[4]_inst2
IBUF8Z30-68
c
Instance %s (%s) is not placed
68*place2"
cfg_ds_bus_number_IBUF[5]_inst2
IBUF8Z30-68
c
Instance %s (%s) is not placed
68*place2"
cfg_ds_bus_number_IBUF[6]_inst2
IBUF8Z30-68
c
Instance %s (%s) is not placed
68*place2"
cfg_ds_bus_number_IBUF[7]_inst2
IBUF8Z30-68
f
Instance %s (%s) is not placed
68*place2%
!cfg_ds_device_number_IBUF[0]_inst2
IBUF8Z30-68
f
Instance %s (%s) is not placed
68*place2%
!cfg_ds_device_number_IBUF[1]_inst2
IBUF8Z30-68
f
Instance %s (%s) is not placed
68*place2%
!cfg_ds_device_number_IBUF[2]_inst2
IBUF8Z30-68
f
Instance %s (%s) is not placed
68*place2%
!cfg_ds_device_number_IBUF[3]_inst2
IBUF8Z30-68
f
Instance %s (%s) is not placed
68*place2%
!cfg_ds_device_number_IBUF[4]_inst2
IBUF8Z30-68
h
Instance %s (%s) is not placed
68*place2'
#cfg_ds_function_number_IBUF[0]_inst2
IBUF8Z30-68
h
Instance %s (%s) is not placed
68*place2'
#cfg_ds_function_number_IBUF[1]_inst2
IBUF8Z30-68
h
Instance %s (%s) is not placed
68*place2'
#cfg_ds_function_number_IBUF[2]_inst2
IBUF8Z30-68
Y
Instance %s (%s) is not placed
68*place2
cfg_dsn_IBUF[0]_inst2
IBUF8Z30-68
Z
Instance %s (%s) is not placed
68*place2
cfg_dsn_IBUF[10]_inst2
IBUF8Z30-68
Z
Instance %s (%s) is not placed
68*place2
cfg_dsn_IBUF[11]_inst2
IBUF8Z30-68
Z
Instance %s (%s) is not placed
68*place2
cfg_dsn_IBUF[12]_inst2
IBUF8Z30-68
Z
Instance %s (%s) is not placed
68*place2
cfg_dsn_IBUF[13]_inst2
IBUF8Z30-68
Z
Instance %s (%s) is not placed
68*place2
cfg_dsn_IBUF[14]_inst2
IBUF8Z30-68
Z
Instance %s (%s) is not placed
68*place2
cfg_dsn_IBUF[15]_inst2
IBUF8Z30-68
Z
Instance %s (%s) is not placed
68*place2
cfg_dsn_IBUF[16]_inst2
IBUF8Z30-68
Z
Instance %s (%s) is not placed
68*place2
cfg_dsn_IBUF[17]_inst2
IBUF8Z30-68
¯
Message '%s' appears more than %s times and has been disabled. User can change this message limit to see more message instances.
14*common2
Place 30-682
100Z17-14
^
RPhase 1.8 IO Placement/ Clock Placement/ Build Placer Device | Checksum: 826b98b5
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 1113.980 ; gain = 30.012
?
3Phase 1 Placer Initialization | Checksum: 826b98b5
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 1113.980 ; gain = 30.012
¶
‚Placer failed with error: '%s'
Please review all ERROR and WARNING messages during placement to understand the cause for failure.
1*	placeflow2
IO Clock Placer failedZ30-99
4
(Ending Placer Task | Checksum: 826b98b5
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 1113.980 ; gain = 30.012
w
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
322
12
02
102Z4-41
3

%s failed
30*	vivadotcl2
place_designZ4-43
R
Command failed: %s
69*common2&
$Placer could not place all instancesZ17-69
S
Exiting %s at %s...
206*common2
Vivado2
Sat Oct  5 15:59:28 2013Z17-206