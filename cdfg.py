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
        
    def convert(self, node: ASTNode) -> DFGNode:
        if isinstance(node, Cst):
            # Create constant node
            dfg_node = CstNode(node.value)
            self.cdfg.add_node(dfg_node)
            return dfg_node
            
        elif isinstance(node, Add):
            left = self.convert(node.left)
            right = self.convert(node.right)
            dfg_node = AddNode()
            self.cdfg.add_node(dfg_node)
            self.cdfg.add_edge(left, dfg_node, "left")
            self.cdfg.add_edge(right, dfg_node, "right")
            return dfg_node
            
        elif isinstance(node, Mul):
            left = self.convert(node.left)
            right = self.convert(node.right)
            dfg_node = MulNode()
            self.cdfg.add_node(dfg_node)
            self.cdfg.add_edge(left, dfg_node, "left")
            self.cdfg.add_edge(right, dfg_node, "right")
            return dfg_node
            
        elif isinstance(node, Load):
            # addr can be an expression, need to convert 
            addr = self.convert(node.addr)
            dfg_node = LoadNode(node.mem)
            self.cdfg.add_node(dfg_node)
            self.cdfg.add_edge(addr, dfg_node, "addr")
            return dfg_node
            
        elif isinstance(node, Store):
            # addr can be an expression, need to convert 
            addr = self.convert(node.addr)
            val = self.convert(node.val)
            dfg_node = StoreNode(node.mem)
            self.cdfg.add_node(dfg_node)
            self.cdfg.add_edge(addr, dfg_node, "addr")
            self.cdfg.add_edge(val, dfg_node, "data")
            return dfg_node
        elif isinstance(node, Block):
            for stmt in node.stmts:
                self.convert(stmt)
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
            val = self.convert(node.val)
            dfg_node = VarStoreNode(node.var)
            self.cdfg.add_node(dfg_node)
            self.cdfg.add_edge(val, dfg_node, "data")
            
            # Dependency on previous store/load to same variable
            if node.var in self.var_dependency:
                self.cdfg.add_edge(self.var_dependency[node.var], dfg_node, "dep")
                
            self.var_dependency[node.var] = dfg_node
            return dfg_node
            
        else:
            raise NotImplementedError(f"Conversion not implemented for {type(node)}")
