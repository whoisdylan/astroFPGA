
6
Command: %s
53*	vivadotcl2
route_designZ4-113
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
route_designZ4-22
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
;

Starting %s Task
103*constraints2	
RoutingZ18-103
^
BMultithreading enabled for route_design using a maximum of %s CPUs97*route2
4Z35-254
9

Starting %s Task
103*constraints2
RouteZ18-103
C

Phase %s%s
101*constraints2
1 2
Build RT DesignZ18-101
T

Phase %s%s
101*constraints2
1.1 2 
Build Netlist & NodeGraph (MT)Z18-101
³
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2
00:00:00.032
00:00:00.012

1173.7032
0.000Z17-268
C
7Phase 1.1 Build Netlist & NodeGraph (MT) | Checksum: 0
*common
v

%s
*constraints2_
]Time (s): cpu = 00:01:40 ; elapsed = 00:01:16 . Memory (MB): peak = 1436.785 ; gain = 263.082
2
&Phase 1 Build RT Design | Checksum: 0
*common
v

%s
*constraints2_
]Time (s): cpu = 00:01:40 ; elapsed = 00:01:16 . Memory (MB): peak = 1436.785 ; gain = 263.082
I

Phase %s%s
101*constraints2
2 2
Router InitializationZ18-101
B

Phase %s%s
101*constraints2
2.1 2
Create TimerZ18-101
8
,Phase 2.1 Create Timer | Checksum: 9806e940
*common
v

%s
*constraints2_
]Time (s): cpu = 00:01:40 ; elapsed = 00:01:16 . Memory (MB): peak = 1436.785 ; gain = 263.082
Q
3Estimated Global Vertical Wire Utilization = %s %%
23*route2
0.20Z35-23
S
5Estimated Global Horizontal Wire Utilization = %s %%
22*route2
0.23Z35-22
E

Phase %s%s
101*constraints2
2.2 2
Restore RoutingZ18-101
<
Design has %s routable nets.
92*route2
6369Z35-249
?
#Restored %s nets from the routeDb.
95*route2
0Z35-252
E
)Found %s nets with FIXED_ROUTE property.
94*route2
0Z35-251
;
/Phase 2.2 Restore Routing | Checksum: 9806e940
*common
v

%s
*constraints2_
]Time (s): cpu = 00:01:40 ; elapsed = 00:01:17 . Memory (MB): peak = 1447.113 ; gain = 273.410
I

Phase %s%s
101*constraints2
2.3 2
Special Net RoutingZ18-101
?
3Phase 2.3 Special Net Routing | Checksum: 9e109840
*common
v

%s
*constraints2_
]Time (s): cpu = 00:01:42 ; elapsed = 00:01:18 . Memory (MB): peak = 1461.145 ; gain = 287.441
M

Phase %s%s
101*constraints2
2.4 2
Local Clock Net RoutingZ18-101
C
7Phase 2.4 Local Clock Net Routing | Checksum: 3ecca239
*common
v

%s
*constraints2_
]Time (s): cpu = 00:01:42 ; elapsed = 00:01:18 . Memory (MB): peak = 1461.145 ; gain = 287.441
C

Phase %s%s
101*constraints2
2.5 2
Update TimingZ18-101
S

Phase %s%s
101*constraints2
2.5.1 2
Update timing with NCN CRPRZ18-101
H

Phase %s%s
101*constraints2

2.5.1.1 2
Hold BudgetingZ18-101
>
2Phase 2.5.1.1 Hold Budgeting | Checksum: 3ecca239
*common
v

%s
*constraints2_
]Time (s): cpu = 00:01:46 ; elapsed = 00:01:20 . Memory (MB): peak = 1461.145 ; gain = 287.441
I
=Phase 2.5.1 Update timing with NCN CRPR | Checksum: 3ecca239
*common
v

%s
*constraints2_
]Time (s): cpu = 00:01:46 ; elapsed = 00:01:20 . Memory (MB): peak = 1461.145 ; gain = 287.441
9
-Phase 2.5 Update Timing | Checksum: 3ecca239
*common
v

