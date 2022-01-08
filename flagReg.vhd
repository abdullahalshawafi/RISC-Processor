LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY FLAG_REG IS

    PORT (
        clk, rst : IN STD_LOGIC;
        en_z, en_n, en_c, Z, N, C : IN STD_LOGIC;
        Z_out, N_out, C_out : OUT STD_LOGIC);
END FLAG_REG;

ARCHITECTURE FLAG_REG_Arch OF FLAG_REG IS
BEGIN
    -- Z N C
    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            Z_out <= '0';
            N_out <= '0';
            C_out <= '0';
        ELSIF (falling_edge(clk)) THEN
            IF (en_z = '1') THEN
                Z_out <= Z;
            END IF;
            IF (en_n = '1') THEN
                N_out <= N;
            END IF;
            IF (en_c = '1') THEN
                C_out <= C;
            END IF;
        END IF;
    END PROCESS;
END FLAG_REG_Arch;