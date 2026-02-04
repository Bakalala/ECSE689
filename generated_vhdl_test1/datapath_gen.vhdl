-- Datapath (Auto-Generated)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity Datapath is
    generic (DATA_WIDTH : integer := 32; ADDR_WIDTH : integer := 10);
    Port ( clk, rst : in STD_LOGIC;
           R0_en : in STD_LOGIC;
           R1_en : in STD_LOGIC;
           R2_en : in STD_LOGIC;
           R3_en : in STD_LOGIC;
           R4_en : in STD_LOGIC;
           R5_en : in STD_LOGIC;
           R6_en : in STD_LOGIC;
           R7_en : in STD_LOGIC;
           R8_en : in STD_LOGIC;
           RAM_en : in STD_LOGIC;
           RAM_wr : in STD_LOGIC;
           Mux_Add_0_left_sel : in STD_LOGIC_VECTOR(3 downto 0);
           Mux_Add_0_right_sel : in STD_LOGIC_VECTOR(3 downto 0);
           Mux_Mul_0_left_sel : in STD_LOGIC_VECTOR(3 downto 0);
           Mux_Mul_0_right_sel : in STD_LOGIC_VECTOR(3 downto 0);
           Mux_RAM_addr_sel : in STD_LOGIC_VECTOR(3 downto 0);
           Mux_RAM_data_sel : in STD_LOGIC_VECTOR(3 downto 0);
           done : out STD_LOGIC);
end Datapath;

architecture Behavioral of Datapath is
    -- Registers
    signal R0_out : INTEGER := 0;
    signal R1_out : INTEGER := 0;
    signal R2_out : INTEGER := 0;
    signal R3_out : INTEGER := 0;
    signal R4_out : INTEGER := 0;
    signal R5_out : INTEGER := 0;
    signal R6_out : INTEGER := 0;
    signal R7_out : INTEGER := 0;
    signal R8_out : INTEGER := 0;
    -- Mux outputs
    signal Mux_RAM_addr_out : INTEGER := 0;
    signal Mux_Mul_0_left_out : INTEGER := 0;
    signal Mux_Mul_0_right_out : INTEGER := 0;
    signal Mux_Add_0_left_out : INTEGER := 0;
    signal Mux_Add_0_right_out : INTEGER := 0;
    signal Mux_RAM_data_out : INTEGER := 0;
    -- Memory outputs
    signal RAM_dout : INTEGER := 0;
    -- Arithmetic outputs
    signal Add_0_out : INTEGER := 0;
    signal Mul_0_out : INTEGER := 0;
    type ram_array is array (0 to 2**ADDR_WIDTH-1) of INTEGER;
    impure function init_ram(filename : string) return ram_array is
        file f : text; variable l : line; variable v : integer; variable r : ram_array; variable s : file_open_status;
    begin
        for i in r'range loop r(i) := 0; end loop;
        file_open(s, f, filename, read_mode);
        if s = open_ok then
            for i in r'range loop if not endfile(f) then readline(f, l); read(l, v); r(i) := v; end if; end loop;
            file_close(f);
        end if;
        return r;
    end function;
    signal RAM_mem : ram_array := init_ram("RAM_content.txt");

begin
    done <= '1';

    process(clk) begin
        if rising_edge(clk) then
            if R0_en = '1' then R0_out <= 0; end if;
            if R1_en = '1' then R1_out <= 1; end if;
            if R2_en = '1' then R2_out <= RAM_dout; end if;
            if R3_en = '1' then R3_out <= RAM_dout; end if;
            if R4_en = '1' then R4_out <= 2; end if;
            if R5_en = '1' then R5_out <= Mul_0_out; end if;
            if R6_en = '1' then R6_out <= RAM_dout; end if;
            if R7_en = '1' then R7_out <= 3; end if;
            if R8_en = '1' then R8_out <= Add_0_out; end if;
        end if;
    end process;

    Mux_RAM_addr_out <= R0_out when Mux_RAM_addr_sel = "0000" else R1_out when Mux_RAM_addr_sel = "0001" else R4_out when Mux_RAM_addr_sel = "0010" else R7_out when Mux_RAM_addr_sel = "0011" else 0;
    Mux_Mul_0_left_out <= R2_out when Mux_Mul_0_left_sel = "0000" else 0;
    Mux_Mul_0_right_out <= R3_out when Mux_Mul_0_right_sel = "0000" else 0;
    Mux_Add_0_left_out <= R5_out when Mux_Add_0_left_sel = "0000" else 0;
    Mux_Add_0_right_out <= R6_out when Mux_Add_0_right_sel = "0000" else 0;
    Mux_RAM_data_out <= R8_out when Mux_RAM_data_sel = "0000" else 0;

    RAM_dout <= RAM_mem(Mux_RAM_addr_out);

    process(clk) begin if rising_edge(clk) then if RAM_wr = '1' then RAM_mem(Mux_RAM_addr_out) <= Mux_RAM_data_out; end if; end if; end process;

    Mul_0_out <= Mux_Mul_0_left_out * Mux_Mul_0_right_out;
    Add_0_out <= Mux_Add_0_left_out + Mux_Add_0_right_out;

end Behavioral;