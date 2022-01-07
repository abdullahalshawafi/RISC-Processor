

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY BRANCH_MUX IS
 
 PORT( sel : IN std_logic_vector (2 DOWNTO 0);
	z,n,c: IN std_logic;
	my_out : OUT std_logic
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

 

END BRANCH_MUX_Arch;