LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY EPC IS
    PORT (
        clk, rst, exception : IN STD_LOGIC;
        PC : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        EPC : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );

END EPC;

ARCHITECTURE EPC_arch OF EPC IS
    SIGNAL PC_signal : STD_LOGIC_VECTOR (31 DOWNTO 0);
BEGIN
    PROCESS (clk, rst, exception)
    BEGIN
        IF (rst = '1') THEN
            PC_signal <= (OTHERS => '0');
        ELSIF (falling_edge(clk) AND exception = '1') THEN
            PC_signal <= PC;
        END IF;

    END PROCESS;

    EPC <= PC_signal;
END EPC_arch;