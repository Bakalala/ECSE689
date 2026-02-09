from dataclasses import dataclass
from collections import defaultdict
from typing import List
from ressource import *
from cdfg import *


class Datapath:

    def __init__(self, resource_allocator: ResourceAllocator, register_allocator: RegisterAllocator, cdfg: CDFG):
        self.resource_allocator = resource_allocator
        self.register_allocator = register_allocator
        self.cdfg = cdfg
        self.muxes = []
        self.edges = [] 


    def create_graph(self):
        # Determine Mux inputs from CDFG edges
        port_inputs = defaultdict(list)  # (Resource, port_label) -> [Register | Resource | CstNode]
        
        for src, dst, label in self.cdfg.edges:
            if label == "dep":
                continue

            # Destination Resource
            dst_resource = self.resource_allocator.resource_allocation.get(dst)
            if not dst_resource:
                continue

            # Check if there's a register for this edge so we dont have duplicate
            reg = self.register_allocator.register_allocation.get((src, dst, label))
            
            if reg:
                # Connected via Register
                if reg not in port_inputs[(dst_resource, label)]:
                    port_inputs[(dst_resource, label)].append(reg)
                
                # Also add edge for visualization: Source Resource -> Register
                src_resource = self.resource_allocator.resource_allocation.get(src)
                if src_resource:
                    # Check if edge already exists
                    if (src_resource, reg, "out") not in self.edges:
                        self.edges.append((src_resource, reg, "out"))
            else:
                # Direct connection (Wire)
                # Input source is the Source Resource or the Constant Node itself
                if isinstance(src, CstNode):
                    if src not in port_inputs[(dst_resource, label)]:
                        port_inputs[(dst_resource, label)].append(src)
                else:
                    src_resource = self.resource_allocator.resource_allocation.get(src)
                    if src_resource:
                        if src_resource not in port_inputs[(dst_resource, label)]:
                            port_inputs[(dst_resource, label)].append(src_resource)
                    else:
                        print(f"Warning: No resource found for source {src} in direct connection")

        
        # Insert Muxes where needed
        for (res, label), inputs in port_inputs.items():
            mux = Multiplexer("Mux_{}_{}".format(res.name, label), inputs)
            self.muxes.append(mux)
            self.edges.append((mux, res, label))
            for inp in inputs:
                self.edges.append((inp, mux, "in"))

 