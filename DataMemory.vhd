LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY DATA_MEMORY IS
    GENERIC (n:integer :=16);
    PORT (
        clk : IN std_logic;
        address: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_data: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        write_instruction: IN std_logic;
        read_data: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE DATA_MEMORY1 OF DATA_MEMORY IS
    
    TYPE memory IS array(integer range <>) of std_logic_vector(n-1 DOWNTO 0);
    SIGNAL addressing_instruction : memory(0 TO 1048575);

BEGIN
    PROCESS(clk) IS 
        BEGIN
        IF rising_edge(clk) THEN 
            IF write_instruction = '1' THEN  
               addressing_instruction(to_integer(unsigned((address)))) <= write_data ; 
            END IF;
        END IF;
    END PROCESS;
    	
    
END DATA_MEMORY1;

