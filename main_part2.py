from ast_nodes import *
from interpreter import Interpreter
from cdfg import ASTToCDFG
from cdfg_visualizer import DOTVisualizer


def main():
    print("--- Defining AST ---")
    
    # Initizalize RAM
    ram = Mem(size=1024, name="RAM")
    
    # RAM[3] = RAM[0] * RAM[1] + RAM[2]
    # Do it twice, once for each block
    program = Block(
        [Store(
            mem=ram,
            addr=Cst(3),
            val=Add(
                left=Mul(
                    left=Load(ram, Cst(0)),
                    right=Load(ram, Cst(1))
                ),
                right=Load(ram, Cst(2))
            )
        ),
        Store(
            mem=ram,
            addr=Cst(4),
            val=Add(
                left=Mul(
                    left=Load(ram, Cst(0)),
                    right=Load(ram, Cst(1))
                ),
                right=Load(ram, Cst(2))
            )
        )
        ]
    )
    
    print("AST constructed successfully.")
    
    # 3. Interpreter Test
    print("\n--- Running Interpreter ---")
    interp = Interpreter()
    
    # Initialize Memory: RAM[0]=4, RAM[1]=5, RAM[2]=1
    # Expected result: RAM[3] = 4*5 + 1 = 21
    expected_result = 21
    init_data = {
        0: 4,
        1: 5,
        2: 1
    }
    
    print(f"Initializing Memory with: {init_data}")
    interp.allocate(ram, init_values=init_data)
    
    print("Executing program...")
    interp.exec_stmt(program)
    
    # Check result
    result = interp.memory_store[ram][3]
    print(f"Result at RAM[3]: {result}")
    
    if result == expected_result:
        print("SUCCESS: Calculation correct.")
    else:
        print(f"FAILURE: Expected {expected_result}, got {result}")

    # 4. CDFG Generation
    print("\n--- Generating CDFG ---")
    converter = ASTToCDFG()
    converter.convert(program)
    print("CDFG generated.")
    
    # 5. DOT Visualization
    print("\n--- Generating DOT ---")
    viz = DOTVisualizer(converter.cdfg)
    dot_output = viz.to_dot()
    print("DOT Output:")
    print(dot_output)
    
    # Optional: Write to file
    with open("output.dot", "w") as f:
        f.write(dot_output)
    print("\nSaved to output.dot")

if __name__ == "__main__":
    main()
