#!/bin/bash

echo "Starting Execution of All Tests..."
echo "=================================="

# Iterate over all directories matching the pattern generated_vhdl_test*
for test_dir in generated_vhdl_test*/; do
    # Remove trailing slash
    test_dir=${test_dir%/}
    
    if [ -d "$test_dir" ]; then
        echo ""
        echo "----------------------------------"
        echo "Running $test_dir"
        echo "----------------------------------"
        
        # Enter directory
        cd "$test_dir"
        
        # Check if run.sh exists and make it executable if needed
        if [ -f "run.sh" ]; then
            chmod +x run.sh
            ./run.sh
        else
            echo "Error: run.sh not found in $test_dir"
        fi
        
        # Return to root
        cd ..
    fi
done

echo ""
echo "=================================="
echo "All Tests Completed."
echo "=================================="
