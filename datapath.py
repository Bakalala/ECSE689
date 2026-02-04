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
        # For each edge in register allocation: Register connects src to dst
        # Group by (destination_resource, input_port) to find where muxes are needed
        port_inputs = defaultdict(list)  # (Resource, port_label) -> [Registers]
        
        for (src, dst, label), reg in self.register_allocator.register_allocation.items():
            # get all Register -> Resource  
            dst_resource = self.resource_allocator.resource_allocation.get(dst)
            if dst_resource:
                port_inputs[(dst_resource, label)].append(reg)
            
            # Resource -> Register (output connection)        
            src_resource = self.resource_allocator.resource_allocation.get(src)
            if src_resource:
                self.edges.append((src_resource, reg, "out"))
        
        # Insert Muxes where needed
        for (res, label), registers in port_inputs.items():
            mux = Multiplexer("Mux_{}_{}".format(res.name, label), registers)
            self.muxes.append(mux)
            self.edges.append((mux, res, label))
            for reg in registers:
                self.edges.append((reg, mux, "in"))

 