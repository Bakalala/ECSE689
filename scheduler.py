from cdfg import *

class Scheduler:
    def __init__(self, cdfg: CDFG):
        self.cdfg = cdfg
        self.schedule_table = {} # node -> start_time
    
    def schedule(self):

        nodes = self.cdfg.nodes.copy()
        # Keep track of when each RAM is busy
        ram_busy = {node.mem.name: 0 for node in nodes if isinstance(node, (LoadNode, StoreNode))}

        # Get list of predecessors for each node
        predecessors = {n: [] for n in nodes}
        for src, dst, _ in self.cdfg.edges:
            predecessors[dst].append(src)
        
        for node in nodes[:]:
            if predecessors[node] == []:
                self.schedule_table[node] = 0
                nodes.remove(node)

        time = 1

        while nodes != []:
            # Need to make a copy of schedule_table to avoid modifying it while iterating and using the wrong time
            schedule_table_copy = self.schedule_table.copy()
            for node in nodes[:]:
                if any(pred not in schedule_table_copy for pred in predecessors[node]):
                    continue
                elif isinstance(node, (LoadNode, StoreNode)) and ram_busy[node.mem.name] == 1:
                    continue
                else:
                    self.schedule_table[node] = time
                    if isinstance(node, (LoadNode, StoreNode)):
                        ram_busy[node.mem.name] = 1
                    nodes.remove(node)
            time += 1
            ram_busy.update({k: 0 for k in ram_busy})
       
            
        return self.schedule_table