Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity RAM is
    GENERIC (n:integer :=16);
    port( 
        clk,write_address : in std_logic;
        data_in : in std_logic_vector(n-1 downto 0);
        address : in std_logic_vector(31 downto 0);
        data_out : out std_logic_vector(n-1 downto 0)
    );
end RAM;

Architecture RAM1 of RAM is
type ram_type is array (0 to 2**20) of std_logic_vector(n-1 downto 0);
signal ram : ram_type;
begin
	process(clk) is
	begin
		if rising_edge(clk) then
			if write_address = '1' then
				ram(to_integer(unsigned(address))) <= datain;
			end if;
		end if;
	end process;
	dataout <= ram(to_integer(unsigned(address)));
end RAM1;