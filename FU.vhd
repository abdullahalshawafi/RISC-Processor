
--________________________________________________________________
--Forwarding Unit

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- ###### NOTES :
-- Rt Rs are addresses
-- Rd_M address & WB_M write back signal in memory stage
-- Rd_W address & WB_W write back signal  in write back stage
ENTITY FU IS
	PORT (
		Rs, Rt, Rd_M, Rd_W : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		WB_M, WB_W : IN STD_LOGIC;
		Rs_en, Rt_en : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
	);

END FU;
ARCHITECTURE FU_ARCH OF FU IS

BEGIN

	Rs_en <= "01" WHEN Rs = Rd_M AND WB_M = '1'
		ELSE
		"10" WHEN Rs = Rd_W AND WB_W = '1'
		ELSE
		"00";

	Rt_en <= "01" WHEN Rt = Rd_M AND WB_M = '1'
		ELSE
		"10" WHEN Rt = Rd_W AND WB_W = '1'
		ELSE
		"00";

END FU_ARCH;