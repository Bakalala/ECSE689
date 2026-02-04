#!/bin/bash

echo "Starting Execution of All Tests..."
echo "=================================="

# List of test directories
tests=("generated_vhdl_test0" "generated_vhdl_test1" "generated_vhdl_test2" "generated_vhdl_test3" "generated_vhdl_test4")

for test_dir in "${tests[@]}"; do
    if [ -d "$test_dir" ]; then
        echo ""
        echo "----------------------------------"
        echo "Running $test_dir"
        echo "----------------------------------"
        cd "$test_dir"
        
        # Check if run.sh exists and make it executable if needed
        if [ -f "run.sh" ]; then
            chmod +x run.sh
            ./run.sh
        else
            echo "Error: run.sh not found in $test_dir"
        fi
        
        cd ..
    else
        echo "Warning: Directory $test_dir does not exist."
    fi
done

echo ""
echo "=================================="
echo "All Tests Completed."
echo "=================================="
