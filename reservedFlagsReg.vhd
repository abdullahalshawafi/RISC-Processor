LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY R_FLAG_REG IS

    PORT (
        clk, rst : IN STD_LOGIC;
         Z, N, C : IN STD_LOGIC;
         en: IN STD_LOGIC_VECTOR (3 DOWNTO 0 );
        Z_out, N_out, C_out : OUT STD_LOGIC);
END R_FLAG_REG;

ARCHITECTURE R_FLAG_REG_Arch OF R_FLAG_REG IS
BEGIN
    -- Z N C
    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            Z_out <= '0';
            N_out <= '0';
            C_out <= '0';
        ELSIF (rising_edge(clk)) THEN
            IF (en = "1101") THEN
                Z_out <= Z;
            END IF;
            IF (en = "1101") THEN
                N_out <= N;
            END IF;
            IF (en = "1101") THEN
                C_out <= C;
            END IF;
        END IF;
    END PROCESS;
END R_FLAG_REG_Arch;