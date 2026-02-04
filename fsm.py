from collections import defaultdict
from cdfg import StoreNode, LoadNode


class FSMGenerator:
    def __init__(self, schedule: dict, resource_allocator, register_allocator, datapath):
        self.schedule = schedule
        self.resource_allocator = resource_allocator
        self.register_allocator = register_allocator
        self.datapath = datapath
        self.max_time = max(schedule.values()) if schedule else 0
        self.control_by_state = {}

    def generate_control_signals(self):
        """For each state, generate: reg enables, mem ops, mux selects."""

        # Group nodes by time
        nodes_by_time = defaultdict(list)
        for node, time in self.schedule.items():
            nodes_by_time[time].append(node)
        
        for t in range(self.max_time + 1):
            reg_enables = []
            mem_ops = {}  # mem_name -> 'read' or 'write'
            mux_selects = {}
            
            for node in nodes_by_time[t]:
                # 1. Register enables
                if not isinstance(node, StoreNode):
                    for edge, reg in self.register_allocator.register_allocation.items():
                        src, dst, label = edge
                        if src == node:
                            reg_enables.append(reg)
                
                # 2. Memory ops (one per memory per cycle)
                if isinstance(node, LoadNode):
                    res = self.resource_allocator.resource_allocation.get(node)
                    if res:
                        mem_ops[res.name] = 'read'
                elif isinstance(node, StoreNode):
                    res = self.resource_allocator.resource_allocation.get(node)
                    if res:
                        mem_ops[res.name] = 'write'
                
                # 3. Mux selects
                res = self.resource_allocator.resource_allocation.get(node)
                if res: # check not a CST node. 
                    for (src, dst, label), reg in self.register_allocator.register_allocation.items():
                        if dst == node:
                            for mux in self.datapath.muxes:
                                if mux.name == "Mux_{}_{}".format(res.name, label):
                                    if reg in mux.inputs:
                                        mux_selects[mux.name] = mux.inputs.index(reg)
            
            self.control_by_state[t] = {
                'reg_enables': reg_enables,
                'mem_ops': mem_ops,
                'mux_selects': mux_selects
            }

            print("State {}: {}".format(t, self.control_by_state[t]))

        return self.control_by_state
        
