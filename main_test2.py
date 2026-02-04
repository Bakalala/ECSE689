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
    output_dir = "generated_vhdl_test2"
    print("--- Test 2: MODIFY THIS DESCRIPTION ---")
    

    # A = malloc(4);
    # B = malloc(4);
    # C = malloc(4);
    # C[0] = A[0] * B[0];
    # C[1] = A[1] * B[1];
    # C[2] = A[2] * B[2];
    # C[3] = A[3] * B[3];

    # 1. Define Memory
    ramA = Mem(size=4, name="A")
    ramB = Mem(size=4, name="B")
    ramC = Mem(size=4, name="C")

    # 2. Build the AST
    program = Block([
        Store(
        mem=ramC,
        addr=Cst(0),
        val=Mul(
            left=Load(ramA, Cst(0)),
            right=Load(ramB, Cst(0))
        )
    ),
    Store(
        mem=ramC,
        addr=Cst(1),
        val=Mul(
            left=Load(ramA, Cst(1)),
            right=Load(ramB, Cst(1))
        )
    ),
    Store(
        mem=ramC,
        addr=Cst(2),
        val=Mul(
            left=Load(ramA, Cst(2)),
            right=Load(ramB, Cst(2))
        )
    ),
    Store(
        mem=ramC,
        addr=Cst(3),
        val=Mul(
            left=Load(ramA, Cst(3)),
            right=Load(ramB, Cst(3))
        )
    )
    ])
    
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
    schedule = scheduler.schedule()
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
    reg_allocator = RegisterAllocator(converter.cdfg)
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
    
    # 10. VHDL Generation - outputs to generated_vhdl_test2/
    print("\n--- VHDL Generation ---")
    vhdl_gen = VHDLGenerator(fsm_gen, datapath, resource_allocator, reg_allocator)
    vhdl_gen.generate_all(output_dir)

    
if __name__ == "__main__":
    main()