%s
*constraints2_
]Time (s): cpu = 00:01:46 ; elapsed = 00:01:20 . Memory (MB): peak = 1461.145 ; gain = 287.441
l
Estimated Timing Summary %s
57*route28
6| WNS=0.236  | TNS=0      | WHS=-0.561 | THS=-495   |
Z35-57
?

Phase %s%s
101*constraints2
2.6 2
	BudgetingZ18-101
5
)Phase 2.6 Budgeting | Checksum: 3ecca239
*common
v

%s
*constraints2_
]Time (s): cpu = 00:01:49 ; elapsed = 00:01:21 . Memory (MB): peak = 1461.145 ; gain = 287.441
?
3Phase 2 Router Initialization | Checksum: aba1a8d3
*common
v

%s
*constraints2_
]Time (s): cpu = 00:01:49 ; elapsed = 00:01:22 . Memory (MB): peak = 1461.145 ; gain = 287.441
C

Phase %s%s
101*constraints2
3 2
Initial RoutingZ18-101
9
-Phase 3 Initial Routing | Checksum: 7c4dd5b2
*common
v

%s
*constraints2_
]Time (s): cpu = 00:01:55 ; elapsed = 00:01:23 . Memory (MB): peak = 1461.145 ; gain = 287.441
F

Phase %s%s
101*constraints2
4 2
Rip-up And RerouteZ18-101
H

Phase %s%s
101*constraints2
4.1 2
Global Iteration 0Z18-101
G

Phase %s%s
101*constraints2
4.1.1 2
Remove OverlapsZ18-101
=
1Phase 4.1.1 Remove Overlaps | Checksum: 4f182d51
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:08 ; elapsed = 00:01:28 . Memory (MB): peak = 1461.145 ; gain = 287.441
E

Phase %s%s
101*constraints2
4.1.2 2
Update TimingZ18-101
;
/Phase 4.1.2 Update Timing | Checksum: 4f182d51
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:09 ; elapsed = 00:01:29 . Memory (MB): peak = 1461.145 ; gain = 287.441
l
Estimated Timing Summary %s
57*route28
6| WNS=-0.0172| TNS=-0.0379| WHS=N/A    | THS=N/A    |
Z35-57
L

Phase %s%s
101*constraints2
4.1.3 2
collectNewHoldAndFixZ18-101
B
6Phase 4.1.3 collectNewHoldAndFix | Checksum: 4f182d51
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:09 ; elapsed = 00:01:29 . Memory (MB): peak = 1461.145 ; gain = 287.441
I

Phase %s%s
101*constraints2
4.1.4 2
GlobIterForTimingZ18-101
G

Phase %s%s
101*constraints2

4.1.4.1 2
Update TimingZ18-101
=
1Phase 4.1.4.1 Update Timing | Checksum: 4f182d51
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:09 ; elapsed = 00:01:29 . Memory (MB): peak = 1461.145 ; gain = 287.441
l
Estimated Timing Summary %s
57*route28
6| WNS=-0.0172| TNS=-0.0379| WHS=N/A    | THS=N/A    |
Z35-57
H

Phase %s%s
101*constraints2

4.1.4.2 2
Fast BudgetingZ18-101
>
2Phase 4.1.4.2 Fast Budgeting | Checksum: 4f182d51
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:10 ; elapsed = 00:01:29 . Memory (MB): peak = 1461.145 ; gain = 287.441
?
3Phase 4.1.4 GlobIterForTiming | Checksum: 85683a5c
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:10 ; elapsed = 00:01:29 . Memory (MB): peak = 1461.145 ; gain = 287.441
>
2Phase 4.1 Global Iteration 0 | Checksum: 85683a5c
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:10 ; elapsed = 00:01:29 . Memory (MB): peak = 1461.145 ; gain = 287.441
H

Phase %s%s
101*constraints2
4.2 2
Global Iteration 1Z18-101
G

Phase %s%s
101*constraints2
4.2.1 2
Remove OverlapsZ18-101
=
1Phase 4.2.1 Remove Overlaps | Checksum: d771d90d
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:15 ; elapsed = 00:01:33 . Memory (MB): peak = 1461.145 ; gain = 287.441
E

