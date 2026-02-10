from typing import List
from dataclasses import dataclass, field
from ast_nodes import *

# --- DFG Nodes ---
# Need eq=False in order for vizualier.py to work correctly 

class DFGNode:
    pass

@dataclass(eq=False)
class CstNode(DFGNode):
    value: int

@dataclass(eq=False)
class AddNode(DFGNode):
    pass

@dataclass(eq=False)
class MulNode(DFGNode):
    pass

@dataclass(eq=False)
class LoadNode(DFGNode):
    mem: Mem

@dataclass(eq=False)
class StoreNode(DFGNode):
    mem: Mem

@dataclass(eq=False)
class VarLoadNode(DFGNode):
    var: Var

@dataclass(eq=False)
class VarStoreNode(DFGNode):
    var: Var



# --- Graph Structure ---

@dataclass
class CDFG:
    nodes: List[DFGNode] = field(default_factory=list)
    edges: List[tuple] = field(default_factory=list) # List of (src, dst, label)
    
    def add_node(self, node: DFGNode):
        self.nodes.append(node)
        
    def add_edge(self, src: DFGNode, dst: DFGNode, label: str = ""):
        self.edges.append((src, dst, label))

# --- Converter ---

class ASTToCDFG:
    def __init__(self):
        self.cdfg = CDFG()
        self.var_dependency = {} # track if Var has dependency on other node
        self.cse_cache = {} # Cache for Common Subexpression Elimination: key -> DFGNode

    def convert(self, node: ASTNode, com_sub_el=False) -> DFGNode:
        if isinstance(node, Cst):
            # CSE Check
            key = ('Cst', node.value)
            if com_sub_el and key in self.cse_cache:
                return self.cse_cache[key]
                
            # Create constant node
            dfg_node = CstNode(node.value)
            self.cdfg.add_node(dfg_node)
            
            if com_sub_el:
                self.cse_cache[key] = dfg_node
                
            return dfg_node
            
        elif isinstance(node, Add):
            left = self.convert(node.left, com_sub_el)
            right = self.convert(node.right, com_sub_el)
            
            # Use frozenset for commutativity: A+B == B+A
            key = ('Add', frozenset([left, right]))
            if com_sub_el and key in self.cse_cache:
                return self.cse_cache[key]
                
            dfg_node = AddNode()
            self.cdfg.add_node(dfg_node)
            self.cdfg.add_edge(left, dfg_node, "left")
            self.cdfg.add_edge(right, dfg_node, "right")
            
            if com_sub_el:
                self.cse_cache[key] = dfg_node
                
            return dfg_node
            
        elif isinstance(node, Mul):
            left = self.convert(node.left, com_sub_el)
            right = self.convert(node.right, com_sub_el)
            
            key = ('Mul', frozenset([left, right]))
            if com_sub_el and key in self.cse_cache:
                return self.cse_cache[key]

            dfg_node = MulNode()
            self.cdfg.add_node(dfg_node)
            self.cdfg.add_edge(left, dfg_node, "left")
            self.cdfg.add_edge(right, dfg_node, "right")
            
            if com_sub_el:
                self.cse_cache[key] = dfg_node

            return dfg_node
            
        elif isinstance(node, Load):
            # addr can be an expression, need to convert 
            addr = self.convert(node.addr, com_sub_el)

            key = ('Load', node.mem, addr)
            if com_sub_el and key in self.cse_cache:
                return self.cse_cache[key]
                
            dfg_node = LoadNode(node.mem)
            self.cdfg.add_node(dfg_node)
            self.cdfg.add_edge(addr, dfg_node, "addr")
            
            if com_sub_el:
                self.cse_cache[key] = dfg_node

            return dfg_node
            
        elif isinstance(node, Store):
            # addr can be an expression, need to convert 
            addr = self.convert(node.addr, com_sub_el)
            val = self.convert(node.val, com_sub_el)
            dfg_node = StoreNode(node.mem)
            self.cdfg.add_node(dfg_node)
            self.cdfg.add_edge(addr, dfg_node, "addr")
            self.cdfg.add_edge(val, dfg_node, "data")
            return dfg_node
        elif isinstance(node, Block):
            for stmt in node.stmts:
                self.convert(stmt, com_sub_el)
            return None
            
        elif isinstance(node, VarLoad):
            dfg_node = VarLoadNode(node.var)
            self.cdfg.add_node(dfg_node)
            # Dependency on previous store/load to same variable
            if node.var in self.var_dependency:
                self.cdfg.add_edge(self.var_dependency[node.var], dfg_node, "dep")
            
            self.var_dependency[node.var] = dfg_node # handles write after read
            return dfg_node
            
        elif isinstance(node, VarStore):
            val = self.convert(node.val, com_sub_el)
            dfg_node = VarStoreNode(node.var)
            self.cdfg.add_node(dfg_node)
            self.cdfg.add_edge(val, dfg_node, "data")
            
            # Dependency on previous store/load to same variable
            if node.var in self.var_dependency:
                self.cdfg.add_edge(self.var_dependency[node.var], dfg_node, "dep")
                
            self.var_dependency[node.var] = dfg_node
            return dfg_node
            
        elif isinstance(node, For):
            # Unroll the loop and create new nodes for each iteration
            for k in range(node.itNum.value):
                # Next iteration's VarStore(itVar) must run after previous body completes
                cst_k = self.convert(Cst(k), com_sub_el)
                
                var_store = VarStoreNode(node.itVar)
                self.cdfg.add_node(var_store)
                self.cdfg.add_edge(cst_k, var_store, "data")
                
                # Dependencies for the loop variable store (same-var ordering)
                if node.itVar in self.var_dependency:
                    self.cdfg.add_edge(self.var_dependency[node.itVar], var_store, "dep")
                self.var_dependency[node.itVar] = var_store
                
                # Convert body; its last node becomes dependency for next iteration's VarStore(itVar)
                self.convert(node.body, com_sub_el)
            
            return None

        else:
            raise NotImplementedError(f"Conversion not implemented for {type(node)}")
