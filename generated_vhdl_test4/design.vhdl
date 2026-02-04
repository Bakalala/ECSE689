-- HLS Generated Design
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Design is
    Port ( clk, rst : in STD_LOGIC;
           state_out : out STD_LOGIC_VECTOR(4 downto 0);
           done : out STD_LOGIC);
end Design;

architecture Behavioral of Design is

    constant DATA_WIDTH : integer := 32;

    type state_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S_END);
    signal state : state_type := S0;

    -- Registers
    signal R0_en : STD_LOGIC;
    signal R0_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R1_en : STD_LOGIC;
    signal R1_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R2_en : STD_LOGIC;
    signal R2_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R3_en : STD_LOGIC;
    signal R3_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R4_en : STD_LOGIC;
    signal R4_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R5_en : STD_LOGIC;
    signal R5_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R6_en : STD_LOGIC;
    signal R6_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R7_en : STD_LOGIC;
    signal R7_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R8_en : STD_LOGIC;
    signal R8_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R9_en : STD_LOGIC;
    signal R9_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R10_en : STD_LOGIC;
    signal R10_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R11_en : STD_LOGIC;
    signal R11_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R12_en : STD_LOGIC;
    signal R12_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R13_en : STD_LOGIC;
    signal R13_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R14_en : STD_LOGIC;
    signal R14_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R15_en : STD_LOGIC;
    signal R15_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R16_en : STD_LOGIC;
    signal R16_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R17_en : STD_LOGIC;
    signal R17_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R18_en : STD_LOGIC;
    signal R18_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R19_en : STD_LOGIC;
    signal R19_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R20_en : STD_LOGIC;
    signal R20_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R21_en : STD_LOGIC;
    signal R21_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R22_en : STD_LOGIC;
    signal R22_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R23_en : STD_LOGIC;
    signal R23_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R24_en : STD_LOGIC;
    signal R24_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R25_en : STD_LOGIC;
    signal R25_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R26_en : STD_LOGIC;
    signal R26_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R27_en : STD_LOGIC;
    signal R27_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R28_en : STD_LOGIC;
    signal R28_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R29_en : STD_LOGIC;
    signal R29_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R30_en : STD_LOGIC;
    signal R30_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R31_en : STD_LOGIC;
    signal R31_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R32_en : STD_LOGIC;
    signal R32_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R33_en : STD_LOGIC;
    signal R33_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R34_en : STD_LOGIC;
    signal R34_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R35_en : STD_LOGIC;
    signal R35_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R36_en : STD_LOGIC;
    signal R36_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R37_en : STD_LOGIC;
    signal R37_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R38_en : STD_LOGIC;
    signal R38_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R39_en : STD_LOGIC;
    signal R39_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R40_en : STD_LOGIC;
    signal R40_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R41_en : STD_LOGIC;
    signal R41_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R42_en : STD_LOGIC;
    signal R42_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R43_en : STD_LOGIC;
    signal R43_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R44_en : STD_LOGIC;
    signal R44_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R45_en : STD_LOGIC;
    signal R45_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R46_en : STD_LOGIC;
    signal R46_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R47_en : STD_LOGIC;
    signal R47_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R48_en : STD_LOGIC;
    signal R48_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R49_en : STD_LOGIC;
    signal R49_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R50_en : STD_LOGIC;
    signal R50_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R51_en : STD_LOGIC;
    signal R51_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R52_en : STD_LOGIC;
    signal R52_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R53_en : STD_LOGIC;
    signal R53_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R54_en : STD_LOGIC;
    signal R54_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R55_en : STD_LOGIC;
    signal R55_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R56_en : STD_LOGIC;
    signal R56_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R57_en : STD_LOGIC;
    signal R57_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R58_en : STD_LOGIC;
    signal R58_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R59_en : STD_LOGIC;
    signal R59_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R60_en : STD_LOGIC;
    signal R60_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R61_en : STD_LOGIC;
    signal R61_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R62_en : STD_LOGIC;
    signal R62_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R63_en : STD_LOGIC;
    signal R63_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R64_en : STD_LOGIC;
    signal R64_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R65_en : STD_LOGIC;
    signal R65_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R66_en : STD_LOGIC;
    signal R66_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R67_en : STD_LOGIC;
    signal R67_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R68_en : STD_LOGIC;
    signal R68_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R69_en : STD_LOGIC;
    signal R69_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R70_en : STD_LOGIC;
    signal R70_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R71_en : STD_LOGIC;
    signal R71_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');

    -- Memory signals
    signal A_we : STD_LOGIC;
    signal A_addr_wr : STD_LOGIC_VECTOR(2 downto 0);
    signal A_addr_rd : STD_LOGIC_VECTOR(2 downto 0);
    signal A_din : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal A_dout : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal C_we : STD_LOGIC;
    signal C_addr_wr : STD_LOGIC_VECTOR(1 downto 0);
    signal C_addr_rd : STD_LOGIC_VECTOR(1 downto 0);
    signal C_din : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal C_dout : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal W_we : STD_LOGIC;
    signal W_addr_wr : STD_LOGIC_VECTOR(1 downto 0);
    signal W_addr_rd : STD_LOGIC_VECTOR(1 downto 0);
    signal W_din : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal W_dout : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);

    -- Multiplexer signals
    signal Mux_A_addr_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal Mux_A_addr_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_W_addr_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal Mux_W_addr_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_Mul_0_left_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal Mux_Mul_0_left_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_Mul_0_right_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal Mux_Mul_0_right_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_Add_0_left_sel : STD_LOGIC_VECTOR(2 downto 0);
    signal Mux_Add_0_left_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_Add_0_right_sel : STD_LOGIC_VECTOR(2 downto 0);
    signal Mux_Add_0_right_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_C_addr_sel : STD_LOGIC_VECTOR(1 downto 0);
    signal Mux_C_addr_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_C_data_sel : STD_LOGIC_VECTOR(1 downto 0);
    signal Mux_C_data_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');

    -- Operators resources signals
    signal Add_0_a, Add_0_b : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal Add_0_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal Mul_0_a, Mul_0_b : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal Mul_0_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);

    function encode_state(s: state_type) return STD_LOGIC_VECTOR is
    begin
        case s is
            when S0 => return std_logic_vector(to_unsigned(0, 5));
            when S1 => return std_logic_vector(to_unsigned(1, 5));
            when S2 => return std_logic_vector(to_unsigned(2, 5));
            when S3 => return std_logic_vector(to_unsigned(3, 5));
            when S4 => return std_logic_vector(to_unsigned(4, 5));
            when S5 => return std_logic_vector(to_unsigned(5, 5));
            when S6 => return std_logic_vector(to_unsigned(6, 5));
            when S7 => return std_logic_vector(to_unsigned(7, 5));
            when S8 => return std_logic_vector(to_unsigned(8, 5));
            when S9 => return std_logic_vector(to_unsigned(9, 5));
            when S10 => return std_logic_vector(to_unsigned(10, 5));
            when S11 => return std_logic_vector(to_unsigned(11, 5));
            when S12 => return std_logic_vector(to_unsigned(12, 5));
            when S13 => return std_logic_vector(to_unsigned(13, 5));
            when S14 => return std_logic_vector(to_unsigned(14, 5));
            when S15 => return std_logic_vector(to_unsigned(15, 5));
            when S_END => return std_logic_vector(to_unsigned(16, 5));
        end case;
    end function;

