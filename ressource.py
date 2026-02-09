from ast_nodes import *
from dataclasses import dataclass
from cdfg import *
from collections import defaultdict
import copy


class Resource:
    def __init__(self, name: str, type: str, inputs: list = None, outputs: list = None):
        self.name = name
        self.type = type
        self.inputs = inputs if inputs is not None else []
        self.outputs = outputs if outputs is not None else []

        # later we will use this to insatiate entities in VHDL

    # to print the resource type nicely
    def __repr__(self):
        return f"Resource({self.name}, {self.type})"
        # return f"Resource({self.name}, {self.type}, in={self.inputs}, out={self.outputs})"
    

class ResourceAllocator:
    def __init__(self, cdfg: CDFG, schedule: dict):
        self.cdfg = cdfg
        self.schedule = schedule
        self.resource_allocation = defaultdict(list)
        self.available_resources = defaultdict(list)
        self.mem_sizes = {} # Helps with to VHDL
        self.total_resources = 0
        self.add_count = 0
        self.mul_count = 0

    def allocate(self):

        ressources_per_cycle = [[node for node, t in self.schedule.items() if t == time] for time in range(max(self.schedule.values()) + 1)]

        for time in ressources_per_cycle:
            available_resources_time = {k: v[:] for k, v in self.available_resources.items()}
            for node in time:
                # Check if there are available resources of the same type
                if isinstance(node, (AddNode, MulNode)):
                    if type(node) in available_resources_time and len(available_resources_time[type(node)]) > 0:
                        resource = available_resources_time[type(node)].pop()
                        self.resource_allocation[node] = resource
                    else:
                        # Create new resource since none are available
                        resource_name = "Add_{}".format(self.add_count) if isinstance(node, AddNode) else "Mul_{}".format(self.mul_count)
                        # What to do with inputs and outputs?
                        resource = Resource(resource_name, type(node))
                        self.total_resources += 1
                        # Add resource to available resources dic for future use
                        self.available_resources[type(node)].append(resource)
                        # Allocate resource to node
                        self.resource_allocation[node] = resource

                        if isinstance(node, AddNode):
                            self.add_count += 1
                        elif isinstance(node, MulNode):
                            self.mul_count += 1
                elif isinstance(node, (LoadNode, StoreNode)):
                    if node.mem.name in available_resources_time and len(available_resources_time[node.mem.name]) > 0:
                        resource = available_resources_time[node.mem.name].pop()
                        self.resource_allocation[node] = resource
                    else:
                        # Create new resource since none are available
                        resource = Resource(node.mem.name, type(node.mem))
                        self.total_resources += 1
                        self.mem_sizes[node.mem.name] = node.mem.size
                        # Add resource to available resources dic for future use
                        self.available_resources[node.mem.name].append(resource)
                        # Allocate resource to node
                        self.resource_allocation[node] = resource

                elif isinstance(node, (VarLoadNode, VarStoreNode)):
                    var_key = f"Var_{node.var.name}" 
                    if var_key in self.available_resources and len(self.available_resources[var_key]) > 0:
                        resource = self.available_resources[var_key][0]
                        self.resource_allocation[node] = resource
                    else:
                        resource = Resource(var_key, type(node.var))
                        self.total_resources += 1
                        self.available_resources[var_key].append(resource)
                        self.resource_allocation[node] = resource

                # Fill inputs and outputs for the resource based on the current assigned node
                if node in self.resource_allocation:
                    res = self.resource_allocation[node]
                    # Inputs: edges where dst is current node
                    for src, dst, label in self.cdfg.edges:
                        if dst == node:
                            res.inputs.append((src, label))
                        if src == node:
                            res.outputs.append((dst, label))


        return self.resource_allocation


class Register:
    def __init__(self, name: str, is_wire: bool = False):
        self.name = name
        self.is_wire = is_wire

    def __repr__(self):
        return f"{self.name}{'(W)' if self.is_wire else ''}"

class RegisterAllocator:
    def __init__(self, cdfg: CDFG, schedule: dict = None):
        self.cdfg = cdfg
        self.schedule = schedule
        self.register_allocation = {}
        self.reg_count = 0
        
    def allocate(self):

        for src, dst, label in self.cdfg.edges:
            if label == "dep":
                continue

            # Determine if this should be a wire (intra-cycle) or register (inter-cycle)
            is_wire = False
            if self.schedule is not None:
                # If both are scheduled in same cycle, use wire
                if src in self.schedule and dst in self.schedule:
                    if self.schedule[src] == self.schedule[dst]:
                        is_wire = True

            if not is_wire and isinstance(src, (CstNode, AddNode, MulNode, LoadNode, VarLoadNode)):
                reg_name = "R{}".format(self.reg_count)
                param_reg= Register(reg_name)
                self.reg_count += 1
                self.register_allocation[(src, dst, label)] = param_reg
        
        return self.register_allocation


class Multiplexer:
    def __init__(self, name: str, inputs: List[Resource]):
        self.name = name
        self.inputs = inputs
    
    def __repr__(self):
        return f"Mux({self.name}, inputs={len(self.inputs)})"
