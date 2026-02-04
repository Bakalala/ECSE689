-- 32-bit Signed Integer Adder
-- Overflow is ignored (C semantics): result wraps around
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder_32 is
    generic (DATA_WIDTH : integer := 32);
    port (
        a : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        b : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        y : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
    );
end adder_32;

architecture Behavioral of adder_32 is
begin
    -- Signed addition, overflow naturally wraps in 32-bit result
    y <= std_logic_vector(signed(a) + signed(b));
end Behavioral;