"""
VHDL Code Generator for HLS Pipeline
Generates: Design (Controller + Datapath with component instantiation), Testbench
Uses external components: dual_port_RAM.vhdl, adder.vhdl, multiplier.vhdl
"""
from cdfg import *

class VHDLGenerator:
    def __init__(self, fsm_generator, datapath, resource_allocator, register_allocator):
        self.fsm = fsm_generator
        self.datapath = datapath
        self.resource_allocator = resource_allocator
        self.register_allocator = register_allocator
        self.control = fsm_generator.control_by_state
        self.max_time = fsm_generator.max_time
        self.collect_signals()
        self.DATA_WIDTH = 32

    def collect_signals(self):
        """Collect all control signal names and memory sizes from FSM and CDFG."""
        self.all_reg_enables = set()
        self.all_mems = set()
        self.all_mux_selects = set()
        self.mem_sizes = {}
        
        for signals in self.control.values():
            for reg in signals['reg_enables']:
                # Filter out wires (though they shouldn't exist in register_allocation anymore)
                if not getattr(reg, 'is_wire', False):
                    self.all_reg_enables.add(reg.name)
            for mem_name in signals['mem_ops']:
                self.all_mems.add(mem_name)
            for mux_name in signals['mux_selects']:
                self.all_mux_selects.add(mux_name)
        
        # Identify variable resources
        self.all_vars = set()
        resources = set(self.resource_allocator.resource_allocation.values())
        for res in resources:
            if res.name.startswith("Var_"):
                self.all_vars.add(res)
                
        # Get memory sizes from resource allocator instead of rescanning
        self.mem_sizes = self.resource_allocator.mem_sizes
        
        self.mux_widths = {}
        for mux in self.datapath.muxes:
            # Need a minus one since bit_length doesnt account for 0 index.
            width = self.bits_needed(len(mux.inputs))
            self.mux_widths[mux.name] = width
            
        # from 0 to max_time (that needs a +1) + end state
        self.state_bits = (self.max_time + 2).bit_length()
        
    def bits_needed(self, count):
        """Calculate bits needed to represent 'count' items (0 to count-1)."""
        return max(1, (count - 1).bit_length())

    def get_signal_name(self, obj) -> str:
        """Resolve VHDL signal name for a Mux input object (Register, Resource, or CstNode)."""
        if isinstance(obj, CstNode):
            return f"std_logic_vector(to_signed({obj.value}, DATA_WIDTH))"
        
        # Check if it has a 'name' attribute (Resource or Register)
        if hasattr(obj, 'name'):
            name = obj.name
            
            # 1. Register
            if name.startswith("R"):
                return f"{name}_out"
            
            # 2. Variable Resource
            if name.startswith("Var_"):
                return f"{name}_reg"
            
            # 3. Arithmetic Resource (Add, Mul)
            if name.startswith("Add_") or name.startswith("Mul_"):
                return f"{name}_out"
            
            # 4. Memory Resource (Load/Store)
            # Check if name is in known memories
            if name in self.all_mems:
                 return f"{name}_dout"
            
            # Fallback for unrecognized resources
            return f"{name}_out"
            
        return "UNKNOWN_SIGNAL"


    def generate_design(self) -> str:
        """Generate combined Controller + Datapath with component instantiation."""
        L = []
        L.append("-- HLS Generated Design")
        L.append("library IEEE;")
        L.append("use IEEE.STD_LOGIC_1164.ALL;")
        L.append("use IEEE.NUMERIC_STD.ALL;")
        L.append("")
        L.append("entity Design is")
        L.append("    Port ( clk, rst : in STD_LOGIC;")
        L.append(f"           state_out : out STD_LOGIC_VECTOR({self.state_bits - 1} downto 0);")
        L.append("           done : out STD_LOGIC);")
        L.append("end Design;")
        L.append("")
        L.append("architecture Behavioral of Design is")
        L.append("")
        
        # Constants
        L.append(f"    constant DATA_WIDTH : integer := {self.DATA_WIDTH};")
        L.append("")
        
        # Sort helper for register names so R6 is before R10
        def reg_sort_key(r):
            name = r.name if hasattr(r, 'name') else r
            return int(name[1:]) if name[1:].isdigit() else 0
        
        # State type
        states = [f"S{t}" for t in range(self.max_time + 1)] + ["S_END"]
        L.append(f"    type state_type is ({', '.join(states)});")
        L.append("    signal state : state_type := S0;")
        L.append("")
        
        # Registers - Need to initialize to 0 
        all_regs = sorted(set(self.register_allocator.register_allocation.values()), key=reg_sort_key)
        L.append("    -- Registers")
        for reg in all_regs:
            # We don't expect any wires here now
            if not getattr(reg, 'is_wire', False):
                L.append(f"    signal {reg.name}_en : STD_LOGIC;")
                L.append(f"    signal {reg.name}_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');")

        L.append("")

        L.append("    -- Variable registers")
        for var_res in sorted(self.all_vars, key=lambda v: v.name):
            L.append(f"    signal {var_res.name}_reg : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');")
            L.append(f"    signal {var_res.name}_en : STD_LOGIC;")
        L.append("")
        
        # Memory signals (using std_logic_vector for dual_port_RAM)
        # Dont need to initialize to 0
        L.append("    -- Memory signals")
        for mem in sorted(self.all_mems):
            size = self.mem_sizes[mem]
            addr_bits = self.bits_needed(size)
            L.append(f"    signal {mem}_we : STD_LOGIC;")
            L.append(f"    signal {mem}_addr_wr : STD_LOGIC_VECTOR({addr_bits-1} downto 0);")
            L.append(f"    signal {mem}_addr_rd : STD_LOGIC_VECTOR({addr_bits-1} downto 0);")
            L.append(f"    signal {mem}_din : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);")
            L.append(f"    signal {mem}_dout : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);")
        L.append("")
        
        # Mux signals - Need to initialize to 0
        L.append("    -- Multiplexer signals")
        for mux in self.datapath.muxes:
            width = self.mux_widths[mux.name]
            L.append(f"    signal {mux.name}_sel : STD_LOGIC_VECTOR({width - 1} downto 0);")
            L.append(f"    signal {mux.name}_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');")
        L.append("")
        
        # Arithmetic resources signals
        resources = set(self.resource_allocator.resource_allocation.values())
        adders = sorted([r for r in resources if 'Add' in r.name], key=lambda r: r.name)
        multipliers = sorted([r for r in resources if 'Mul' in r.name], key=lambda r: r.name)
        
        L.append("    -- Operators resources signals")
        for res in adders + multipliers:
            L.append(f"    signal {res.name}_a, {res.name}_b : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);")
            L.append(f"    signal {res.name}_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);")
        L.append("")
        
        # State encoding function
        L.append("    function encode_state(s: state_type) return STD_LOGIC_VECTOR is")
        L.append("    begin")
        L.append("        case s is")
        for i, s in enumerate(states):
            L.append(f"            when {s} => return std_logic_vector(to_unsigned({i}, {self.state_bits}));")
        L.append("        end case;")
        L.append("    end function;")
        L.append("")
        L.append("begin")
        L.append("")
        
        # ========== COMPONENT INSTANTIATIONS ==========
        L.append("    -- ========== Component Instantiations ==========")
        L.append("")
        
        # RAM instances using dual_port_RAM
        L.append("    -- Memory instances (dual_port_RAM)")
        for mem in sorted(self.all_mems):
            size = self.mem_sizes[mem]
            addr_bits = self.bits_needed(size)
            L.append(f"    {mem}_RAM: entity work.dual_port_RAM")
            L.append(f"        generic map (addr_width => {addr_bits}, data_width => DATA_WIDTH, INIT_FILE => \"{mem}_content.txt\")")
            L.append(f"        port map (clk => clk, we => {mem}_we, addr_wr => {mem}_addr_wr, addr_rd => {mem}_addr_rd, din => {mem}_din, dout => {mem}_dout);")
        L.append("")
        
        # Adder instances
        L.append("    -- Adder instances")
        for res in adders:
            L.append(f"    {res.name}_ADDER: entity work.adder_32")
            L.append(f"        port map (a => {res.name}_a, b => {res.name}_b, y => {res.name}_out);")
        L.append("")
        
        # Multiplier instances
        L.append("    -- Multiplier instances")
        for res in multipliers:
            L.append(f"    {res.name}_MUL: entity work.multiplier_32")
            L.append(f"        port map (a => {res.name}_a, b => {res.name}_b, y => {res.name}_out);")
        L.append("")
        
        # ========== CONTROLLER ==========
        L.append("    -- ========== FSM Controller ==========")
        L.append("    done <= '1' when state = S_END else '0';")
        L.append("    state_out <= encode_state(state);")
        L.append("")
        L.append("    process(clk, rst)")
        L.append("    begin")
        L.append("        if rst = '1' then state <= S0;")
        L.append("        elsif rising_edge(clk) then")
        L.append("            case state is")
        for t in range(self.max_time):
            L.append(f"                when S{t} => state <= S{t + 1};")
        L.append(f"                when S{self.max_time} => state <= S_END;")
        L.append("                when others => state <= S_END;")
        L.append("            end case;")
        L.append("        end if;")
        L.append("    end process;")
        L.append("")
        
        # Control signal generation
        L.append("    -- Control signals")
        L.append("    process(state)")
        L.append("    begin")
        for reg in all_regs:
            if not getattr(reg, 'is_wire', False):
                L.append(f"        {reg.name}_en <= '0';")
        for mem in sorted(self.all_mems):
            L.append(f"        {mem}_we <= '0';")
        for var_res in sorted(self.all_vars, key=lambda v: v.name):
            L.append(f"        {var_res.name}_en <= '0';")
        for mux in self.datapath.muxes:
            L.append(f"        {mux.name}_sel <= (others => '0');")
        L.append("        case state is")
        for t in range(self.max_time + 1):
            sig = self.control[t]
            L.append(f"            when S{t} =>")
    
            # For registers and variable resources
            for reg in sig['reg_enables']:
                if not getattr(reg, 'is_wire', False):
                    L.append(f"                {reg.name}_en <= '1';")

            for mem, op in sig['mem_ops'].items():
                if op == 'write':
                    L.append(f"                {mem}_we <= '1';")
            for mux, sel in sig['mux_selects'].items():
                width = self.mux_widths[mux]
                L.append(f"                {mux}_sel <= std_logic_vector(to_unsigned({sel}, {width}));")
            
            if all(not v for v in sig.values()):
                L.append("                null;")
        L.append("            when others => null;")
        L.append("        end case;")
        L.append("    end process;")
        L.append("")
        
        # ========== DATAPATH ==========
        L.append("    -- ========== Datapath ==========")
        L.append("")
        
        L.append("    -- Registers")
        L.append("    process(clk) begin")
        L.append("        if rising_edge(clk) then")
        for edge, reg in sorted(self.register_allocator.register_allocation.items(), key=lambda x: reg_sort_key(x[1])):
            if not getattr(reg, 'is_wire', False):
                src, _, _ = edge
                if isinstance(src, CstNode):
                    val = f"std_logic_vector(to_signed({src.value}, DATA_WIDTH))"
                elif isinstance(src, LoadNode):
                    val = f"{src.mem.name}_dout"
                elif isinstance(src, MulNode):
                    res = self.resource_allocator.resource_allocation.get(src)
                    val = f"{res.name}_out"
                elif isinstance(src, AddNode):
                    res = self.resource_allocator.resource_allocation.get(src)
                    val = f"{res.name}_out"
                elif isinstance(src, VarLoadNode):
                    res = self.resource_allocator.resource_allocation.get(src)
                    val = f"{res.name}_reg"
                L.append(f"            if {reg.name}_en = '1' then {reg.name}_out <= {val}; end if;")
        
        L.append("")
        L.append("            -- Update Variable Registers")
        for var_res in sorted(self.all_vars, key=lambda v: v.name):
            L.append(f"            if {var_res.name}_en = '1' then")
            # The multiplexer for this variable data
            mux_name = f"Mux_{var_res.name}_data"
            L.append(f"                {var_res.name}_reg <= {mux_name}_out;")
            L.append("            end if;")
        L.append("        end if;")
        L.append("    end process;")
        L.append("")
        
        # Mux logic (std_logic_vector)
        L.append("    -- Multiplexers")
        for mux in self.datapath.muxes:
            if not mux.inputs:
                continue
            width = self.mux_widths[mux.name]
            L.append(f"    with {mux.name}_sel select")
            L.append(f"        {mux.name}_out <=")
            for i, inp in enumerate(mux.inputs):
                # Resolve signal name dynamically (since inp can be Reg, Res, or Cst)
                val = self.get_signal_name(inp)
                L.append(f"            {val} when \"{i:0{width}b}\",")
            L.append("            (others => '0') when others;")
        
        # Memory connections (both read and write address from same mux)
        L.append("    -- Memory connections")
        for mem in sorted(self.all_mems):
            size = self.mem_sizes[mem]
            addr_bits = self.bits_needed(size)
            addr_mux = f"Mux_{mem}_addr"
            data_mux = f"Mux_{mem}_data"
            if addr_mux in self.all_mux_selects:
                L.append(f"    {mem}_addr_rd <= {addr_mux}_out({addr_bits-1} downto 0);")
                L.append(f"    {mem}_addr_wr <= {addr_mux}_out({addr_bits-1} downto 0);")
            if data_mux in self.all_mux_selects:
                L.append(f"    {mem}_din <= {data_mux}_out;")
        L.append("")
        
        # Arithmetic connections (all STD_LOGIC_VECTOR now)
        L.append("    -- Arithmetic connections")
        for res in multipliers:
            L.append(f"    {res.name}_a <= Mux_{res.name}_left_out;")
            L.append(f"    {res.name}_b <= Mux_{res.name}_right_out;")
        for res in adders:
            L.append(f"    {res.name}_a <= Mux_{res.name}_left_out;")
            L.append(f"    {res.name}_b <= Mux_{res.name}_right_out;")
        L.append("")
        L.append("end Behavioral;")
        
        return "\n".join(L)

    def generate_testbench(self) -> str:
        """Generate VHDL testbench."""
        L = []
        L.append("-- Testbench")
        L.append("library IEEE;")
        L.append("use IEEE.STD_LOGIC_1164.ALL;")
        L.append("use IEEE.NUMERIC_STD.ALL;")
        L.append("")
        L.append("entity testbench is end testbench;")
        L.append("")
        L.append("architecture Behavioral of testbench is")
        L.append("    signal clk : STD_LOGIC := '0';")
        L.append("    signal rst : STD_LOGIC := '1';")
        L.append("    constant CLK_PERIOD : time := 10 ns;")
        L.append(f"    signal state_out : STD_LOGIC_VECTOR({self.state_bits - 1} downto 0);")
        L.append("    signal done : STD_LOGIC;")
        L.append("begin")
        L.append("    clk <= not clk after CLK_PERIOD / 2;")
        L.append("")
        L.append("    Design_inst: entity work.Design port map (clk => clk, rst => rst, state_out => state_out, done => done);")
        L.append("")
        L.append("    process begin")
        L.append("        rst <= '1'; wait for CLK_PERIOD * 1;")
        L.append(f"        rst <= '0'; wait for CLK_PERIOD * {self.max_time + 3};")
        L.append("        wait;")
        L.append("    end process;")
        L.append("end Behavioral;")
        
        return "\n".join(L)

    def generate_all(self, output_dir: str = "generated_vhdl"):
        """Generate all VHDL files."""
        import os
        os.makedirs(output_dir, exist_ok=True)
        
        for name, gen in [("design.vhdl", self.generate_design), 
                          ("testbench.vhdl", self.generate_testbench)]:
            with open(os.path.join(output_dir, name), "w") as f:
                f.write(gen())
            print(f"Generated: {output_dir}/{name}")