begin

    -- ========== Component Instantiations ==========

    -- Memory instances (dual_port_RAM)
    A_RAM: entity work.dual_port_RAM
        generic map (addr_width => 3, data_width => DATA_WIDTH, INIT_FILE => "A_content.txt")
        port map (clk => clk, we => A_we, addr_wr => A_addr_wr, addr_rd => A_addr_rd, din => A_din, dout => A_dout);
    C_RAM: entity work.dual_port_RAM
        generic map (addr_width => 2, data_width => DATA_WIDTH, INIT_FILE => "C_content.txt")
        port map (clk => clk, we => C_we, addr_wr => C_addr_wr, addr_rd => C_addr_rd, din => C_din, dout => C_dout);
    W_RAM: entity work.dual_port_RAM
        generic map (addr_width => 2, data_width => DATA_WIDTH, INIT_FILE => "W_content.txt")
        port map (clk => clk, we => W_we, addr_wr => W_addr_wr, addr_rd => W_addr_rd, din => W_din, dout => W_dout);

    -- Adder instances
    Add_0_ADDER: entity work.adder_32
        port map (a => Add_0_a, b => Add_0_b, y => Add_0_out);

    -- Multiplier instances
    Mul_0_MUL: entity work.multiplier_32
        port map (a => Mul_0_a, b => Mul_0_b, y => Mul_0_out);

    -- ========== FSM Controller ==========
    done <= '1' when state = S_END else '0';
    state_out <= encode_state(state);

    process(clk, rst)
    begin
        if rst = '1' then state <= S0;
        elsif rising_edge(clk) then
            case state is
                when S0 => state <= S1;
                when S1 => state <= S2;
                when S2 => state <= S3;
                when S3 => state <= S4;
                when S4 => state <= S5;
                when S5 => state <= S6;
                when S6 => state <= S7;
                when S7 => state <= S8;
                when S8 => state <= S9;
                when S9 => state <= S10;
                when S10 => state <= S11;
                when S11 => state <= S12;
                when S12 => state <= S13;
                when S13 => state <= S14;
                when S14 => state <= S15;
                when S15 => state <= S_END;
                when others => state <= S_END;
            end case;
        end if;
    end process;

    -- Control signals
    process(state)
    begin
        R0_en <= '0';
        R1_en <= '0';
        R2_en <= '0';
        R3_en <= '0';
        R4_en <= '0';
        R5_en <= '0';
        R6_en <= '0';
        R7_en <= '0';
        R8_en <= '0';
        R9_en <= '0';
        R10_en <= '0';
        R11_en <= '0';
        R12_en <= '0';
        R13_en <= '0';
        R14_en <= '0';
        R15_en <= '0';
        R16_en <= '0';
        R17_en <= '0';
        R18_en <= '0';
        R19_en <= '0';
        R20_en <= '0';
        R21_en <= '0';
        R22_en <= '0';
        R23_en <= '0';
        R24_en <= '0';
        R25_en <= '0';
        R26_en <= '0';
        R27_en <= '0';
        R28_en <= '0';
        R29_en <= '0';
        R30_en <= '0';
        R31_en <= '0';
        R32_en <= '0';
        R33_en <= '0';
        R34_en <= '0';
        R35_en <= '0';
        R36_en <= '0';
        R37_en <= '0';
        R38_en <= '0';
        R39_en <= '0';
        R40_en <= '0';
        R41_en <= '0';
        R42_en <= '0';
        R43_en <= '0';
        R44_en <= '0';
        R45_en <= '0';
        R46_en <= '0';
        R47_en <= '0';
        R48_en <= '0';
        R49_en <= '0';
        R50_en <= '0';
        R51_en <= '0';
        R52_en <= '0';
        R53_en <= '0';
        R54_en <= '0';
        R55_en <= '0';
        R56_en <= '0';
        R57_en <= '0';
        R58_en <= '0';
        R59_en <= '0';
        R60_en <= '0';
        R61_en <= '0';
        R62_en <= '0';
        R63_en <= '0';
        R64_en <= '0';
        R65_en <= '0';
        R66_en <= '0';
        R67_en <= '0';
        R68_en <= '0';
        R69_en <= '0';
        R70_en <= '0';
        R71_en <= '0';
        A_we <= '0';
        C_we <= '0';
        W_we <= '0';
        Mux_A_addr_sel <= (others => '0');
        Mux_W_addr_sel <= (others => '0');
        Mux_Mul_0_left_sel <= (others => '0');
        Mux_Mul_0_right_sel <= (others => '0');
        Mux_Add_0_left_sel <= (others => '0');
        Mux_Add_0_right_sel <= (others => '0');
        Mux_C_addr_sel <= (others => '0');
        Mux_C_data_sel <= (others => '0');
        case state is
            when S0 =>
                R16_en <= '1';
                R0_en <= '1';
                R1_en <= '1';
                R4_en <= '1';
                R5_en <= '1';
                R10_en <= '1';
                R11_en <= '1';
                R34_en <= '1';
                R18_en <= '1';
                R19_en <= '1';
                R22_en <= '1';
                R23_en <= '1';
                R28_en <= '1';
                R29_en <= '1';
                R52_en <= '1';
                R36_en <= '1';
                R37_en <= '1';
                R40_en <= '1';
                R41_en <= '1';
                R46_en <= '1';
                R47_en <= '1';
                R70_en <= '1';
                R54_en <= '1';
                R55_en <= '1';
                R58_en <= '1';
                R59_en <= '1';
                R64_en <= '1';
                R65_en <= '1';
            when S1 =>
                R2_en <= '1';
                R3_en <= '1';
                Mux_A_addr_sel <= std_logic_vector(to_unsigned(0, 4));
                Mux_W_addr_sel <= std_logic_vector(to_unsigned(0, 4));
            when S2 =>
                R8_en <= '1';
                R6_en <= '1';
                R7_en <= '1';
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(0, 4));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(0, 4));
                Mux_A_addr_sel <= std_logic_vector(to_unsigned(1, 4));
                Mux_W_addr_sel <= std_logic_vector(to_unsigned(1, 4));
            when S3 =>
                R9_en <= '1';
                R12_en <= '1';
                R13_en <= '1';
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(1, 4));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(1, 4));
                Mux_A_addr_sel <= std_logic_vector(to_unsigned(2, 4));
                Mux_W_addr_sel <= std_logic_vector(to_unsigned(2, 4));
            when S4 =>
                R14_en <= '1';
                R15_en <= '1';
                R20_en <= '1';
                R21_en <= '1';
                Mux_Add_0_left_sel <= std_logic_vector(to_unsigned(0, 3));
                Mux_Add_0_right_sel <= std_logic_vector(to_unsigned(0, 3));
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(2, 4));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(2, 4));
                Mux_A_addr_sel <= std_logic_vector(to_unsigned(3, 4));
                Mux_W_addr_sel <= std_logic_vector(to_unsigned(3, 4));
            when S5 =>
                R17_en <= '1';
                R26_en <= '1';
                R24_en <= '1';
                R25_en <= '1';
                Mux_Add_0_left_sel <= std_logic_vector(to_unsigned(1, 3));
                Mux_Add_0_right_sel <= std_logic_vector(to_unsigned(1, 3));
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(3, 4));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(3, 4));
                Mux_A_addr_sel <= std_logic_vector(to_unsigned(4, 4));
                Mux_W_addr_sel <= std_logic_vector(to_unsigned(4, 4));
            when S6 =>
                R27_en <= '1';
                R30_en <= '1';
                R31_en <= '1';
                C_we <= '1';
                Mux_C_addr_sel <= std_logic_vector(to_unsigned(0, 2));
                Mux_C_data_sel <= std_logic_vector(to_unsigned(0, 2));
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(4, 4));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(4, 4));
                Mux_A_addr_sel <= std_logic_vector(to_unsigned(5, 4));
                Mux_W_addr_sel <= std_logic_vector(to_unsigned(5, 4));
            when S7 =>
                R32_en <= '1';
                R33_en <= '1';
                R38_en <= '1';
                R39_en <= '1';
                Mux_Add_0_left_sel <= std_logic_vector(to_unsigned(2, 3));
                Mux_Add_0_right_sel <= std_logic_vector(to_unsigned(2, 3));
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(5, 4));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(5, 4));
                Mux_A_addr_sel <= std_logic_vector(to_unsigned(6, 4));
                Mux_W_addr_sel <= std_logic_vector(to_unsigned(6, 4));
            when S8 =>
                R35_en <= '1';
                R44_en <= '1';
                R42_en <= '1';
                R43_en <= '1';
                Mux_Add_0_left_sel <= std_logic_vector(to_unsigned(3, 3));
                Mux_Add_0_right_sel <= std_logic_vector(to_unsigned(3, 3));
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(6, 4));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(6, 4));
                Mux_A_addr_sel <= std_logic_vector(to_unsigned(7, 4));
                Mux_W_addr_sel <= std_logic_vector(to_unsigned(7, 4));
            when S9 =>
                R45_en <= '1';
                R48_en <= '1';
                R49_en <= '1';
                C_we <= '1';
                Mux_C_addr_sel <= std_logic_vector(to_unsigned(1, 2));
                Mux_C_data_sel <= std_logic_vector(to_unsigned(1, 2));
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(7, 4));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(7, 4));
                Mux_A_addr_sel <= std_logic_vector(to_unsigned(8, 4));
                Mux_W_addr_sel <= std_logic_vector(to_unsigned(8, 4));
            when S10 =>
                R50_en <= '1';
                R51_en <= '1';
                R56_en <= '1';
                R57_en <= '1';
                Mux_Add_0_left_sel <= std_logic_vector(to_unsigned(4, 3));
                Mux_Add_0_right_sel <= std_logic_vector(to_unsigned(4, 3));
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(8, 4));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(8, 4));
                Mux_A_addr_sel <= std_logic_vector(to_unsigned(9, 4));
                Mux_W_addr_sel <= std_logic_vector(to_unsigned(9, 4));
            when S11 =>
                R53_en <= '1';
                R62_en <= '1';
                R60_en <= '1';
                R61_en <= '1';
                Mux_Add_0_left_sel <= std_logic_vector(to_unsigned(5, 3));
                Mux_Add_0_right_sel <= std_logic_vector(to_unsigned(5, 3));
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(9, 4));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(9, 4));
                Mux_A_addr_sel <= std_logic_vector(to_unsigned(10, 4));
                Mux_W_addr_sel <= std_logic_vector(to_unsigned(10, 4));
            when S12 =>
                R63_en <= '1';
                R66_en <= '1';
                R67_en <= '1';
                C_we <= '1';
                Mux_C_addr_sel <= std_logic_vector(to_unsigned(2, 2));
                Mux_C_data_sel <= std_logic_vector(to_unsigned(2, 2));
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(10, 4));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(10, 4));
                Mux_A_addr_sel <= std_logic_vector(to_unsigned(11, 4));
                Mux_W_addr_sel <= std_logic_vector(to_unsigned(11, 4));
            when S13 =>
                R68_en <= '1';
                R69_en <= '1';
                Mux_Add_0_left_sel <= std_logic_vector(to_unsigned(6, 3));
                Mux_Add_0_right_sel <= std_logic_vector(to_unsigned(6, 3));
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(11, 4));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(11, 4));
            when S14 =>
                R71_en <= '1';
                Mux_Add_0_left_sel <= std_logic_vector(to_unsigned(7, 3));
                Mux_Add_0_right_sel <= std_logic_vector(to_unsigned(7, 3));
            when S15 =>
                C_we <= '1';
                Mux_C_addr_sel <= std_logic_vector(to_unsigned(3, 2));
                Mux_C_data_sel <= std_logic_vector(to_unsigned(3, 2));
            when others => null;
        end case;
    end process;

    -- ========== Datapath ==========

    -- Registers
    process(clk) begin
        if rising_edge(clk) then
            if R0_en = '1' then R0_out <= std_logic_vector(to_signed(0, DATA_WIDTH)); end if;
            if R1_en = '1' then R1_out <= std_logic_vector(to_signed(0, DATA_WIDTH)); end if;
            if R2_en = '1' then R2_out <= A_dout; end if;
            if R3_en = '1' then R3_out <= W_dout; end if;
            if R4_en = '1' then R4_out <= std_logic_vector(to_signed(1, DATA_WIDTH)); end if;
            if R5_en = '1' then R5_out <= std_logic_vector(to_signed(1, DATA_WIDTH)); end if;
            if R6_en = '1' then R6_out <= A_dout; end if;
            if R7_en = '1' then R7_out <= W_dout; end if;
            if R8_en = '1' then R8_out <= Mul_0_out; end if;
            if R9_en = '1' then R9_out <= Mul_0_out; end if;
            if R10_en = '1' then R10_out <= std_logic_vector(to_signed(2, DATA_WIDTH)); end if;
            if R11_en = '1' then R11_out <= std_logic_vector(to_signed(2, DATA_WIDTH)); end if;
            if R12_en = '1' then R12_out <= A_dout; end if;
            if R13_en = '1' then R13_out <= W_dout; end if;
            if R14_en = '1' then R14_out <= Add_0_out; end if;
            if R15_en = '1' then R15_out <= Mul_0_out; end if;
            if R16_en = '1' then R16_out <= std_logic_vector(to_signed(0, DATA_WIDTH)); end if;
            if R17_en = '1' then R17_out <= Add_0_out; end if;
            if R18_en = '1' then R18_out <= std_logic_vector(to_signed(1, DATA_WIDTH)); end if;
            if R19_en = '1' then R19_out <= std_logic_vector(to_signed(0, DATA_WIDTH)); end if;
            if R20_en = '1' then R20_out <= A_dout; end if;
            if R21_en = '1' then R21_out <= W_dout; end if;
            if R22_en = '1' then R22_out <= std_logic_vector(to_signed(2, DATA_WIDTH)); end if;
            if R23_en = '1' then R23_out <= std_logic_vector(to_signed(1, DATA_WIDTH)); end if;
            if R24_en = '1' then R24_out <= A_dout; end if;
            if R25_en = '1' then R25_out <= W_dout; end if;
            if R26_en = '1' then R26_out <= Mul_0_out; end if;
            if R27_en = '1' then R27_out <= Mul_0_out; end if;
            if R28_en = '1' then R28_out <= std_logic_vector(to_signed(3, DATA_WIDTH)); end if;
            if R29_en = '1' then R29_out <= std_logic_vector(to_signed(2, DATA_WIDTH)); end if;
            if R30_en = '1' then R30_out <= A_dout; end if;
            if R31_en = '1' then R31_out <= W_dout; end if;
            if R32_en = '1' then R32_out <= Add_0_out; end if;
            if R33_en = '1' then R33_out <= Mul_0_out; end if;
            if R34_en = '1' then R34_out <= std_logic_vector(to_signed(1, DATA_WIDTH)); end if;
            if R35_en = '1' then R35_out <= Add_0_out; end if;
            if R36_en = '1' then R36_out <= std_logic_vector(to_signed(2, DATA_WIDTH)); end if;
            if R37_en = '1' then R37_out <= std_logic_vector(to_signed(0, DATA_WIDTH)); end if;
            if R38_en = '1' then R38_out <= A_dout; end if;
            if R39_en = '1' then R39_out <= W_dout; end if;
            if R40_en = '1' then R40_out <= std_logic_vector(to_signed(3, DATA_WIDTH)); end if;
            if R41_en = '1' then R41_out <= std_logic_vector(to_signed(1, DATA_WIDTH)); end if;
            if R42_en = '1' then R42_out <= A_dout; end if;
            if R43_en = '1' then R43_out <= W_dout; end if;
            if R44_en = '1' then R44_out <= Mul_0_out; end if;
            if R45_en = '1' then R45_out <= Mul_0_out; end if;
            if R46_en = '1' then R46_out <= std_logic_vector(to_signed(4, DATA_WIDTH)); end if;
            if R47_en = '1' then R47_out <= std_logic_vector(to_signed(2, DATA_WIDTH)); end if;
            if R48_en = '1' then R48_out <= A_dout; end if;
            if R49_en = '1' then R49_out <= W_dout; end if;
            if R50_en = '1' then R50_out <= Add_0_out; end if;
            if R51_en = '1' then R51_out <= Mul_0_out; end if;
            if R52_en = '1' then R52_out <= std_logic_vector(to_signed(2, DATA_WIDTH)); end if;
            if R53_en = '1' then R53_out <= Add_0_out; end if;
            if R54_en = '1' then R54_out <= std_logic_vector(to_signed(3, DATA_WIDTH)); end if;
            if R55_en = '1' then R55_out <= std_logic_vector(to_signed(0, DATA_WIDTH)); end if;
            if R56_en = '1' then R56_out <= A_dout; end if;
            if R57_en = '1' then R57_out <= W_dout; end if;
            if R58_en = '1' then R58_out <= std_logic_vector(to_signed(4, DATA_WIDTH)); end if;
            if R59_en = '1' then R59_out <= std_logic_vector(to_signed(1, DATA_WIDTH)); end if;
            if R60_en = '1' then R60_out <= A_dout; end if;
            if R61_en = '1' then R61_out <= W_dout; end if;
            if R62_en = '1' then R62_out <= Mul_0_out; end if;
            if R63_en = '1' then R63_out <= Mul_0_out; end if;
            if R64_en = '1' then R64_out <= std_logic_vector(to_signed(5, DATA_WIDTH)); end if;
            if R65_en = '1' then R65_out <= std_logic_vector(to_signed(2, DATA_WIDTH)); end if;
            if R66_en = '1' then R66_out <= A_dout; end if;
            if R67_en = '1' then R67_out <= W_dout; end if;
            if R68_en = '1' then R68_out <= Add_0_out; end if;
            if R69_en = '1' then R69_out <= Mul_0_out; end if;
            if R70_en = '1' then R70_out <= std_logic_vector(to_signed(3, DATA_WIDTH)); end if;
            if R71_en = '1' then R71_out <= Add_0_out; end if;
        end if;
    end process;

    -- Multiplexers
    with Mux_A_addr_sel select
        Mux_A_addr_out <=
            R0_out when "0000",
            R4_out when "0001",
            R10_out when "0010",
            R18_out when "0011",
            R22_out when "0100",
            R28_out when "0101",
            R36_out when "0110",
            R40_out when "0111",
            R46_out when "1000",
            R54_out when "1001",
            R58_out when "1010",
            R64_out when "1011",
            (others => '0') when others;
    with Mux_W_addr_sel select
        Mux_W_addr_out <=
            R1_out when "0000",
            R5_out when "0001",
            R11_out when "0010",
            R19_out when "0011",
            R23_out when "0100",
            R29_out when "0101",
            R37_out when "0110",
            R41_out when "0111",
            R47_out when "1000",
            R55_out when "1001",
            R59_out when "1010",
            R65_out when "1011",
            (others => '0') when others;
    with Mux_Mul_0_left_sel select
        Mux_Mul_0_left_out <=
            R2_out when "0000",
            R6_out when "0001",
            R12_out when "0010",
            R20_out when "0011",
            R24_out when "0100",
            R30_out when "0101",
            R38_out when "0110",
            R42_out when "0111",
            R48_out when "1000",
            R56_out when "1001",
            R60_out when "1010",
            R66_out when "1011",
            (others => '0') when others;
    with Mux_Mul_0_right_sel select
        Mux_Mul_0_right_out <=
            R3_out when "0000",
            R7_out when "0001",
            R13_out when "0010",
            R21_out when "0011",
            R25_out when "0100",
            R31_out when "0101",
            R39_out when "0110",
            R43_out when "0111",
            R49_out when "1000",
            R57_out when "1001",
            R61_out when "1010",
            R67_out when "1011",
            (others => '0') when others;
    with Mux_Add_0_left_sel select
        Mux_Add_0_left_out <=
            R8_out when "000",
            R14_out when "001",
            R26_out when "010",
            R32_out when "011",
            R44_out when "100",
            R50_out when "101",
            R62_out when "110",
            R68_out when "111",
            (others => '0') when others;
    with Mux_Add_0_right_sel select
        Mux_Add_0_right_out <=
            R9_out when "000",
            R15_out when "001",
            R27_out when "010",
            R33_out when "011",
            R45_out when "100",
            R51_out when "101",
            R63_out when "110",
            R69_out when "111",
            (others => '0') when others;
    with Mux_C_addr_sel select
        Mux_C_addr_out <=
            R16_out when "00",
            R34_out when "01",
            R52_out when "10",
            R70_out when "11",
            (others => '0') when others;
    with Mux_C_data_sel select
        Mux_C_data_out <=
            R17_out when "00",
            R35_out when "01",
            R53_out when "10",
            R71_out when "11",
            (others => '0') when others;
    -- Memory connections
    A_addr_rd <= Mux_A_addr_out(2 downto 0);
    A_addr_wr <= Mux_A_addr_out(2 downto 0);
    C_addr_rd <= Mux_C_addr_out(1 downto 0);
    C_addr_wr <= Mux_C_addr_out(1 downto 0);
    C_din <= Mux_C_data_out;
    W_addr_rd <= Mux_W_addr_out(1 downto 0);
    W_addr_wr <= Mux_W_addr_out(1 downto 0);

    -- Arithmetic connections
    Mul_0_a <= Mux_Mul_0_left_out;
    Mul_0_b <= Mux_Mul_0_right_out;
    Add_0_a <= Mux_Add_0_left_out;
    Add_0_b <= Mux_Add_0_right_out;

end Behavioral;