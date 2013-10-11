
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
°
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002
00:00:00.012

1085.2072
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
H
<Phase 1.1 Mandatory Logic Optimization | Checksum: 9c43f2d4
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.16 ; elapsed = 00:00:00.17 . Memory (MB): peak = 1085.207 ; gain = 0.000
]

Phase %s%s
101*constraints2
1.2 2)
'Build Super Logic Region (SLR) DatabaseZ18-101
S
GPhase 1.2 Build Super Logic Region (SLR) Database | Checksum: 9c43f2d4
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.30 ; elapsed = 00:00:00.31 . Memory (MB): peak = 1085.207 ; gain = 0.000
E

Phase %s%s
101*constraints2
1.3 2
Add ConstraintsZ18-101
;
/Phase 1.3 Add Constraints | Checksum: 9c43f2d4
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.30 ; elapsed = 00:00:00.31 . Memory (MB): peak = 1085.207 ; gain = 0.000
R

Phase %s%s
101*constraints2
1.4 2
Routing Based Site ExclusionZ18-101
H
<Phase 1.4 Routing Based Site Exclusion | Checksum: 9c43f2d4
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.31 ; elapsed = 00:00:00.31 . Memory (MB): peak = 1085.207 ; gain = 0.000
B

Phase %s%s
101*constraints2
1.5 2
Build MacrosZ18-101
9
-Phase 1.5 Build Macros | Checksum: 10d9b6075
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.65 ; elapsed = 00:00:00.66 . Memory (MB): peak = 1085.207 ; gain = 0.000
V

Phase %s%s
101*constraints2
1.6 2"
 Implementation Feasibility checkZ18-101
M
APhase 1.6 Implementation Feasibility check | Checksum: 10d9b6075
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.95 ; elapsed = 00:00:00.96 . Memory (MB): peak = 1085.207 ; gain = 0.000
E

Phase %s%s
101*constraints2
1.7 2
Pre-Place CellsZ18-101
<
0Phase 1.7 Pre-Place Cells | Checksum: 10d9b6075
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.96 ; elapsed = 00:00:00.98 . Memory (MB): peak = 1085.207 ; gain = 0.000
h

Phase %s%s
101*constraints2
1.8 24
2IO Placement/ Clock Placement/ Build Placer DeviceZ18-101
_
SPhase 1.8 IO Placement/ Clock Placement/ Build Placer Device | Checksum: 10d9b6075
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:03 ; elapsed = 00:00:02 . Memory (MB): peak = 1115.219 ; gain = 30.012
P

Phase %s%s
101*constraints2
1.9 2
Build Placer Netlist ModelZ18-101
I

Phase %s%s
101*constraints2
1.9.1 2
Place Init DesignZ18-101
J

Phase %s%s
101*constraints2

1.9.1.1 2
Build Clock DataZ18-101
A
5Phase 1.9.1.1 Build Clock Data | Checksum: 1105f593c
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:05 ; elapsed = 00:00:03 . Memory (MB): peak = 1115.219 ; gain = 30.012
@
4Phase 1.9.1 Place Init Design | Checksum: 17ab1361d
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:05 ; elapsed = 00:00:04 . Memory (MB): peak = 1115.219 ; gain = 30.012
G
;Phase 1.9 Build Placer Netlist Model | Checksum: 17ab1361d
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:05 ; elapsed = 00:00:04 . Memory (MB): peak = 1115.219 ; gain = 30.012
N

Phase %s%s
101*constraints2
1.10 2
Constrain Clocks/MacrosZ18-101
Y

Phase %s%s
101*constraints2	
1.10.1 2"
 Constrain Global/Regional ClocksZ18-101
P
DPhase 1.10.1 Constrain Global/Regional Clocks | Checksum: 16c05953b
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:05 ; elapsed = 00:00:04 . Memory (MB): peak = 1115.219 ; gain = 30.012
E
9Phase 1.10 Constrain Clocks/Macros | Checksum: 16c05953b
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:05 ; elapsed = 00:00:04 . Memory (MB): peak = 1115.219 ; gain = 30.012
@
4Phase 1 Placer Initialization | Checksum: 16c05953b
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:05 ; elapsed = 00:00:04 . Memory (MB): peak = 1115.219 ; gain = 30.012
D

Phase %s%s
101*constraints2
2 2
Global PlacementZ18-101
;
/Phase 2 Global Placement | Checksum: 19fe936e4
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:20 ; elapsed = 00:00:10 . Memory (MB): peak = 1115.219 ; gain = 30.012
D

Phase %s%s
101*constraints2
3 2
Detail PlacementZ18-101
P

