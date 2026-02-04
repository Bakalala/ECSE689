-- Testbench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testbench is end testbench;

architecture Behavioral of testbench is
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '1';
    constant CLK_PERIOD : time := 10 ns;
    signal state_out : STD_LOGIC_VECTOR(3 downto 0);
    signal done : STD_LOGIC;
begin
    clk <= not clk after CLK_PERIOD / 2;

    Design_inst: entity work.Design port map (clk => clk, rst => rst, state_out => state_out, done => done);

    process begin
        rst <= '1'; wait for CLK_PERIOD * 2;
        rst <= '0'; wait for CLK_PERIOD * 10;
        wait;
    end process;
end Behavioral;