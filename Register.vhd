LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY register_component IS
    PORT (
        clk, rst, en : IN STD_LOGIC;
        reg_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        reg_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );

END register_component;

ARCHITECTURE register_component_arch OF register_component IS
    SIGNAL reg_out_signal : STD_LOGIC_VECTOR (15 DOWNTO 0);
BEGIN
    PROCESS (clk, rst, en)
    BEGIN
        IF (rst = '1') THEN
            reg_out_signal <= (OTHERS => '0');
        ELSIF (falling_edge(clk) AND en = '1') THEN
            reg_out_signal <= reg_in;
        END IF;

    END PROCESS;

    reg_out <= reg_out_signal;
END register_component_arch;