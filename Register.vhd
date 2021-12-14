LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY register_component IS
    PORT (
        reg_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        clk, rst : IN STD_LOGIC;
        reg_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );

END register_component;

ARCHITECTURE register_component_arch OF register_component IS
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            reg_out <= (OTHERS => '0');
        ELSIF (rising_edge(clk)) THEN
            reg_out <= reg_in;

        END IF;

    END PROCESS;
END register_component_arch;