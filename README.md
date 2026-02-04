# ECSE 689 - High Level Synthesis Project

**Repository**: [https://github.com/Bakalala/ECSE689](https://github.com/Bakalala/ECSE689)

This project implements a High-Level Synthesis (HLS) pipeline that converts Control Data Flow Graphs (CDFG) into synthesizable VHDL. It automates the transition from behavioral models to register-transfer level (RTL) hardware.

## Reference
This work builds upon the assignments from the **[hlsw26](../hlsw26)** course material.

## Project Summary & Contributions

This repository serves as a complete HLS compiler backend, featuring:

### 1. Scheduling & Allocation
*   **List Scheduling**: Implements ASAP-based list scheduling to order operations.
*   **Resource Allocation**: Maps abstract operations (Add, Mul) to concrete hardware resources, enforcing constraints.
*   **Register Allocation**: Minimizes register usage by analyzing variable lifecycles and reusing registers for disjoint edges.

### 2. VHDL Code Generation
*   **Unified Architecture**: Generates a single `Design` entity combining the FSM Controller and Datapath.
*   **Modular Component Layout**:
    *   **External Components**: Uses `core_vhdl_files/` for reusable logic (`dual_port_ram`, `adder`, `multiplier`).
    *   **Component Instantiation**: The generated design instantiates these components rather than embedding logic inline.
*   **Synthesis-Ready Logic**:
    *   **Data Types**: Fully adheres to `STD_LOGIC_VECTOR` for all synthesizable signals.
    *   **Arithmetic**: Implements signed 32-bit arithmetic with C-style overflow wrapping.
    *   **Multiplexing**: Uses readable `WITH ... SELECT` syntax for clean mux generation.

### 3. Verification
*   **Automated Testing**: Five test cases (`test0` to `test4`) covering branching, loops, and memory access.
*   **Simulation**: Scripts automatically compile with `ghdl` and generate waveform (`.vcd`) files for verification.
*   **Visualization**: Generates Graphviz DOT files for both the CDFG and the generated Datapath hardware structure.

## Project Structure

### Python Source
- `to_vhdl.py`: Main VHDL generation logic (Refactored for component instantiation).
- `fsm.py`: Finite State Machine generation.
- `datapath.py`: Hardware graph construction (Mux insertion, wiring).
- `scheduler.py`, `resource.py`: Frontend optimization steps.

### Core VHDL (`core_vhdl_files/`)
- `dual_port_ram.vhdl`: Generic RAM with file-based initialization.
- `adder.vhdl`: 32-bit standard logic adder.
- `multiplier.vhdl`: 32-bit standard logic multiplier.

## Running Tests
Run any test script to generate and simulate the hardware:

```bash
# Matrix Multiplication Test
cd generated_vhdl_test4
./run.sh
```
Output includes `design.vhdl`, `wave.vcd`, and PDF visualizations.
