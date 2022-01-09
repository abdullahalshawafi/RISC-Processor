

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY BRANCH_MUX IS
 
 PORT( sel : IN std_logic_vector (2 DOWNTO 0);
	z,n,c: IN std_logic;
	my_out : OUT std_logic;
	Z_reset,N_reset,C_reset : OUT std_logic
	);

END BRANCH_MUX ;

--____________

ARCHITECTURE BRANCH_MUX_Arch OF BRANCH_MUX 
IS
BEGIN

my_out <= z WHEN sel ="000"  
else
	n WHEN sel ="001"  
else
	c WHEN sel ="010"
-- always jump
else
	'1' WHEN sel ="011";
-- reset flags if branch is taken
Z_reset <= '1' WHEN z ='1'
ELSE '0';
N_reset <= '1' WHEN n ='1'
ELSE '0';
C_reset <= '1' WHEN c ='1'
ELSE '0';

END BRANCH_MUX_Arch;