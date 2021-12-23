

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MUX4 IS
GENERIC (n : integer := 16);
PORT( sel : IN std_logic_vector (1 DOWNTO 0);
in1,in2,in3,in4: IN std_logic_vector(n-1 DOWNTO 0);
my_out : OUT std_logic_vector(n-1 DOWNTO 0));
END MUX4;

--____________

ARCHITECTURE MUX4_Arch OF MUX4 
IS
BEGIN

my_out <= in1 WHEN sel ="00"  
else
	in2 WHEN sel ="01"  
else
	in3 WHEN sel ="10"
else
	in4 ;
 

END MUX4_Arch ;