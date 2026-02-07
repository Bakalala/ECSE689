from typing import Dict
from ast_nodes import *

# Got some help with AI :)

class Interpreter:
    def __init__(self):
        # Dictionary of RAMS, where the list stores the values of each RAM
        self.memory_store = {}
        # Variable environment
        self.env = {}

    def allocate(self, mem_node, init_values = None):
        # Initialize the RAM with init_values or 0s
        # init_values is a dictionary of {address: value}
        self.memory_store[mem_node] = [0] * mem_node.size
        if init_values:
            for addr, val in init_values.items():
                if 0 <= addr < mem_node.size:
                    self.memory_store[mem_node][addr] = val
                else:
                    raise IndexError(f"Initialization address {addr} out of bounds for memory size {mem_node.size}")

    def eval_expr(self, node: Expr):
        if isinstance(node, Cst):
            return node.value
            
        elif isinstance(node, Add):
            return self.eval_expr(node.left) + self.eval_expr(node.right)
            
        elif isinstance(node, Mul):
            return self.eval_expr(node.left) * self.eval_expr(node.right)
            
        elif isinstance(node, Load):
            addr = self.eval_expr(node.addr)
            if node.mem not in self.memory_store:
                raise RuntimeError("Memory not allocated")
            
            mem_array = self.memory_store[node.mem]
            if 0 <= addr < len(mem_array):
                return mem_array[addr]
            else:
                raise IndexError(f"Load address {addr} out of bounds")
        
        elif isinstance(node, VarLoad):
            if node.var not in self.env:
                raise RuntimeError(f"Variable '{node.var.name}' not defined")
            return self.env[node.var]
        
        else:
            raise NotImplementedError(f"Unknown expression node: {type(node)}")

    def exec_stmt(self, node: Stmt):
        if isinstance(node, Store):
            addr = self.eval_expr(node.addr)
            val = self.eval_expr(node.val)
            
            if node.mem not in self.memory_store:
                raise RuntimeError("Memory not allocated")
                
            mem_array = self.memory_store[node.mem]
            if 0 <= addr < len(mem_array):
                mem_array[addr] = val
            else:
                raise IndexError(f"Store address {addr} out of bounds")
        elif isinstance(node, Block):
            for stmt in node.stmts:
                self.exec_stmt(stmt)
        elif isinstance(node, VarStore):
            val = self.eval_expr(node.val)
            self.env[node.var] = val
            
        else:
            raise NotImplementedError(f"Unknown statement node: {type(node)}")
