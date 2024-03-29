upload: build/hardware.bin build/firmware.bin
#	tinyprog -p build/hardware.bin -u firmware.bin
	powershell.exe /c "tinyprog -p \$$env:WSLHome\RK8\build\hardware.bin -u \$$env:WSLHome\RK8\build\firmware.bin"

build/hardware.blif: hardware.sv modules/*/*.sv
	yosys -p 'synth_ice40 -top hardware -blif build/hardware.blif' $^

build/hardware.asc: hardware.pcf build/hardware.blif
	arachne-pnr -d 8k -P cm81 -o build/hardware.asc -p hardware.pcf build/hardware.blif

build/hardware.bin: build/hardware.asc
	icetime -d lp8k -c 12 -mtr build/hardware.rpt build/hardware.asc
	icepack build/hardware.asc build/hardware.bin

build/firmware.bin: firmware.txt
	xxd -r -p firmware.txt > build/firmware.bin

test: test.sv hardware.sv modules/*
