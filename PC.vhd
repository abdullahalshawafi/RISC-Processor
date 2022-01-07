LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY PC IS
    PORT (
        rst, clk, en : IN STD_LOGIC;
        input_pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        current_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE PC OF PC IS
    SIGNAL temp_pc : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    PROCESS (rst, clk, en) IS
    BEGIN
        IF (rst = '1') THEN
            current_pc <= input_pc;
            temp_pc <= input_pc;
        ELSIF (en = '1' AND rising_edge(clk)) THEN
            current_pc <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(temp_pc)) + 1, 32));
            temp_pc <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(temp_pc)) + 1, 32));
        END IF;
    END PROCESS;
END ARCHITECTURE;