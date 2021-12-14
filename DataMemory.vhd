LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY DATA_MEMORY IS
    GENERIC (n : INTEGER := 16);
    PORT (
        clk : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_data : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        write_instruction : IN STD_LOGIC;
        read_data : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE DATA_MEMORY1 OF DATA_MEMORY IS

    TYPE memory IS ARRAY(INTEGER RANGE <>) OF STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    SIGNAL address_memory : memory(0 TO 1048575);

BEGIN
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF write_instruction = '1' THEN
                address_memory(to_integer(unsigned((address)))) <= write_data;
            END IF;
        END IF;
    END PROCESS;
    read_data <= write_data;
END DATA_MEMORY1;