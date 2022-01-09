

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY BRANCH_MUX IS

	PORT (
		sel : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		z, n, c : IN STD_LOGIC;
		my_out : OUT STD_LOGIC;
		Z_reset, N_reset, C_reset : OUT STD_LOGIC
	);

END BRANCH_MUX;

--____________

ARCHITECTURE BRANCH_MUX_Arch OF BRANCH_MUX
	IS
BEGIN

	my_out <= z WHEN sel = "000"
		ELSE
		n WHEN sel = "001"
		ELSE
		c WHEN sel = "010"
		-- always jump
		ELSE
		'1' WHEN sel = "011"
		ELSE
		'0';
	-- reset flags if branch is taken
	Z_reset <= '1' WHEN z = '1' AND sel = "000"
		ELSE
		'0';
	N_reset <= '1' WHEN n = '1' AND sel = "001"
		ELSE
		'0';
	C_reset <= '1' WHEN c = '1' AND sel = "010"
		ELSE
		'0';

END BRANCH_MUX_Arch;