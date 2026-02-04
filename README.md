# ECSE 689 - High Level Synthesis Project

## Reference
This work builds upon the assignments from the **[hlsw26](https://bitbucket.org/cdubach/hlsw26)** course material.


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
