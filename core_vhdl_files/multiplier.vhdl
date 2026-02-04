-- 32-bit Signed Integer Multiplier
-- Only lower 32 bits of result are kept (truncation)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier_32 is
    generic (DATA_WIDTH : integer := 32);
    port (
        a : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        b : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        y : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
    );
end multiplier_32;

architecture Behavioral of multiplier_32 is
    signal product : signed(2*DATA_WIDTH-1 downto 0);
begin
    -- Full 64-bit signed multiplication
    product <= signed(a) * signed(b);
    -- Keep only lower 32 bits
    y <= std_logic_vector(product(DATA_WIDTH-1 downto 0));
end Behavioral;
