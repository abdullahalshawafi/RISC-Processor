LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SP IS
    PORT (
        rst, clk, en : IN STD_LOGIC;
        modified_SP : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        current_SP : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := STD_LOGIC_VECTOR'(x"000FFFFF")
    );
END ENTITY;

ARCHITECTURE SP OF SP IS
BEGIN
    PROCESS (rst, clk, en) IS
    BEGIN
        IF (rst = '1') THEN
            current_SP <= STD_LOGIC_VECTOR'(x"000FFFFF");
        ELSIF (en = '1' AND rising_edge(clk)) THEN
            current_SP <= modified_SP;
        END IF;
    END PROCESS;
END ARCHITECTURE;