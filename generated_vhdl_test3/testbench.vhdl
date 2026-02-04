-- Testbench for HLS Generated Design
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testbench is
end testbench;

architecture Behavioral of testbench is
    -- Clock and reset
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '1';
    constant CLK_PERIOD : time := 10 ns;

    -- Control signals (connect Controller to Datapath)
    signal R0_en : STD_LOGIC;
    signal R1_en : STD_LOGIC;
    signal R10_en : STD_LOGIC;
    signal R11_en : STD_LOGIC;
    signal R12_en : STD_LOGIC;
    signal R13_en : STD_LOGIC;
    signal R14_en : STD_LOGIC;
    signal R15_en : STD_LOGIC;
    signal R16_en : STD_LOGIC;
    signal R17_en : STD_LOGIC;
    signal R18_en : STD_LOGIC;
    signal R19_en : STD_LOGIC;
    signal R2_en : STD_LOGIC;
    signal R20_en : STD_LOGIC;
    signal R21_en : STD_LOGIC;
    signal R22_en : STD_LOGIC;
    signal R23_en : STD_LOGIC;
    signal R3_en : STD_LOGIC;
    signal R4_en : STD_LOGIC;
    signal R5_en : STD_LOGIC;
    signal R6_en : STD_LOGIC;
    signal R7_en : STD_LOGIC;
    signal R8_en : STD_LOGIC;
    signal R9_en : STD_LOGIC;
    signal A_en : STD_LOGIC;
    signal A_wr : STD_LOGIC;
    signal B_en : STD_LOGIC;
    signal B_wr : STD_LOGIC;
    signal C_en : STD_LOGIC;
    signal C_wr : STD_LOGIC;
    signal Mux_A_addr_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal Mux_Add_0_left_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal Mux_Add_0_right_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal Mux_B_addr_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal Mux_C_addr_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal Mux_C_data_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal Mux_Mul_0_left_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal Mux_Mul_0_right_sel : STD_LOGIC_VECTOR(3 downto 0);
    signal state_out : STD_LOGIC_VECTOR(3 downto 0);

    -- Done signal from Datapath
    signal done : STD_LOGIC;

begin

    -- Clock generation
    clk <= not clk after CLK_PERIOD / 2;

    -- Controller instantiation
    CTRL: entity work.Controller
        port map (
            clk => clk,
            rst => rst,
            R0_en => R0_en,
            R1_en => R1_en,
            R10_en => R10_en,
            R11_en => R11_en,
            R12_en => R12_en,
            R13_en => R13_en,
            R14_en => R14_en,
            R15_en => R15_en,
            R16_en => R16_en,
            R17_en => R17_en,
            R18_en => R18_en,
            R19_en => R19_en,
            R2_en => R2_en,
            R20_en => R20_en,
            R21_en => R21_en,
            R22_en => R22_en,
            R23_en => R23_en,
            R3_en => R3_en,
            R4_en => R4_en,
            R5_en => R5_en,
            R6_en => R6_en,
            R7_en => R7_en,
            R8_en => R8_en,
            R9_en => R9_en,
            A_en => A_en,
            A_wr => A_wr,
            B_en => B_en,
            B_wr => B_wr,
            C_en => C_en,
            C_wr => C_wr,
            Mux_A_addr_sel => Mux_A_addr_sel,
            Mux_Add_0_left_sel => Mux_Add_0_left_sel,
            Mux_Add_0_right_sel => Mux_Add_0_right_sel,
            Mux_B_addr_sel => Mux_B_addr_sel,
            Mux_C_addr_sel => Mux_C_addr_sel,
            Mux_C_data_sel => Mux_C_data_sel,
            Mux_Mul_0_left_sel => Mux_Mul_0_left_sel,
            Mux_Mul_0_right_sel => Mux_Mul_0_right_sel,
            state_out => state_out
        );

    -- Datapath instantiation
    DP: entity work.Datapath
        port map (
            clk => clk,
            rst => rst,
            R0_en => R0_en,
            R1_en => R1_en,
            R10_en => R10_en,
            R11_en => R11_en,
            R12_en => R12_en,
            R13_en => R13_en,
            R14_en => R14_en,
            R15_en => R15_en,
            R16_en => R16_en,
            R17_en => R17_en,
            R18_en => R18_en,
            R19_en => R19_en,
            R2_en => R2_en,
            R20_en => R20_en,
            R21_en => R21_en,
            R22_en => R22_en,
            R23_en => R23_en,
            R3_en => R3_en,
            R4_en => R4_en,
            R5_en => R5_en,
            R6_en => R6_en,
            R7_en => R7_en,
            R8_en => R8_en,
            R9_en => R9_en,
            A_en => A_en,
            A_wr => A_wr,
            B_en => B_en,
            B_wr => B_wr,
            C_en => C_en,
            C_wr => C_wr,
            Mux_A_addr_sel => Mux_A_addr_sel,
            Mux_Add_0_left_sel => Mux_Add_0_left_sel,
            Mux_Add_0_right_sel => Mux_Add_0_right_sel,
            Mux_B_addr_sel => Mux_B_addr_sel,
            Mux_C_addr_sel => Mux_C_addr_sel,
            Mux_C_data_sel => Mux_C_data_sel,
            Mux_Mul_0_left_sel => Mux_Mul_0_left_sel,
            Mux_Mul_0_right_sel => Mux_Mul_0_right_sel,
            done => done
        );

    -- Stimulus process
    process
    begin
        rst <= '1';
        wait for CLK_PERIOD * 2;
        rst <= '0';
        wait for CLK_PERIOD * 11;  -- Run all states
        wait;
    end process;

end Behavioral;