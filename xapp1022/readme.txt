*******************************************************************************
** © Copyright 2009 Xilinx, Inc. All rights reserved.
** This file contains confidential and proprietary information of Xilinx, Inc. and 
** is protected under U.S. and international copyright and other intellectual property laws.
*******************************************************************************
**   ____  ____ 
**  /   /\/   / 
** /___/  \  /   Vendor: Xilinx 
** \   \   \/    
**  \   \        readme.txt Version: 1.0  
**  /   /        Date Last Modified: November 25, 2009 
** /___/   /\    Date Created: 	November 25, 2009
** \   \  /  \   Associated Filename: xapp1022.zip
**  \___\/\___\ 
** 
*******************************************************************************
**
**  Disclaimer: 
**
**		          This disclaimer is not a license and does not grant any rights to the materials 
**              distributed herewith. Except as otherwise provided in a valid license issued to you 
**              by Xilinx, and to the maximum extent permitted by applicable law: 
**              (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, 
**              AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
**              INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR 
**              FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether in contract 
**              or tort, including negligence, or under any other theory of liability) for any loss or damage 
**              of any kind or nature related to, arising under or in connection with these materials, 
**              including for any direct, or any indirect, special, incidental, or consequential loss 
**              or damage (including loss of data, profits, goodwill, or any type of loss or damage suffered 
**              as a result of any action brought by a third party) even if such damage or loss was 
**              reasonably foreseeable or Xilinx had been advised of the possibility of the same.


1. Directory Contents

bistreams - contains ontains bitstreams for the Virtex-5 ML555, 
            Virtex-6 ML605 (x8 Gen 1 and x8 Gen 2), and the 
            Spartan-6 SP605 boards. Note that  Virtex-6 x8 Gen 2
            designs require a board with -3 speedgrade material.

Linux_Driver - contains the Fedora 10 Linux driver and application.

MET_GUI - contains the WindowsXP application GUI. Click MET_GUI.bat
          to launch the GUI after the driver is installed.

WindowsXP_Driver - contains the WindowsXP Driver and command line 
                   application called MET.exe.
                   
xapp1022_readme.txt - This readme file.                   

2 Description: This driver and application provides a simple
way to read and write memory space of PCI Express designs.
Please refer to XAPP 1022 for more information.

3. Platforms: Windows XP and Linux Fedora 10

4. Installation/Use:

Please refer to XAPP 1022 for installation instructions.

5. Device and Vendor ID

Currently the driver located in the subdirectory WindowsXP_Driver
is set to recognize cards with a Vendor ID of 10EEh and Device ID 
of 0007h. To change  this open the file xilinx_pcie_block.inf and 
modify the line:

Xilinx Endpoint for PCI Express = XILINXPCIe,PCI\VEN_10EE&DEV_0007

For example to use a Vendor ID of 1234 and Device ID of 0101, change this line to read:

Xilinx Endpoint for PCI Express = XILINXPCIe,PCI\VEN_1234&DEV_0101

Also more than one device and vendor id can be recognized by adding multiple lines. For example:

Xilinx Endpoint for PCI Express = XILINXPCIe,PCI\VEN_10EE&DEV_0007
Xilinx Endpoint for PCI Express = XILINXPCIe,PCI\VEN_1234&DEV_0101

Note that if the xilinx_pcie_block.inf file is modified, the driver must be installed again.

6. Important Notice
The MET driver is provided as is with no implied warranty or support.
This driver has been installed and used on various systems, but it is 
not guaranteed to work on all systems. Xilinx has not performed exhaustive 
testing across multiple platforms and while there are no known issues with
using the driver application, no support will be provided for any problems 
that might arise. Source code for the WindowsXP MET driver is not available.
The source for the Linux driver is included.

Web Support
http://www.xilinx.com/support

WebCase Support:
http://www.xilinx.com/support/clearexpress/websupport.htm

Technical Support Contact:
http://www.xilinx.com/support/services/contact_info.htm

