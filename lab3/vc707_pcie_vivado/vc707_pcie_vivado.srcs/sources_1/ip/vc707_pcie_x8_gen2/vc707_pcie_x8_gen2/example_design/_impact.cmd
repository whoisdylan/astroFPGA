setMode -pff
setMode -pff
addConfigDevice  -name "vc707_pcie_x8_gen2" -path "/afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/ready_for_download"
setSubmode -pffbpi
setAttribute -configdevice -attr multibootBpiType -value "TYPE_BPI"
setAttribute -configdevice -attr multibootBpichainType -value "PARALLEL"
addDesign -version 0 -name "0"
setMode -pff
addDeviceChain -index 0
setMode -pff
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr autoSize -value "FALSE"
setAttribute -configdevice -attr fileFormat -value "mcs"
setAttribute -configdevice -attr fillValue -value "FF"
setAttribute -configdevice -attr swapBit -value "FALSE"
setAttribute -configdevice -attr dir -value "UP"
setAttribute -configdevice -attr multiboot -value "FALSE"
setAttribute -configdevice -attr multiboot -value "FALSE"
setAttribute -configdevice -attr spiSelected -value "FALSE"
setAttribute -configdevice -attr spiSelected -value "FALSE"
setAttribute -configdevice -attr ironhorsename -value "1"
setAttribute -configdevice -attr flashDataWidth -value "16"
setCurrentDesign -version 0
setAttribute -design -attr RSPin -value ""
setCurrentDesign -version 0
addPromDevice -p 1 -size 128 -name 128K
setMode -pff
setMode -pff
setMode -pff
setMode -pff
addDeviceChain -index 0
setMode -pff
addDeviceChain -index 0
setMode -pff
setSubmode -pffbpi
setMode -pff
setAttribute -design -attr RSPin -value "00"
addDevice -p 1 -file "/afs/ece.cmu.edu/usr/wtabib/astroFPGA/lab3/vc707_pcie_vivado/example_project/vc707_pcie_x8_gen2_example/vc707_pcie_x8_gen2_example.runs/impl_1/xilinx_pcie_2_1_ep_7x.bit"
setAttribute -design -attr RSPinMsb -value "1"
setAttribute -design -attr name -value "0"
setAttribute -design -attr RSPin -value "00"
setAttribute -design -attr endAddress -value "25b093"
setAttribute -design -attr endAddress -value "25b093"
addPromDevice -p 2 -size 131072 -name 128M
deletePromDevice -position 1
setMode -pff
setSubmode -pffbpi
generate
setCurrentDesign -version 0
setMode -bs
setMode -bs
setMode -bs
setMode -bs
setCable -port auto
setCable -port auto
setCable -port auto
setMode -bs
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
setMode -bs
saveProjectFile -file "/afs/ece.cmu.edu/usr/wtabib/18545/lab3//auto_project.ipf"
setMode -bs
setMode -pff
setMode -bs
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
