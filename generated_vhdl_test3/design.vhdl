-- HLS Generated Design
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Design is
    Port ( clk, rst : in STD_LOGIC;
           state_out : out STD_LOGIC_VECTOR(3 downto 0);
           done : out STD_LOGIC);
end Design;

architecture Behavioral of Design is

    constant DATA_WIDTH : integer := 32;

    type state_type is (S0, S1, S2, S3, S4, S5, S6, S7, S_END);
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

    -- Memory signals
    signal A_we : STD_LOGIC;
    signal A_addr_wr : STD_LOGIC_VECTOR(1 downto 0);
    signal A_addr_rd : STD_LOGIC_VECTOR(1 downto 0);
    signal A_din : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal A_dout : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal B_we : STD_LOGIC;
    signal B_addr_wr : STD_LOGIC_VECTOR(1 downto 0);
    signal B_addr_rd : STD_LOGIC_VECTOR(1 downto 0);
    signal B_din : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal B_dout : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal C_we : STD_LOGIC;
    signal C_addr_wr : STD_LOGIC_VECTOR(0 downto 0);
    signal C_addr_rd : STD_LOGIC_VECTOR(0 downto 0);
    signal C_din : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal C_dout : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);

    -- Multiplexer signals
    signal Mux_A_addr_sel : STD_LOGIC_VECTOR(1 downto 0);
    signal Mux_A_addr_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_B_addr_sel : STD_LOGIC_VECTOR(1 downto 0);
    signal Mux_B_addr_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_Mul_0_left_sel : STD_LOGIC_VECTOR(1 downto 0);
    signal Mux_Mul_0_left_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_Mul_0_right_sel : STD_LOGIC_VECTOR(1 downto 0);
    signal Mux_Mul_0_right_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_Add_0_left_sel : STD_LOGIC_VECTOR(1 downto 0);
    signal Mux_Add_0_left_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_Add_0_right_sel : STD_LOGIC_VECTOR(1 downto 0);
    signal Mux_Add_0_right_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_C_addr_sel : STD_LOGIC_VECTOR(0 downto 0);
    signal Mux_C_addr_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_C_data_sel : STD_LOGIC_VECTOR(0 downto 0);
    signal Mux_C_data_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');

    -- Operators resources signals
    signal Add_0_a, Add_0_b : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal Add_0_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal Mul_0_a, Mul_0_b : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal Mul_0_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);

    function encode_state(s: state_type) return STD_LOGIC_VECTOR is
    begin
        case s is
            when S0 => return std_logic_vector(to_unsigned(0, 4));
            when S1 => return std_logic_vector(to_unsigned(1, 4));
            when S2 => return std_logic_vector(to_unsigned(2, 4));
            when S3 => return std_logic_vector(to_unsigned(3, 4));
            when S4 => return std_logic_vector(to_unsigned(4, 4));
            when S5 => return std_logic_vector(to_unsigned(5, 4));
            when S6 => return std_logic_vector(to_unsigned(6, 4));
            when S7 => return std_logic_vector(to_unsigned(7, 4));
            when S_END => return std_logic_vector(to_unsigned(8, 4));
        end case;
    end function;

