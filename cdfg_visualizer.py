from cdfg import *

# Made with AI

class DOTVisualizer:
    def __init__(self, cdfg: CDFG):
        self.cdfg = cdfg
        self.node_ids = {}
        self.next_id = 0
    
    def get_id(self, node):
        if node not in self.node_ids:
            self.node_ids[node] = f"node{self.next_id}"
            self.next_id += 1
        return self.node_ids[node]

    def to_dot(self) -> str:
        lines = []
        lines.append("digraph G {")
        lines.append("    rankdir=TB;")
        # Provide some default node styling
        lines.append("    node [shape=box, fontname=\"Arial\"];")
        
        # Define nodes
        for node in self.cdfg.nodes:
            lbl = self._get_label(node)
            node_id = self.get_id(node)
            lines.append(f"    {node_id} [label=\"{lbl}\"];")
            
        # Define edges
        for src, dst, label in self.cdfg.edges:
            src_id = self.get_id(src)
            dst_id = self.get_id(dst)
            label_attr = f" [label=\"{label}\"]" if label else ""
            lines.append(f"    {src_id} -> {dst_id}{label_attr};")
            
        lines.append("}")
        return "\n".join(lines)
    
    def _get_label(self, node: DFGNode) -> str:
        if isinstance(node, CstNode):
            return f"{node.value}"
        elif isinstance(node, AddNode):
            return "+"
        elif isinstance(node, MulNode):
            return "*"
        elif isinstance(node, LoadNode):
            return f"Load\\n[{node.mem.name}]"
        elif isinstance(node, StoreNode):
            return f"Store\\n[{node.mem.name}]"
        else:
            return str(type(node).__name__)
