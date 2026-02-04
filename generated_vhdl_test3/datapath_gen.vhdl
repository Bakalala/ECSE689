-- Complete Datapath (Auto-Generated)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity Datapath is
    generic (
        DATA_WIDTH : integer := 32;
        ADDR_WIDTH : integer := 10
    );
    Port ( clk, rst : in STD_LOGIC;
           R0_en : in STD_LOGIC;
           R1_en : in STD_LOGIC;
           R10_en : in STD_LOGIC;
           R11_en : in STD_LOGIC;
           R12_en : in STD_LOGIC;
           R13_en : in STD_LOGIC;
           R14_en : in STD_LOGIC;
           R15_en : in STD_LOGIC;
           R16_en : in STD_LOGIC;
           R17_en : in STD_LOGIC;
           R18_en : in STD_LOGIC;
           R19_en : in STD_LOGIC;
           R2_en : in STD_LOGIC;
           R20_en : in STD_LOGIC;
           R21_en : in STD_LOGIC;
           R22_en : in STD_LOGIC;
           R23_en : in STD_LOGIC;
           R3_en : in STD_LOGIC;
           R4_en : in STD_LOGIC;
           R5_en : in STD_LOGIC;
           R6_en : in STD_LOGIC;
           R7_en : in STD_LOGIC;
           R8_en : in STD_LOGIC;
           R9_en : in STD_LOGIC;
           A_en : in STD_LOGIC;
           A_wr : in STD_LOGIC;
           B_en : in STD_LOGIC;
           B_wr : in STD_LOGIC;
           C_en : in STD_LOGIC;
           C_wr : in STD_LOGIC;
           Mux_A_addr_sel : in STD_LOGIC_VECTOR(3 downto 0);
           Mux_Add_0_left_sel : in STD_LOGIC_VECTOR(3 downto 0);
           Mux_Add_0_right_sel : in STD_LOGIC_VECTOR(3 downto 0);
           Mux_B_addr_sel : in STD_LOGIC_VECTOR(3 downto 0);
           Mux_C_addr_sel : in STD_LOGIC_VECTOR(3 downto 0);
           Mux_C_data_sel : in STD_LOGIC_VECTOR(3 downto 0);
           Mux_Mul_0_left_sel : in STD_LOGIC_VECTOR(3 downto 0);
           Mux_Mul_0_right_sel : in STD_LOGIC_VECTOR(3 downto 0);
           done : out STD_LOGIC);
end Datapath;

architecture Behavioral of Datapath is

    -- Register outputs
    signal R0_out : INTEGER := 0;
    signal R1_out : INTEGER := 0;
    signal R10_out : INTEGER := 0;
    signal R11_out : INTEGER := 0;
    signal R12_out : INTEGER := 0;
    signal R13_out : INTEGER := 0;
    signal R14_out : INTEGER := 0;
    signal R15_out : INTEGER := 0;
    signal R16_out : INTEGER := 0;
    signal R17_out : INTEGER := 0;
    signal R18_out : INTEGER := 0;
    signal R19_out : INTEGER := 0;
    signal R2_out : INTEGER := 0;
    signal R20_out : INTEGER := 0;
    signal R21_out : INTEGER := 0;
    signal R22_out : INTEGER := 0;
    signal R23_out : INTEGER := 0;
    signal R3_out : INTEGER := 0;
    signal R4_out : INTEGER := 0;
    signal R5_out : INTEGER := 0;
    signal R6_out : INTEGER := 0;
    signal R7_out : INTEGER := 0;
    signal R8_out : INTEGER := 0;
    signal R9_out : INTEGER := 0;

    -- Mux outputs
    signal Mux_A_addr_out : INTEGER := 0;
    signal Mux_B_addr_out : INTEGER := 0;
    signal Mux_Mul_0_left_out : INTEGER := 0;
    signal Mux_Mul_0_right_out : INTEGER := 0;
    signal Mux_Add_0_left_out : INTEGER := 0;
    signal Mux_Add_0_right_out : INTEGER := 0;
    signal Mux_C_addr_out : INTEGER := 0;
    signal Mux_C_data_out : INTEGER := 0;

    -- Memory data outputs
    signal A_dout : INTEGER := 0;
    signal B_dout : INTEGER := 0;
    signal C_dout : INTEGER := 0;

    -- Arithmetic unit outputs
    signal Add_0_out : INTEGER := 0;
    signal Mul_0_out : INTEGER := 0;

    -- Memory array type and initialization
    type ram_array is array (0 to 2**ADDR_WIDTH-1) of INTEGER;

    impure function init_ram(filename : in string) return ram_array is
        file ram_file : text;
        variable ram_line : line;
        variable temp_int : integer;
        variable temp_ram : ram_array;
        variable status : file_open_status;
    begin
        for i in 0 to 2**ADDR_WIDTH-1 loop
            temp_ram(i) := 0;
        end loop;
        file_open(status, ram_file, filename, read_mode);
        if status = open_ok then
            for i in 0 to 2**ADDR_WIDTH-1 loop
                if not endfile(ram_file) then
                    readline(ram_file, ram_line);
                    read(ram_line, temp_int);
                    temp_ram(i) := temp_int;
                end if;
            end loop;
            file_close(ram_file);
        end if;
        return temp_ram;
    end function;

    signal A_mem : ram_array := init_ram("A_content.txt");
    signal B_mem : ram_array := init_ram("B_content.txt");
    signal C_mem : ram_array := init_ram("C_content.txt");

