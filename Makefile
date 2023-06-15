upload: build/hardware.bin
	tinyprog -p build/hardware.bin

build/hardware.blif: hardware.v modules/POR.v modules/Prescaler.v
	yosys -ql build/hardware.log -p 'synth_ice40 -top hardware -blif build/hardware.blif' $^

build/hardware.asc: hardware.pcf build/hardware.blif
	arachne-pnr -s 3 -d 8k -P cm81 -o build/hardware.asc -p hardware.pcf build/hardware.blif

build/hardware.bin: build/hardware.asc
	icetime -d lp8k -c 12 -mtr build/hardware.rpt build/hardware.asc
	icepack build/hardware.asc build/hardware.bin
