LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY MUX2 IS
	GENERIC (n : INTEGER := 16);
	PORT (
		sel : IN STD_LOGIC;
		in1, in2 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
		my_out : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));
END MUX2;

--____________

ARCHITECTURE MUX2_Arch OF MUX2 IS
BEGIN

	my_out <= in1 WHEN sel = '0'
		ELSE
		in2 WHEN sel = '1';
END MUX2_Arch;