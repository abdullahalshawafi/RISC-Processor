LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RAM IS
	GENERIC (n : INTEGER := 16);
	PORT(
            clk, write_mem,mem_Read : IN STD_LOGIC;
            stack_OP : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            data_in : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            address : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            PC_Read : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
END RAM;

ARCHITECTURE RAM1 OF RAM IS
	TYPE ram_type IS ARRAY (0 TO 2 ** 20) OF STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
	SIGNAL ram : ram_type;
BEGIN
	PROCESS (clk) IS
	BEGIN
		IF rising_edge(clk) THEN
			IF write_mem = '1' and (stack_OP /= "011" and stack_OP /= "101") THEN
				ram(to_integer(unsigned(address))) <= data_in;
			elsif mem_Read = '1' and (stack_OP /= "010" and stack_OP /= "100") then
				data_out <= ram(to_integer(unsigned(address)));
			elsif write_mem = '1' and (stack_OP = "011" or stack_OP = "101") then
				ram(to_integer(unsigned(address))) <= PC(15 DOWNTO 0);
				ram(to_integer(unsigned(address) + 1)) <= PC(31 DOWNTO 16);
			elsif mem_Read = '1' and (stack_OP = "010" or stack_OP = "100") then
				PC_Read(15 DOWNTO 0) <= ram(to_integer(unsigned(address) - 2));
				PC_Read(31 DOWNTO 16) <= ram(to_integer(unsigned(address) - 1));		
			END IF;		
		END IF;
	END PROCESS;
END RAM1;