Phase %s%s
101*constraints2
4.2.2 2
Update TimingZ18-101
;
/Phase 4.2.2 Update Timing | Checksum: d771d90d
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:15 ; elapsed = 00:01:33 . Memory (MB): peak = 1461.145 ; gain = 287.441
l
Estimated Timing Summary %s
57*route28
6| WNS=0.0108 | TNS=0      | WHS=N/A    | THS=N/A    |
Z35-57
L

Phase %s%s
101*constraints2
4.2.3 2
collectNewHoldAndFixZ18-101
B
6Phase 4.2.3 collectNewHoldAndFix | Checksum: d771d90d
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:15 ; elapsed = 00:01:33 . Memory (MB): peak = 1461.145 ; gain = 287.441
I

Phase %s%s
101*constraints2
4.2.4 2
GlobIterForTimingZ18-101
G

Phase %s%s
101*constraints2

4.2.4.1 2
Update TimingZ18-101
=
1Phase 4.2.4.1 Update Timing | Checksum: d771d90d
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:15 ; elapsed = 00:01:33 . Memory (MB): peak = 1461.145 ; gain = 287.441
l
Estimated Timing Summary %s
57*route28
6| WNS=0.0108 | TNS=0      | WHS=N/A    | THS=N/A    |
Z35-57
H

Phase %s%s
101*constraints2

4.2.4.2 2
Fast BudgetingZ18-101
>
2Phase 4.2.4.2 Fast Budgeting | Checksum: d771d90d
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:15 ; elapsed = 00:01:34 . Memory (MB): peak = 1461.145 ; gain = 287.441
?
3Phase 4.2.4 GlobIterForTiming | Checksum: 391e02da
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:16 ; elapsed = 00:01:34 . Memory (MB): peak = 1461.145 ; gain = 287.441
>
2Phase 4.2 Global Iteration 1 | Checksum: 391e02da
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:16 ; elapsed = 00:01:34 . Memory (MB): peak = 1461.145 ; gain = 287.441
H

Phase %s%s
101*constraints2
4.3 2
Global Iteration 2Z18-101
G

Phase %s%s
101*constraints2
4.3.1 2
Remove OverlapsZ18-101
=
1Phase 4.3.1 Remove Overlaps | Checksum: 4bf3dc06
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:17 ; elapsed = 00:01:35 . Memory (MB): peak = 1461.145 ; gain = 287.441
E

Phase %s%s
101*constraints2
4.3.2 2
Update TimingZ18-101
;
/Phase 4.3.2 Update Timing | Checksum: 4bf3dc06
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:17 ; elapsed = 00:01:35 . Memory (MB): peak = 1461.145 ; gain = 287.441
m
Estimated Timing Summary %s
57*route29
7| WNS=-0.00822| TNS=-0.0183| WHS=N/A    | THS=N/A    |
Z35-57
>
2Phase 4.3 Global Iteration 2 | Checksum: d771d90d
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:17 ; elapsed = 00:01:35 . Memory (MB): peak = 1461.145 ; gain = 287.441
<
0Phase 4 Rip-up And Reroute | Checksum: d771d90d
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:17 ; elapsed = 00:01:36 . Memory (MB): peak = 1461.145 ; gain = 287.441
A

Phase %s%s
101*constraints2
5 2
Delay CleanUpZ18-101
C

Phase %s%s
101*constraints2
5.1 2
Update TimingZ18-101
9
-Phase 5.1 Update Timing | Checksum: d771d90d
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:19 ; elapsed = 00:01:36 . Memory (MB): peak = 1461.145 ; gain = 287.441
l
Estimated Timing Summary %s
57*route28
6| WNS=0.0978 | TNS=0      | WHS=N/A    | THS=N/A    |
Z35-57
7
+Phase 5 Delay CleanUp | Checksum: d771d90d
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:19 ; elapsed = 00:01:36 . Memory (MB): peak = 1461.145 ; gain = 287.441
A

