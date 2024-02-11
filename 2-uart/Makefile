BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

all: uart.fs

# Synthesis
uart.json: uart.sv
	yosys -p "read_verilog -sv uart.sv; synth_gowin -top top -json uart.json"

# Place and Route
uart_pnr.json: uart.json
	nextpnr-gowin --force --top top --json uart.json --freq 27 --write uart_pnr.json --device ${DEVICE} --family ${FAMILY} --cst ${BOARD}.cst

# Generate Bitstream
uart.fs: uart_pnr.json
	gowin_pack -d ${FAMILY} -o uart.fs uart_pnr.json

# Program Board
load: uart.fs
	openFPGALoader -b ${BOARD} uart.fs -f

.PHONY: load
.INTERMEDIATE: uart_pnr.json uart.json
