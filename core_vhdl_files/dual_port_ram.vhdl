-- dual_port_RAM.vhd

-- created by   :   Meher Krishna Patel
-- date         :   26-Dec-16

-- Functionality:
-- store and retrieve data from single port RAM

-- ports:
-- we         : write enable
-- addr_wr    : address for writing data
-- addr_rd     : address for reading
-- din        : input data to be stored in RAM
-- data       : output data read from RAM
-- addr_width : total number of elements to store (put exact number)
-- addr_bits  : bits requires to store elements specified by addr_width
-- data_width : number of bits in each elements

-- Got some help with AI to load RAM content from a file, since the stackoverflow answer was not functioning as expected

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity dual_port_RAM is
    generic (
        addr_width : integer := 2;
        data_width : integer := 32;
        INIT_FILE : string := "ram_content.txt"
    );
    
    port(
        clk: in std_logic;
        we : in std_logic;
        addr_wr, addr_rd : in std_logic_vector(addr_width-1 downto 0);
        din : in std_logic_vector(data_width-1 downto 0);
        dout : out std_logic_vector(data_width-1 downto 0)
        );
end dual_port_RAM;

architecture arch of dual_port_RAM is
    type ram_type is array (2**addr_width-1 downto 0) of std_logic_vector (data_width-1 downto 0);
    
    impure function init_ram(filename : in string) return ram_type is
        file ram_file : text;
        variable ram_line : line;
        variable temp_int : integer;
        variable temp_ram : ram_type;
        variable status : file_open_status;
    begin
        -- Init with zeros
        for i in 0 to 2**addr_width-1 loop
            temp_ram(i) := (others => '0');
        end loop;
        
        file_open(status, ram_file, filename, read_mode);
        if status = open_ok then
            for i in 0 to 2**addr_width-1 loop
                if not endfile(ram_file) then
                    readline(ram_file, ram_line);
                    read(ram_line, temp_int);
                    temp_ram(i) := std_logic_vector(to_signed(temp_int, data_width));
                end if;
            end loop;
            file_close(ram_file);
        else
            report "RAM Init: Could not open file " & filename severity warning;
        end if;
        return temp_ram;
    end function;

    signal ram_dual_port : ram_type := init_ram(INIT_FILE);
begin
    process(clk)
    begin 
        if (clk'event and clk='1') then
            if (we='1') then -- write data to address 'addr_wr'
        -- convert 'addr_wr' type to integer from std_logic_vector
                ram_dual_port(to_integer(unsigned(addr_wr))) <= din;
            end if;
        end if;
    end process;

    -- get address for reading data from 'addr_rd'
    -- convert 'addr_rd' type to integer from std_logic_vector
    dout <= ram_dual_port(to_integer(unsigned(addr_rd)));
end arch;