Phase %s%s
101*constraints2
3.1 2
Commit Multi Column MacrosZ18-101
G
;Phase 3.1 Commit Multi Column Macros | Checksum: 19fe936e4
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:20 ; elapsed = 00:00:10 . Memory (MB): peak = 1115.219 ; gain = 30.012
R

Phase %s%s
101*constraints2
3.2 2
Commit Most Macros & LUTRAMsZ18-101
I
=Phase 3.2 Commit Most Macros & LUTRAMs | Checksum: 15c381441
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:21 ; elapsed = 00:00:11 . Memory (MB): peak = 1123.254 ; gain = 38.047
L

Phase %s%s
101*constraints2
3.3 2
Area Swap OptimizationZ18-101
C
7Phase 3.3 Area Swap Optimization | Checksum: 1f88ee5ca
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:22 ; elapsed = 00:00:11 . Memory (MB): peak = 1123.254 ; gain = 38.047
K

Phase %s%s
101*constraints2
3.4 2
Timing Path OptimizerZ18-101
B
6Phase 3.4 Timing Path Optimizer | Checksum: 14fc943f9
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:24 ; elapsed = 00:00:12 . Memory (MB): peak = 1123.254 ; gain = 38.047
V

Phase %s%s
101*constraints2
3.5 2"
 Commit Small Macros & Core LogicZ18-101
M
APhase 3.5 Commit Small Macros & Core Logic | Checksum: 1a88ac7c6
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:26 ; elapsed = 00:00:14 . Memory (MB): peak = 1173.703 ; gain = 88.496
H

Phase %s%s
101*constraints2
3.6 2
Re-assign LUT pinsZ18-101
?
3Phase 3.6 Re-assign LUT pins | Checksum: 1a88ac7c6
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:26 ; elapsed = 00:00:14 . Memory (MB): peak = 1173.703 ; gain = 88.496
;
/Phase 3 Detail Placement | Checksum: 1a88ac7c6
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:26 ; elapsed = 00:00:14 . Memory (MB): peak = 1173.703 ; gain = 88.496
\

Phase %s%s
101*constraints2
4 2*
(Post Placement Optimization and Clean-UpZ18-101
X

Phase %s%s
101*constraints2
4.1 2$
"Post Placement Timing OptimizationZ18-101
N
BPhase 4.1 Post Placement Timing Optimization | Checksum: e5196a49
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:30 ; elapsed = 00:00:17 . Memory (MB): peak = 1173.703 ; gain = 88.496
L

Phase %s%s
101*constraints2
4.2 2
Post Placement CleanupZ18-101
B
6Phase 4.2 Post Placement Cleanup | Checksum: e5196a49
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:30 ; elapsed = 00:00:17 . Memory (MB): peak = 1173.703 ; gain = 88.496
F

Phase %s%s
101*constraints2
4.3 2
Placer ReportingZ18-101
[
!Post Placement Timing Summary %s
2*	placeflow2
| WNS=0.314  | TNS=0.000  |
Z30-100
=
1Phase 4.3 Placer Reporting | Checksum: 14500d4b3
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:31 ; elapsed = 00:00:17 . Memory (MB): peak = 1173.703 ; gain = 88.496
M

Phase %s%s
101*constraints2
4.4 2
Final Placement CleanupZ18-101
D
8Phase 4.4 Final Placement Cleanup | Checksum: 12c053747
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:31 ; elapsed = 00:00:17 . Memory (MB): peak = 1173.703 ; gain = 88.496
S
GPhase 4 Post Placement Optimization and Clean-Up | Checksum: 12c053747
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:31 ; elapsed = 00:00:17 . Memory (MB): peak = 1173.703 ; gain = 88.496
4
(Ending Placer Task | Checksum: f4e8c927
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:31 ; elapsed = 00:00:17 . Memory (MB): peak = 1173.703 ; gain = 88.496
u
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
342
22
02
0Z4-41
C
%s completed successfully
29*	vivadotcl2
place_designZ4-42
¢
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
place_design: 2

00:00:312

00:00:182

1173.7032
88.496Z17-268
O

DEBUG : %s144*timing2*
(Generate clock report | CPU: 0.29 secs 
Z38-163
‚
vreport_utilization: Time (s): cpu = 00:00:00.08 ; elapsed = 00:00:00.15 . Memory (MB): peak = 1173.703 ; gain = 0.000
*common
[

DEBUG : %s134*designutils21
/Generate Control Sets report | CPU: 0.07 secs 
Z20-134
4
Writing XDEF routing.
211*designutilsZ20-211
A
#Writing XDEF routing logical nets.
209*designutilsZ20-209
A
#Writing XDEF routing special nets.
210*designutilsZ20-210
®
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Write XDEF Complete: 2
00:00:00.572
00:00:00.612

1173.7032
0.000Z17-268


End Record