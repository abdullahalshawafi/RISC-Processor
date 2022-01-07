

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY FLAG_MUX IS
 
PORT( sel : IN std_logic_vector (3 DOWNTO 0);
Z1,N1,C1 ,Z2,N2,C2 :IN std_logic;
Z,N,C : OUT std_logic);
END FLAG_MUX;

--____________

ARCHITECTURE FLAG_MUX_Arch OF FLAG_MUX 
IS
BEGIN

Z <= Z1 WHEN sel ="1100"  
else
Z2;
N <= N1 WHEN sel ="1100"  
else
N2;
C <= C1 WHEN sel ="1100"  
else
C2;	 

END FLAG_MUX_Arch ;
