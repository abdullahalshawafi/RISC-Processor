LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY INSTRUCTION_MEMORY IS
    GENERIC (n : INTEGER := 16);
    PORT (
        clk : IN STD_LOGIC;
        pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        read_instruction : IN STD_LOGIC;
        instruction : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE INSTRUCTION_MEMORY1 OF INSTRUCTION_MEMORY IS

    TYPE memory IS ARRAY(INTEGER RANGE <>) OF STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    SIGNAL addressing_instruction : memory(0 TO 1048575);

BEGIN
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF read_instruction = '1' THEN
                instruction <= addressing_instruction(to_integer(unsigned((pc))));
            END IF;
        END IF;
    END PROCESS;
END INSTRUCTION_MEMORY1;