begin

    -- ========== Component Instantiations ==========

    -- Memory instances (dual_port_RAM)
    A_RAM: entity work.dual_port_RAM
        generic map (addr_width => 2, data_width => DATA_WIDTH, INIT_FILE => "A_content.txt")
        port map (clk => clk, we => A_we, addr_wr => A_addr_wr, addr_rd => A_addr_rd, din => A_din, dout => A_dout);
    B_RAM: entity work.dual_port_RAM
        generic map (addr_width => 2, data_width => DATA_WIDTH, INIT_FILE => "B_content.txt")
        port map (clk => clk, we => B_we, addr_wr => B_addr_wr, addr_rd => B_addr_rd, din => B_din, dout => B_dout);
    C_RAM: entity work.dual_port_RAM
        generic map (addr_width => 1, data_width => DATA_WIDTH, INIT_FILE => "C_content.txt")
        port map (clk => clk, we => C_we, addr_wr => C_addr_wr, addr_rd => C_addr_rd, din => C_din, dout => C_dout);

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
                when S7 => state <= S_END;
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
        A_we <= '0';
        B_we <= '0';
        C_we <= '0';
        Mux_A_addr_sel <= (others => '0');
        Mux_B_addr_sel <= (others => '0');
        Mux_Mul_0_left_sel <= (others => '0');
        Mux_Mul_0_right_sel <= (others => '0');
        Mux_Add_0_left_sel <= (others => '0');
        Mux_Add_0_right_sel <= (others => '0');
        Mux_C_addr_sel <= (others => '0');
        Mux_C_data_sel <= (others => '0');
        case state is
            when S0 =>
                R22_en <= '1';
                R0_en <= '1';
                R1_en <= '1';
                R4_en <= '1';
                R5_en <= '1';
                R10_en <= '1';
                R11_en <= '1';
                R16_en <= '1';
                R17_en <= '1';
            when S1 =>
                R2_en <= '1';
                R3_en <= '1';
                Mux_A_addr_sel <= std_logic_vector(to_unsigned(0, 2));
                Mux_B_addr_sel <= std_logic_vector(to_unsigned(0, 2));
            when S2 =>
                R8_en <= '1';
                R6_en <= '1';
                R7_en <= '1';
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(0, 2));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(0, 2));
                Mux_A_addr_sel <= std_logic_vector(to_unsigned(1, 2));
                Mux_B_addr_sel <= std_logic_vector(to_unsigned(1, 2));
            when S3 =>
                R9_en <= '1';
                R12_en <= '1';
                R13_en <= '1';
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(1, 2));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(1, 2));
                Mux_A_addr_sel <= std_logic_vector(to_unsigned(2, 2));
                Mux_B_addr_sel <= std_logic_vector(to_unsigned(2, 2));
            when S4 =>
                R14_en <= '1';
                R15_en <= '1';
                R18_en <= '1';
                R19_en <= '1';
                Mux_Add_0_left_sel <= std_logic_vector(to_unsigned(0, 2));
                Mux_Add_0_right_sel <= std_logic_vector(to_unsigned(0, 2));
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(2, 2));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(2, 2));
                Mux_A_addr_sel <= std_logic_vector(to_unsigned(3, 2));
                Mux_B_addr_sel <= std_logic_vector(to_unsigned(3, 2));
            when S5 =>
                R20_en <= '1';
                R21_en <= '1';
                Mux_Add_0_left_sel <= std_logic_vector(to_unsigned(1, 2));
                Mux_Add_0_right_sel <= std_logic_vector(to_unsigned(1, 2));
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(3, 2));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(3, 2));
            when S6 =>
                R23_en <= '1';
                Mux_Add_0_left_sel <= std_logic_vector(to_unsigned(2, 2));
                Mux_Add_0_right_sel <= std_logic_vector(to_unsigned(2, 2));
            when S7 =>
                C_we <= '1';
                Mux_C_addr_sel <= std_logic_vector(to_unsigned(0, 1));
                Mux_C_data_sel <= std_logic_vector(to_unsigned(0, 1));
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
            if R3_en = '1' then R3_out <= B_dout; end if;
            if R4_en = '1' then R4_out <= std_logic_vector(to_signed(1, DATA_WIDTH)); end if;
            if R5_en = '1' then R5_out <= std_logic_vector(to_signed(1, DATA_WIDTH)); end if;
            if R6_en = '1' then R6_out <= A_dout; end if;
            if R7_en = '1' then R7_out <= B_dout; end if;
            if R8_en = '1' then R8_out <= Mul_0_out; end if;
            if R9_en = '1' then R9_out <= Mul_0_out; end if;
            if R10_en = '1' then R10_out <= std_logic_vector(to_signed(2, DATA_WIDTH)); end if;
            if R11_en = '1' then R11_out <= std_logic_vector(to_signed(2, DATA_WIDTH)); end if;
            if R12_en = '1' then R12_out <= A_dout; end if;
            if R13_en = '1' then R13_out <= B_dout; end if;
            if R14_en = '1' then R14_out <= Add_0_out; end if;
            if R15_en = '1' then R15_out <= Mul_0_out; end if;
            if R16_en = '1' then R16_out <= std_logic_vector(to_signed(3, DATA_WIDTH)); end if;
            if R17_en = '1' then R17_out <= std_logic_vector(to_signed(3, DATA_WIDTH)); end if;
            if R18_en = '1' then R18_out <= A_dout; end if;
            if R19_en = '1' then R19_out <= B_dout; end if;
            if R20_en = '1' then R20_out <= Add_0_out; end if;
            if R21_en = '1' then R21_out <= Mul_0_out; end if;
            if R22_en = '1' then R22_out <= std_logic_vector(to_signed(0, DATA_WIDTH)); end if;
            if R23_en = '1' then R23_out <= Add_0_out; end if;
        end if;
    end process;

    -- Multiplexers
    with Mux_A_addr_sel select
        Mux_A_addr_out <=
            R0_out when "00",
            R4_out when "01",
            R10_out when "10",
            R16_out when "11",
            (others => '0') when others;
    with Mux_B_addr_sel select
        Mux_B_addr_out <=
            R1_out when "00",
            R5_out when "01",
            R11_out when "10",
            R17_out when "11",
            (others => '0') when others;
    with Mux_Mul_0_left_sel select
        Mux_Mul_0_left_out <=
            R2_out when "00",
            R6_out when "01",
            R12_out when "10",
            R18_out when "11",
            (others => '0') when others;
    with Mux_Mul_0_right_sel select
        Mux_Mul_0_right_out <=
            R3_out when "00",
            R7_out when "01",
            R13_out when "10",
            R19_out when "11",
            (others => '0') when others;
    with Mux_Add_0_left_sel select
        Mux_Add_0_left_out <=
            R8_out when "00",
            R14_out when "01",
            R20_out when "10",
            (others => '0') when others;
    with Mux_Add_0_right_sel select
        Mux_Add_0_right_out <=
            R9_out when "00",
            R15_out when "01",
            R21_out when "10",
            (others => '0') when others;
    with Mux_C_addr_sel select
        Mux_C_addr_out <=
            R22_out when "0",
            (others => '0') when others;
    with Mux_C_data_sel select
        Mux_C_data_out <=
            R23_out when "0",
            (others => '0') when others;
    -- Memory connections
    A_addr_rd <= Mux_A_addr_out(1 downto 0);
    A_addr_wr <= Mux_A_addr_out(1 downto 0);
    B_addr_rd <= Mux_B_addr_out(1 downto 0);
    B_addr_wr <= Mux_B_addr_out(1 downto 0);
    C_addr_rd <= Mux_C_addr_out(0 downto 0);
    C_addr_wr <= Mux_C_addr_out(0 downto 0);
    C_din <= Mux_C_data_out;

    -- Arithmetic connections
    Mul_0_a <= Mux_Mul_0_left_out;
    Mul_0_b <= Mux_Mul_0_right_out;
    Add_0_a <= Mux_Add_0_left_out;
    Add_0_b <= Mux_Add_0_right_out;

end Behavioral;