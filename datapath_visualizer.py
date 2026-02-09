from datapath import Datapath, Multiplexer
from ressource import Resource, Register
from cdfg import CstNode

class DatapathVisualizer:
    def __init__(self, datapath: Datapath):
        self.datapath = datapath
        self.node_ids = {}
        self.next_id = 0

    def get_id(self, obj):
        if obj not in self.node_ids:
            # Create a unique ID for the object
            prefix = "node"
            if isinstance(obj, Register):
                prefix = "reg"
            elif isinstance(obj, Multiplexer):
                prefix = "mux"
            elif isinstance(obj, Resource):
                prefix = "res"
            elif isinstance(obj, CstNode):
                prefix = "cst"
            
            self.node_ids[obj] = f"{prefix}{self.next_id}"
            self.next_id += 1
        return self.node_ids[obj]

    def to_dot(self) -> str:
        lines = []
        lines.append("digraph Datapath {")
        lines.append("    rankdir=LR;") # Left to Right flow usually looks better for datapath
        lines.append("    node [fontname=\"Arial\"];")
        lines.append("")

        # Collect all components from edges
        components = set()
        for src, dst, label in self.datapath.edges:
            components.add(src)
            components.add(dst)

        # 1. Define Nodes with Styles
        for comp in components:
            node_id = self.get_id(comp)
            
            if isinstance(comp, CstNode):
                label = str(comp.value)
                lines.append(f"    {node_id} [label=\"{label}\", shape=circle, style=filled, fillcolor=lightgrey];")
            else:
                label = comp.name
                if isinstance(comp, Register):
                    # Registers: Box, Blueish
                    lines.append(f"    {node_id} [label=\"{label}\", shape=box, style=filled, fillcolor=lightblue];")
                elif isinstance(comp, Multiplexer):
                    # Muxes: Trapezium (if supported) or InvTrapezium or Diamond. Let's use trapezium or just a shape.
                    # 'invtrapezium' is often used for Muxes in schematics.
                    lines.append(f"    {node_id} [label=\"{label}\", shape=invtrapezium, style=filled, fillcolor=lightyellow];")
                elif isinstance(comp, Resource):
                    # Resources: Ellipse or Rounded Box, Greenish
                    lines.append(f"    {node_id} [label=\"{label}\\n({comp.type.__name__})\", shape=ellipse, style=filled, fillcolor=lightgreen];")
                else:
                    lines.append(f"    {node_id} [label=\"{label}\"];")

        lines.append("")

        # 2. Define Edges
        for src, dst, label in self.datapath.edges:
            src_id = self.get_id(src)
            dst_id = self.get_id(dst)
            
            # Formatting edge label
            # If label is "in" or "out" maybe hide it to reduce clutter? 
            # Or keeps it small.
            lbl_attr = f" [label=\"{label}\", fontsize=10]" if label else ""
            
            lines.append(f"    {src_id} -> {dst_id}{lbl_attr};")

        lines.append("}")
        return "\n".join(lines)
