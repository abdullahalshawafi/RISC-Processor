LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY EPC IS
    PORT (
        PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        counter : IN STD_LOGIC_VECTOR(60 DOWNTO 0) --- 60?????????? 
    );
END EPC;

ARCHITECTURE EPC_Arch OF EPC IS
    TYPE my_array IS ARRAY(0 TO 60) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL EPC_file : my_array;
BEGIN
    EPC_file(to_integer(unsigned((counter)))) <= PC;
END EPC_Arch;