Phase %s%s
101*constraints2
6 2
Post Hold FixZ18-101
H

Phase %s%s
101*constraints2
6.1 2
Full Hold AnalysisZ18-101
E

Phase %s%s
101*constraints2
6.1.1 2
Update TimingZ18-101
;
/Phase 6.1.1 Update Timing | Checksum: d771d90d
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:21 ; elapsed = 00:01:37 . Memory (MB): peak = 1461.145 ; gain = 287.441
l
Estimated Timing Summary %s
57*route28
6| WNS=0.0978 | TNS=0      | WHS=0.024  | THS=0      |
Z35-57
>
2Phase 6.1 Full Hold Analysis | Checksum: d771d90d
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:21 ; elapsed = 00:01:37 . Memory (MB): peak = 1461.145 ; gain = 287.441
7
+Phase 6 Post Hold Fix | Checksum: d771d90d
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:21 ; elapsed = 00:01:37 . Memory (MB): peak = 1461.145 ; gain = 287.441
I

Phase %s%s
101*constraints2
7 2
Verifying routed netsZ18-101
?
3Phase 7 Verifying routed nets | Checksum: d771d90d
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:21 ; elapsed = 00:01:37 . Memory (MB): peak = 1461.145 ; gain = 287.441
E

Phase %s%s
101*constraints2
8 2
Depositing RoutesZ18-101
;
/Phase 8 Depositing Routes | Checksum: 1f362508
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:22 ; elapsed = 00:01:37 . Memory (MB): peak = 1461.145 ; gain = 287.441
F

Phase %s%s
101*constraints2
9 2
Post Router TimingZ18-101
o
Post Routing Timing Summary %s
20*route28
6| WNS=0.100  | TNS=0.000  | WHS=0.025  | THS=0.000  |
Z35-20
=
'The design met the timing requirement.
61*routeZ35-61
5
)Phase 9 Post Router Timing | Checksum: 0
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:27 ; elapsed = 00:01:39 . Memory (MB): peak = 1461.145 ; gain = 287.441
4
Router Completed Successfully
16*routeZ35-16
,
 Ending Route Task | Checksum: 0
*common
v

%s
*constraints2_
]Time (s): cpu = 00:02:27 ; elapsed = 00:01:39 . Memory (MB): peak = 1461.145 ; gain = 287.441
v

%s
*constraints2_
]Time (s): cpu = 00:02:27 ; elapsed = 00:01:39 . Memory (MB): peak = 1461.145 ; gain = 287.441
u
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
582
22
02
0Z4-41
C
%s completed successfully
29*	vivadotcl2
route_designZ4-42
£
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
route_design: 2

00:02:272

00:01:402

1461.1452	
287.441Z17-268
5
Running DRC with %s threads
24*drc2
4Z23-27
‡
#The results of DRC are in file %s.
168*coretcl2Æ
Ÿ/afs/ece.cmu.edu/usr/wtabib/astroFPGA/pcie/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.srcs/sources_1/imports/example_design/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.runs/impl_1/xilinx_pcie_2_1_ep_7x_drc_routed.rptŸ/afs/ece.cmu.edu/usr/wtabib/astroFPGA/pcie/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.srcs/sources_1/imports/example_design/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.runs/impl_1/xilinx_pcie_2_1_ep_7x_drc_routed.rpt8Z2-168
Í
{ Setting default frequency of %s MHz on the clock %s . Please specify frequency of this clock for accurate power estimate.
164*power2
0.0020
.vc707_pcie_x8_gen2_i/inst/pipe_rxoutclk_out[0]Z33-164
B
,Running Vector-less Activity Propagation...
51*powerZ33-51
G
3
Finished Running Vector-less Activity Propagation
1*powerZ33-1
n
UpdateTimingParams:%s.
91*timing2>
< Speed grade: -2, Delay Type: min_max, Constraints type: SDCZ38-91
a
CMultithreading enabled for timing update using a maximum of %s CPUs155*timing2
4Z38-191
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
00:00:00.732
00:00:00.832

1461.1452
0.000Z17-268


End Record