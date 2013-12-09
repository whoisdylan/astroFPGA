
4
Command: %s
53*	vivadotcl2

opt_designZ4-113
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
S
,Running DRC as a precondition to command %s
22*	vivadotcl2

opt_designZ4-22
7

Starting %s Task
103*constraints2
DRCZ18-103
5
Running DRC with %s threads
24*drc2
4Z23-27
:
DRC finished with %s
272*project2

0 ErrorsZ1-461
[
BPlease refer to the DRC report (report_drc) for more information.
274*projectZ1-462
t

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1562.105 ; gain = 1.004
F

Starting %s Task
103*constraints2
Logic OptimizationZ18-103
4
(Logic Optimization | Checksum: 3bd7a5a0
*common
<
%Done setting XDC timing constraints.
35*timingZ38-35
<

Phase %s%s
101*constraints2
1 2

RetargetZ18-101
1
Pushed %s inverter(s).
98*opt2
1Z31-138
0
Retargeted %s cell(s).
49*opt2
0Z31-49
2
&Phase 1 Retarget | Checksum: 480e4228
*common
t

%s
*constraints2]
[Time (s): cpu = 00:00:23 ; elapsed = 00:00:20 . Memory (MB): peak = 1562.105 ; gain = 0.000
H

Phase %s%s
101*constraints2
2 2
Constant PropagationZ18-101
1
Pushed %s inverter(s).
98*opt2
0Z31-138
1
Eliminated %s cells.
10*opt2
1777Z31-10
>
2Phase 2 Constant Propagation | Checksum: d70a31d7
*common
t

%s
*constraints2]
[Time (s): cpu = 00:00:39 ; elapsed = 00:00:36 . Memory (MB): peak = 1562.105 ; gain = 0.000
9

Phase %s%s
101*constraints2
3 2
SweepZ18-101
=
 Eliminated %s unconnected nets.
12*opt2
43517Z31-12
=
!Eliminated %s unconnected cells.
11*opt2
7063Z31-11
/
#Phase 3 Sweep | Checksum: 223533e1
*common
t

%s
*constraints2]
[Time (s): cpu = 00:00:49 ; elapsed = 00:00:46 . Memory (MB): peak = 1562.105 ; gain = 0.000
<
%Done setting XDC timing constraints.
35*timingZ38-35
@
4Ending Logic Optimization Task | Checksum: 223533e1
*common
t

%s
*constraints2]
[Time (s): cpu = 00:01:03 ; elapsed = 00:00:57 . Memory (MB): peak = 1562.105 ; gain = 0.000
F

Starting %s Task
103*constraints2
Power OptimizationZ18-103
4
Applying IDT optimizations ...
9*pwroptZ34-9
6
Applying ODC optimizations ...
10*pwroptZ34-10


*pwropt
Ï
©WRITE_MODE attribute of %s BRAM(s) out of a total of %s was updated to NO_CHANGE to save power.
    Run report_power_opt to get a complete listing of the BRAMs updated.
129*pwropt2
42
260Z34-162
I
+Structural ODC has moved %s WE to EN ports
155*pwropt2
0Z34-201
k
CNumber of BRAM Ports augmented: %s newly gated: %s Total Ports: %s
65*pwropt2
02
02
520Z34-65
@
4Ending Power Optimization Task | Checksum: 223533e1
*common
w

%s
*constraints2`
^Time (s): cpu = 00:04:43 ; elapsed = 00:04:01 . Memory (MB): peak = 2796.320 ; gain = 1234.215
u
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
252
52
42
0Z4-41
A
%s completed successfully
29*	vivadotcl2

opt_designZ4-42
¢
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
opt_design: 2

00:05:482

00:05:012

2796.3202

1235.219Z17-268
4
Writing XDEF routing.
211*designutilsZ20-211
A
#Writing XDEF routing logical nets.
209*designutilsZ20-209
A
#Writing XDEF routing special nets.
210*designutilsZ20-210
¨
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Write XDEF Complete: 2

00:00:012

00:00:022

2796.3202
0.000Z17-268
¥
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
write_checkpoint: 2

00:00:092

00:00:312

2796.3202
0.000Z17-268


End Record