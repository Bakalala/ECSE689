from cdfg import *

class Scheduler:
    def __init__(self, cdfg: CDFG):
        self.cdfg = cdfg
        self.schedule_table = {} # node -> start_time
    
    def schedule(self, chain=False):
        nodes = self.cdfg.nodes.copy()

        # Get list of predecessors for each node
        predecessors = {n: [] for n in nodes}
        for src, dst, _ in self.cdfg.edges:
            predecessors[dst].append(src)
        
        time = 0

        while nodes and not chain:
            ram_busy = set()
            # Sort to process instant nodes first: allows chaining in a single pass
            nodes.sort(key=lambda n: not isinstance(n, (CstNode, VarLoadNode)))
            
            for node in nodes[:]:
                # 1. Wait for all predecessors to be scheduled
                if not all(p in self.schedule_table for p in predecessors[node]):
                    continue
                
                # 2. RAM Port constraint: One op per RAM per cycle
                if isinstance(node, (LoadNode, StoreNode)) and node.mem.name in ram_busy:
                    continue
                
                # 3. Timing constraint: 
                # Ignore node if any of its predecessors are scheduled in this cycle except CstNode and VarLoadNode
                if any(self.schedule_table[p] == time and not isinstance(p, (CstNode, VarLoadNode)) 
                       for p in predecessors[node]):
                    continue
                
                self.schedule_table[node] = time
                if isinstance(node, (LoadNode, StoreNode)):
                    ram_busy.add(node.mem.name)
                nodes.remove(node)
                
            time += 1

        while nodes and chain:
            ram_busy = set()
            changed = True
            while changed:
                changed = False
                nodes.sort(key=lambda n: not isinstance(n, (CstNode, VarLoadNode)))

                for node in nodes[:]:
                    # 1. Dependency Check
                    if not all(p in self.schedule_table for p in predecessors[node]):
                        continue
                    
                    # 2. RAM Resource Check
                    if isinstance(node, (LoadNode, StoreNode)) and node.mem.name in ram_busy:
                        continue
                    
                    must_wait = False
                    for p in predecessors[node]:
                        if self.schedule_table[p] == time:
                                # Block on synchronous updates (Store, VarStore)
                                if isinstance(p, (VarStoreNode, StoreNode)):
                                    must_wait = True
                                    break
                    
                    if must_wait:
                        continue
                    
                    self.schedule_table[node] = time
                    if isinstance(node, (LoadNode, StoreNode)):
                        ram_busy.add(node.mem.name)
                    nodes.remove(node)
                    changed = True
            
            time += 1
            
        return self.schedule_table