begin

    done <= '1';  -- Always done for now

    -- Register update process
    process(clk)
    begin
        if rising_edge(clk) then
            if R0_en = '1' then R0_out <= 0; end if;
            if R1_en = '1' then R1_out <= 0; end if;
            if R10_en = '1' then R10_out <= 2; end if;
            if R11_en = '1' then R11_out <= 2; end if;
            if R12_en = '1' then R12_out <= A_dout; end if;
            if R13_en = '1' then R13_out <= B_dout; end if;
            if R14_en = '1' then R14_out <= Add_0_out; end if;
            if R15_en = '1' then R15_out <= Mul_0_out; end if;
            if R16_en = '1' then R16_out <= 3; end if;
            if R17_en = '1' then R17_out <= 3; end if;
            if R18_en = '1' then R18_out <= A_dout; end if;
            if R19_en = '1' then R19_out <= B_dout; end if;
            if R2_en = '1' then R2_out <= A_dout; end if;
            if R20_en = '1' then R20_out <= Add_0_out; end if;
            if R21_en = '1' then R21_out <= Mul_0_out; end if;
            if R22_en = '1' then R22_out <= 0; end if;
            if R23_en = '1' then R23_out <= Add_0_out; end if;
            if R3_en = '1' then R3_out <= B_dout; end if;
            if R4_en = '1' then R4_out <= 1; end if;
            if R5_en = '1' then R5_out <= 1; end if;
            if R6_en = '1' then R6_out <= A_dout; end if;
            if R7_en = '1' then R7_out <= B_dout; end if;
            if R8_en = '1' then R8_out <= Mul_0_out; end if;
            if R9_en = '1' then R9_out <= Mul_0_out; end if;
        end if;
    end process;

    -- Multiplexer logic
    Mux_A_addr_out <= R0_out when Mux_A_addr_sel = "0000" else
               R4_out when Mux_A_addr_sel = "0001" else
               R10_out when Mux_A_addr_sel = "0010" else
               R16_out when Mux_A_addr_sel = "0011" else 0;

    Mux_B_addr_out <= R1_out when Mux_B_addr_sel = "0000" else
               R5_out when Mux_B_addr_sel = "0001" else
               R11_out when Mux_B_addr_sel = "0010" else
               R17_out when Mux_B_addr_sel = "0011" else 0;

    Mux_Mul_0_left_out <= R2_out when Mux_Mul_0_left_sel = "0000" else
               R6_out when Mux_Mul_0_left_sel = "0001" else
               R12_out when Mux_Mul_0_left_sel = "0010" else
               R18_out when Mux_Mul_0_left_sel = "0011" else 0;

    Mux_Mul_0_right_out <= R3_out when Mux_Mul_0_right_sel = "0000" else
               R7_out when Mux_Mul_0_right_sel = "0001" else
               R13_out when Mux_Mul_0_right_sel = "0010" else
               R19_out when Mux_Mul_0_right_sel = "0011" else 0;

    Mux_Add_0_left_out <= R8_out when Mux_Add_0_left_sel = "0000" else
               R14_out when Mux_Add_0_left_sel = "0001" else
               R20_out when Mux_Add_0_left_sel = "0010" else 0;

    Mux_Add_0_right_out <= R9_out when Mux_Add_0_right_sel = "0000" else
               R15_out when Mux_Add_0_right_sel = "0001" else
               R21_out when Mux_Add_0_right_sel = "0010" else 0;

    Mux_C_addr_out <= R22_out when Mux_C_addr_sel = "0000" else
               0;

    Mux_C_data_out <= R23_out when Mux_C_data_sel = "0000" else
               0;

    -- Memory read logic (combinational)
    A_dout <= A_mem(Mux_A_addr_out);
    B_dout <= B_mem(Mux_B_addr_out);
    C_dout <= C_mem(Mux_C_addr_out);

    -- Memory write processes
    process(clk)
    begin
        if rising_edge(clk) then
            if C_wr = '1' then
                C_mem(Mux_C_addr_out) <= Mux_C_data_out;
            end if;
        end if;
    end process;

    -- Arithmetic units (combinational)
    Mul_0_out <= Mux_Mul_0_left_out * Mux_Mul_0_right_out;
    Add_0_out <= Mux_Add_0_left_out + Mux_Add_0_right_out;

end Behavioral;
