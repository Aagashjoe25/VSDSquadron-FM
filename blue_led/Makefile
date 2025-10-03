# Makefile without variables
build:
	# yosys tool command to synthesize the netlist in top.json file
	yosys -q -p "synth_ice40 -abc9 -device u -dsp -top top -json top.json" top.v

	# nextpnr command to use the netlist for physical mapping in fpga i.e takes care of placement and routing of netlist and outputs top.ascii
	nextpnr-ice40 --force --json top.json --pcf VSDSquadronFM.pcf --asc top.asc --freq 12 --up5k --package sg48 --opt-timing -q

	#iceprog has the 2 tools icetime which is used for timing analysis and icepack for coverting ascii into binary to get the final bistream
	icetime -p VSDSquadronFM.pcf -P sg48 -r top.timings -d up5k -t top.asc
	icepack -s top.asc top.bin

flash:
	# iceprog tool to dump the generated bistream to fpga board
	iceprog top.bin

erase:
	# Erase 1MB of the flash memory which contains the bistream and resets the fpga baord
	iceprog -e 1M

clean:
	# remove the generated intermediate files, for unncessary accumulation  
	rm -rf top.blif top.asc top.bin top.json top.timings
