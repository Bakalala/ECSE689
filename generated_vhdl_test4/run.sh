#!/bin/bash
cd ..
python3 main_test4.py
cd generated_vhdl_test4
dot -Tpdf cdfg.dot -o cdfg.pdf && dot -Tpdf datapath.dot -o datapath.pdf
ghdl -a --std=08 ../core_vhdl_files/dual_port_ram.vhdl ../core_vhdl_files/adder.vhdl ../core_vhdl_files/multiplier.vhdl design.vhdl testbench.vhdl
ghdl -e --std=08 testbench
ghdl -r --std=08 testbench --vcd=wave.vcd --stop-time=200ns
echo "Done! View: surfer wave.vcd | open cdfg.pdf | open datapath.pdf"
