-- HLS Generated Design (Controller + Datapath)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Design is
    Port ( clk, rst : in STD_LOGIC;
           state_out : out STD_LOGIC_VECTOR(2 downto 0);
           done : out STD_LOGIC);
end Design;

architecture Behavioral of Design is

    constant DATA_WIDTH : integer := 32;

    type state_type is (S0, S1, S2, S3, S4, S5, S_END);
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

    -- Memory signals
    signal RAM_we : STD_LOGIC;
    signal RAM_addr_wr : STD_LOGIC_VECTOR(1 downto 0);
    signal RAM_addr_rd : STD_LOGIC_VECTOR(1 downto 0);
    signal RAM_din : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal RAM_dout : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);

    -- Multiplexer signals
    signal Mux_RAM_addr_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal Mux_RAM_addr_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_Mul_0_left_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal Mux_Mul_0_left_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_Mul_0_right_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal Mux_Mul_0_right_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_Add_0_left_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal Mux_Add_0_left_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_Add_0_right_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal Mux_Add_0_right_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mux_RAM_data_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal Mux_RAM_data_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');

    -- Arithmetic unit signals
    signal Add_0_a, Add_0_b : INTEGER;
    signal Add_0_out : INTEGER;
    signal Mul_0_a, Mul_0_b : INTEGER;
    signal Mul_0_out : INTEGER;

    function encode_state(s: state_type) return STD_LOGIC_VECTOR is
    begin
        case s is
            when S0 => return std_logic_vector(to_unsigned(0, 3));
            when S1 => return std_logic_vector(to_unsigned(1, 3));
            when S2 => return std_logic_vector(to_unsigned(2, 3));
            when S3 => return std_logic_vector(to_unsigned(3, 3));
            when S4 => return std_logic_vector(to_unsigned(4, 3));
            when S5 => return std_logic_vector(to_unsigned(5, 3));
            when S_END => return std_logic_vector(to_unsigned(6, 3));
        end case;
    end function;

begin

    -- ========== Component Instantiations ==========

    -- Memory instances (dual_port_RAM)
    RAM_RAM: entity work.dual_port_RAM
        generic map (addr_width => 2, data_width => DATA_WIDTH, INIT_FILE => "RAM_content.txt")
        port map (clk => clk, we => RAM_we, addr_wr => RAM_addr_wr, addr_rd => RAM_addr_rd, din => RAM_din, dout => RAM_dout);

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
                when S5 => state <= S_END;
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
        RAM_we <= '0';
        Mux_RAM_addr_sel <= (others => '0');
        Mux_Mul_0_left_sel <= (others => '0');
        Mux_Mul_0_right_sel <= (others => '0');
        Mux_Add_0_left_sel <= (others => '0');
        Mux_Add_0_right_sel <= (others => '0');
        Mux_RAM_data_sel <= (others => '0');
        case state is
            when S0 =>
                R7_en <= '1';
                R0_en <= '1';
                R1_en <= '1';
                R4_en <= '1';
            when S1 =>
                R2_en <= '1';
                Mux_RAM_addr_sel <= std_logic_vector(to_unsigned(0, 4));
            when S2 =>
                R3_en <= '1';
                Mux_RAM_addr_sel <= std_logic_vector(to_unsigned(1, 4));
            when S3 =>
                R5_en <= '1';
                R6_en <= '1';
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(0, 4));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(0, 4));
                Mux_RAM_addr_sel <= std_logic_vector(to_unsigned(2, 4));
            when S4 =>
                R8_en <= '1';
                Mux_Add_0_left_sel <= std_logic_vector(to_unsigned(0, 4));
                Mux_Add_0_right_sel <= std_logic_vector(to_unsigned(0, 4));
            when S5 =>
                RAM_we <= '1';
                Mux_RAM_addr_sel <= std_logic_vector(to_unsigned(3, 4));
                Mux_RAM_data_sel <= std_logic_vector(to_unsigned(0, 4));
            when others => null;
        end case;
    end process;

    -- ========== Datapath ==========

    -- Registers
    process(clk) begin
        if rising_edge(clk) then
            if R0_en = '1' then R0_out <= std_logic_vector(to_signed(0, DATA_WIDTH)); end if;
            if R1_en = '1' then R1_out <= std_logic_vector(to_signed(1, DATA_WIDTH)); end if;
            if R2_en = '1' then R2_out <= RAM_dout; end if;
            if R3_en = '1' then R3_out <= RAM_dout; end if;
            if R4_en = '1' then R4_out <= std_logic_vector(to_signed(2, DATA_WIDTH)); end if;
            if R5_en = '1' then R5_out <= std_logic_vector(to_signed(Mul_0_out, DATA_WIDTH)); end if;
            if R6_en = '1' then R6_out <= RAM_dout; end if;
            if R7_en = '1' then R7_out <= std_logic_vector(to_signed(3, DATA_WIDTH)); end if;
            if R8_en = '1' then R8_out <= std_logic_vector(to_signed(Add_0_out, DATA_WIDTH)); end if;
        end if;
    end process;

    -- Multiplexers
    Mux_RAM_addr_out <= R0_out when Mux_RAM_addr_sel = "0000" else R1_out when Mux_RAM_addr_sel = "0001" else R4_out when Mux_RAM_addr_sel = "0010" else R7_out when Mux_RAM_addr_sel = "0011" else (others => '0');
    Mux_Mul_0_left_out <= R2_out when Mux_Mul_0_left_sel = "0000" else (others => '0');
    Mux_Mul_0_right_out <= R3_out when Mux_Mul_0_right_sel = "0000" else (others => '0');
    Mux_Add_0_left_out <= R5_out when Mux_Add_0_left_sel = "0000" else (others => '0');
    Mux_Add_0_right_out <= R6_out when Mux_Add_0_right_sel = "0000" else (others => '0');
    Mux_RAM_data_out <= R8_out when Mux_RAM_data_sel = "0000" else (others => '0');

    -- Memory connections
    RAM_addr_rd <= Mux_RAM_addr_out(1 downto 0);
    RAM_addr_wr <= Mux_RAM_addr_out(1 downto 0);
    RAM_din <= Mux_RAM_data_out;

    -- Arithmetic connections
    Mul_0_a <= to_integer(signed(Mux_Mul_0_left_out));
    Mul_0_b <= to_integer(signed(Mux_Mul_0_right_out));
    Add_0_a <= to_integer(signed(Mux_Add_0_left_out));
    Add_0_b <= to_integer(signed(Mux_Add_0_right_out));

end Behavioral;