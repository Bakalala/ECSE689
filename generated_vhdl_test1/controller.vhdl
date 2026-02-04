-- FSM Controller
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Controller is
    Port ( clk, rst : in STD_LOGIC;
           R0_en : out STD_LOGIC;
           R1_en : out STD_LOGIC;
           R2_en : out STD_LOGIC;
           R3_en : out STD_LOGIC;
           R4_en : out STD_LOGIC;
           R5_en : out STD_LOGIC;
           R6_en : out STD_LOGIC;
           R7_en : out STD_LOGIC;
           R8_en : out STD_LOGIC;
           RAM_en : out STD_LOGIC;
           RAM_wr : out STD_LOGIC;
           Mux_Add_0_left_sel : out STD_LOGIC_VECTOR(3 downto 0);
           Mux_Add_0_right_sel : out STD_LOGIC_VECTOR(3 downto 0);
           Mux_Mul_0_left_sel : out STD_LOGIC_VECTOR(3 downto 0);
           Mux_Mul_0_right_sel : out STD_LOGIC_VECTOR(3 downto 0);
           Mux_RAM_addr_sel : out STD_LOGIC_VECTOR(3 downto 0);
           Mux_RAM_data_sel : out STD_LOGIC_VECTOR(3 downto 0);
           state_out : out STD_LOGIC_VECTOR(2 downto 0));
end Controller;

architecture Behavioral of Controller is
    type state_type is (S0, S1, S2, S3, S4, S5, S_END);
    signal state : state_type := S0;
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

    state_out <= encode_state(state);

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
        RAM_en <= '0'; RAM_wr <= '0';
        Mux_Add_0_left_sel <= (others => '0');
        Mux_Add_0_right_sel <= (others => '0');
        Mux_Mul_0_left_sel <= (others => '0');
        Mux_Mul_0_right_sel <= (others => '0');
        Mux_RAM_addr_sel <= (others => '0');
        Mux_RAM_data_sel <= (others => '0');
        case state is
            when S0 =>
                R7_en <= '1';
                R0_en <= '1';
                R1_en <= '1';
                R4_en <= '1';
            when S1 =>
                R2_en <= '1';
                RAM_en <= '1';
                Mux_RAM_addr_sel <= std_logic_vector(to_unsigned(0, 4));
            when S2 =>
                R3_en <= '1';
                RAM_en <= '1';
                Mux_RAM_addr_sel <= std_logic_vector(to_unsigned(1, 4));
            when S3 =>
                R5_en <= '1';
                R6_en <= '1';
                RAM_en <= '1';
                Mux_Mul_0_left_sel <= std_logic_vector(to_unsigned(0, 4));
                Mux_Mul_0_right_sel <= std_logic_vector(to_unsigned(0, 4));
                Mux_RAM_addr_sel <= std_logic_vector(to_unsigned(2, 4));
            when S4 =>
                R8_en <= '1';
                Mux_Add_0_left_sel <= std_logic_vector(to_unsigned(0, 4));
                Mux_Add_0_right_sel <= std_logic_vector(to_unsigned(0, 4));
            when S5 =>
                RAM_en <= '1';
                RAM_wr <= '1';
                Mux_RAM_addr_sel <= std_logic_vector(to_unsigned(3, 4));
                Mux_RAM_data_sel <= std_logic_vector(to_unsigned(0, 4));
            when others => null;
        end case;
    end process;
end Behavioral;