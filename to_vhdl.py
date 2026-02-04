"""
VHDL Code Generator for HLS Pipeline
Generates: Design (Controller + Datapath with component instantiation), Testbench
Uses external components: dual_port_RAM.vhdl, adder.vhdl, multiplier.vhdl
"""

class VHDLGenerator:
    def __init__(self, fsm_generator, datapath, resource_allocator, register_allocator, data_width=32):
        self.fsm = fsm_generator
        self.datapath = datapath
        self.resource_allocator = resource_allocator
        self.register_allocator = register_allocator
        self.control = fsm_generator.control_by_state
        self.max_time = fsm_generator.max_time
        self.data_width = data_width
        self._collect_signals()

    def _collect_signals(self):
        """Collect all control signal names and memory sizes from FSM and CDFG."""
        self.all_reg_enables = set()
        self.all_mems = set()
        self.all_mux_selects = set()
        self.mem_sizes = {}
        
        for signals in self.control.values():
            for reg in signals['reg_enables']:
                self.all_reg_enables.add(reg.name)
            for mem_name in signals['mem_ops']:
                self.all_mems.add(mem_name)
            for mux_name in signals['mux_selects']:
                self.all_mux_selects.add(mux_name)
        
        for node in self.fsm.schedule.keys():
            if hasattr(node, 'mem') and hasattr(node.mem, 'name') and hasattr(node.mem, 'size'):
                self.mem_sizes[node.mem.name] = node.mem.size
        
        self.mux_widths = {}
        for mux in self.datapath.muxes:
            # Calculate bits needed: ceil(log2(n)). At least 1 bit.
            width = max(1, (len(mux.inputs) - 1).bit_length()) if mux.inputs else 1
            self.mux_widths[mux.name] = width
            
        self.state_bits = (self.max_time + 2).bit_length()
        
    def _addr_bits(self, size):
        """Calculate address bits needed for given size."""
        return max(1, (size - 1).bit_length())

    def _vhdl_header(self):
        lines = ["library IEEE;", "use IEEE.STD_LOGIC_1164.ALL;", "use IEEE.NUMERIC_STD.ALL;"]
        return lines

    def generate_design(self) -> str:
        """Generate combined Controller + Datapath with component instantiation."""
        L = []
        L.append("-- HLS Generated Design (Controller + Datapath)")
        L.extend(self._vhdl_header())
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
        L.append(f"    constant DATA_WIDTH : integer := {self.data_width};")
        L.append("")
        
        # Sort helper for register names
        def reg_sort_key(r):
            name = r.name if hasattr(r, 'name') else r
            return int(name[1:]) if name[1:].isdigit() else 0
        
        # State type
        states = [f"S{t}" for t in range(self.max_time + 1)] + ["S_END"]
        L.append(f"    type state_type is ({', '.join(states)});")
        L.append("    signal state : state_type := S0;")
        L.append("")
        
        # Registers
        all_regs = sorted(set(self.register_allocator.register_allocation.values()), key=reg_sort_key)
        L.append("    -- Registers")
        for reg in all_regs:
            L.append(f"    signal {reg.name}_en : STD_LOGIC;")
            L.append(f"    signal {reg.name}_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');")
        L.append("")
        
        # Memory signals (using std_logic_vector for dual_port_RAM)
        L.append("    -- Memory signals")
        for mem in sorted(self.all_mems):
            size = self.mem_sizes.get(mem, 16)
            addr_bits = self._addr_bits(size)
            L.append(f"    signal {mem}_we : STD_LOGIC;")
            L.append(f"    signal {mem}_addr_wr : STD_LOGIC_VECTOR({addr_bits-1} downto 0);")
            L.append(f"    signal {mem}_addr_rd : STD_LOGIC_VECTOR({addr_bits-1} downto 0);")
            L.append(f"    signal {mem}_din : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);")
            L.append(f"    signal {mem}_dout : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);")
        L.append("")
        
        # Mux signals
        L.append("    -- Multiplexer signals")
        for mux in self.datapath.muxes:
            width = self.mux_widths[mux.name]
            L.append(f"    signal {mux.name}_sel : STD_LOGIC_VECTOR({width - 1} downto 0);")
            L.append(f"    signal {mux.name}_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');")
        L.append("")
        
        # Arithmetic unit signals
        resources = set(self.resource_allocator.resource_allocation.values())
        adders = sorted([r for r in resources if 'Add' in r.name], key=lambda r: r.name)
        multipliers = sorted([r for r in resources if 'Mul' in r.name], key=lambda r: r.name)
        
        L.append("    -- Arithmetic unit signals")
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
            size = self.mem_sizes.get(mem, 16)
            addr_bits = self._addr_bits(size)
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
            L.append(f"        {reg.name}_en <= '0';")
        for mem in sorted(self.all_mems):
            L.append(f"        {mem}_we <= '0';")
        for mux in self.datapath.muxes:
            L.append(f"        {mux.name}_sel <= (others => '0');")
        L.append("        case state is")
        for t in range(self.max_time + 1):
            sig = self.control[t]
            L.append(f"            when S{t} =>")
            for reg in sig['reg_enables']:
                L.append(f"                {reg.name}_en <= '1';")
            for mem, op in sig['mem_ops'].items():
                if op == 'write':
                    L.append(f"                {mem}_we <= '1';")
            for mux, sel in sig['mux_selects'].items():
                width = self.mux_widths[mux]
                L.append(f"                {mux}_sel <= std_logic_vector(to_unsigned({sel}, {width}));")
            if not sig['reg_enables'] and not sig['mem_ops'] and not sig['mux_selects']:
                L.append("                null;")
        L.append("            when others => null;")
        L.append("        end case;")
        L.append("    end process;")
        L.append("")
        
        # ========== DATAPATH ==========
        L.append("    -- ========== Datapath ==========")
        L.append("")
        
        # Register process (converting sources to std_logic_vector)
        L.append("    -- Registers")
        L.append("    process(clk) begin")
        L.append("        if rising_edge(clk) then")
        for edge, reg in sorted(self.register_allocator.register_allocation.items(), key=lambda x: reg_sort_key(x[1])):
            src, _, _ = edge
            t = type(src).__name__
            if t == 'CstNode':
                val = f"std_logic_vector(to_signed({src.value}, DATA_WIDTH))"
            elif t == 'LoadNode':
                val = f"{src.mem.name}_dout"
            elif t == 'MulNode':
                val = "Mul_0_out"
            elif t == 'AddNode':
                val = "Add_0_out"
            else:
                val = "(others => '0')"
            L.append(f"            if {reg.name}_en = '1' then {reg.name}_out <= {val}; end if;")
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
                L.append(f"            {inp.name}_out when \"{i:0{width}b}\",")
            L.append("            (others => '0') when others;")
        
        # Memory connections (both read and write address from same mux)
        L.append("    -- Memory connections")
        for mem in sorted(self.all_mems):
            size = self.mem_sizes.get(mem, 16)
            addr_bits = self._addr_bits(size)
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
        L.extend(self._vhdl_header())
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
        L.append("        rst <= '1'; wait for CLK_PERIOD * 2;")
        L.append(f"        rst <= '0'; wait for CLK_PERIOD * {self.max_time + 4};")
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
