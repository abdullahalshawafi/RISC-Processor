LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY buffer_component IS
    GENERIC (n : INTEGER := 16);
    PORT (
        clk, rst : IN STD_LOGIC;
        reg_in : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        reg_out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
    );

END buffer_component;

ARCHITECTURE buffer_component_arch OF buffer_component IS
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            reg_out <= (OTHERS => '0');
        ELSIF (rising_edge(clk)) THEN
            reg_out <= reg_in;
        END IF;

    END PROCESS;
END buffer_component_arch;