# ECSE 689 - High Level Synthesis Project

This project implements a High-Level Synthesis (HLS) pipeline that converts Control Data Flow Graphs (CDFG) into synthesizable VHDL. It focuses on pipelining and optimizing loop execution.

## Reference
This work is based on the assignments from the **[hlsw26](../hlsw26)** repository.

## features
- **CDFG Analysis**: Parsing and scheduling of operations.
- **Resource Allocation**: Mapping operations to hardware resources (Adders, Multipliers, RAM).
- **Register Allocation**: Optimizing data storage between pipeline stages.
- **VHDL Generation**: Automatically generating control and datapath logic.
- **Component Instantiation**: Uses modular, reusable VHDL components.

## Project Structure

### Python Source
- `to_vhdl.py`: Main VHDL generation logic.
- `fsm.py`: FSM controller generation.
- `datapath.py`: Datapath graph generation.
- `scheduler.py`: List scheduling implementation.
- `resource.py` & `register_allocator.py`: Resource management.

### VHDL Components (`core_vhdl_files/`)
- `dual_port_ram.vhdl`: Generic RAM component (configurable size & initialization).
- `adder.vhdl`: 32-bit signed integer adder (STD_LOGIC_VECTOR).
- `multiplier.vhdl`: 32-bit signed integer multiplier (STD_LOGIC_VECTOR).

## Running Tests
Each test case generates VHDL, compiling it with `ghdl`, and runs a simulation.

```bash
# Example: Run Test 4 (Matrix Multiplication)
cd generated_vhdl_test4
./run.sh
```

The output includes:
- `design.vhdl`: The generated HLS design.
- `testbench.vhdl`: Simulation testbench.
- `wave.vcd`: Waveform file for viewing in Surfer/GTKWave.
- `cdfg.pdf` & `datapath.pdf`: Visualizations of the graph.
