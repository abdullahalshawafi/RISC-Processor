
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MUX2 IS
GENERIC (n : integer := 16);
PORT( sel : IN std_logic;
in1,in2: IN std_logic_vector(n-1 DOWNTO 0);
my_out : OUT std_logic_vector(n-1 DOWNTO 0));
END MUX2;

--____________

ARCHITECTURE MUX2_Arch OF MUX2 
IS
BEGIN

my_out <= in1 WHEN sel ='0'  
else
	in2 WHEN sel ='1'  ;
 

END MUX2_Arch ;