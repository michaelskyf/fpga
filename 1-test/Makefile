BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

all: counter.fs

# Synthesis
counter.json: counter.sv
	yosys -p "read_verilog -sv counter.sv; synth_gowin -top counter -json counter.json"

# Place and Route
counter_pnr.json: counter.json
	nextpnr-gowin --json counter.json --freq 27 --write counter_pnr.json --device ${DEVICE} --family ${FAMILY} --cst ${BOARD}.cst

# Generate Bitstream
counter.fs: counter_pnr.json
	gowin_pack -d ${FAMILY} -o counter.fs counter_pnr.json

# Program Board
load: counter.fs
	openFPGALoader -b ${BOARD} counter.fs -f

.PHONY: load
.INTERMEDIATE: counter_pnr.json counter.json
