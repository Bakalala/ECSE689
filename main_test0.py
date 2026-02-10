from ast_nodes import *
from cdfg import ASTToCDFG
from scheduler import *
from ressource import *
from to_vhdl import *
from datapath import *
from fsm import *
from collections import defaultdict
from datapath_visualizer import DatapathVisualizer
from cdfg_visualizer import DOTVisualizer


def main():
    output_dir = "generated_vhdl_test0"
    print("--- Test 0: RAM[3] = RAM[0] * RAM[1] + RAM[2] ---")
    
    # 1. Define Memory
    ram = Mem(size=4, name="RAM")
    
    # 2. Build the AST
    # RAM[3] = RAM[0] * RAM[1] + RAM[2]
    program = Store(
        mem=ram,
        addr=Cst(3),
        val=Add(
            left=Add(Cst(1), Cst(2)),
            right=Cst(4)
        )
    )
    
    # 3. CDFG Generation
    print("\n--- Generating CDFG ---")
    converter = ASTToCDFG()
    converter.convert(program)
    print(f"CDFG generated with {len(converter.cdfg.nodes)} nodes.")
    
    # 3b. CDFG Visualization
    cdfg_viz = DOTVisualizer(converter.cdfg)
    with open(f"{output_dir}/cdfg.dot", "w") as f:
        f.write(cdfg_viz.to_dot())
    print(f"CDFG saved to {output_dir}/cdfg.dot")
    
    # 4. Scheduling
    print("\n--- Running Scheduler ---")
    scheduler = Scheduler(converter.cdfg)
    schedule = scheduler.schedule(chain=True)
    print(schedule)
    
    print("\nScheduled Times:")
    max_cycle = 0
    by_time = defaultdict(list)
    for node, time in schedule.items():
        by_time[time].append(node)
        max_cycle = max(max_cycle, time)
        
    for t in sorted(by_time.keys()):
        print(f"Time {t}:")
        for node in by_time[t]:
             print(f"  - {node}")
             
    print(f"\nTotal Cycles: {max_cycle}")

    # 5. Resource Allocation
    print("\n--- Running Resource Allocator ---")
    resource_allocator = ResourceAllocator(converter.cdfg, schedule)
    resource_allocator.allocate()
    
    print("\nAllocated Resources:")
    for node, resource in resource_allocator.resource_allocation.items():
        print(f"  - {node}: {resource}")
        
    print(f"\nTotal Resources Used: {resource_allocator.total_resources}")

    # 6. Register Allocation
    print("\n--- Running Register Allocation ---")
    reg_allocator = RegisterAllocator(converter.cdfg, schedule)
    registers = reg_allocator.allocate()
    print("Register Allocation:")
    for edge, reg in registers.items():
        src, dst, label = edge
        print(f"  {src} -> {dst} ({label}) : {reg}")
        
    # 7. Datapath Generation
    print("\n--- Running Datapath Generation ---")
    datapath = Datapath(resource_allocator, reg_allocator, converter.cdfg)
    datapath.create_graph()
    
    # 8. Datapath Visualization
    print("\n--- Datapath Visualization ---")
    visualizer = DatapathVisualizer(datapath)
    with open(f"{output_dir}/datapath.dot", "w") as f:
        f.write(visualizer.to_dot())
    print(f"Datapath saved to {output_dir}/datapath.dot")

    # 9. FSM Generation
    print("\n--- FSM Generation ---")
    fsm_gen = FSMGenerator(schedule, resource_allocator, reg_allocator, datapath)
    fsm_gen.generate_control_signals()
    
    # 10. VHDL Generation - outputs to generated_vhdl_test1/
    print("\n--- VHDL Generation ---")
    vhdl_gen = VHDLGenerator(fsm_gen, datapath, resource_allocator, reg_allocator)
    vhdl_gen.generate_all(output_dir)

    
if __name__ == "__main__":
    main()
