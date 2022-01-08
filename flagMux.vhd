

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY FLAG_MUX IS

    PORT (
        sel : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        Z1, N1, C1, Z2, N2, C2 : IN STD_LOGIC;
        Z, N, C : OUT STD_LOGIC);
END FLAG_MUX;

--____________

ARCHITECTURE FLAG_MUX_Arch OF FLAG_MUX
    IS
BEGIN

    Z <= Z1 WHEN sel = "1100"
        ELSE
        Z2;
    N <= N1 WHEN sel = "1100"
        ELSE
        N2;
    C <= C1 WHEN sel = "1100"
        ELSE
        C2;

END FLAG_MUX_Arch;