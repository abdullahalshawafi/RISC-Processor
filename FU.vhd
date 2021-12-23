
--________________________________________________________________
--Forwarding Unit

Library ieee;
use ieee.std_logic_1164.all;


-- ###### NOTES :
-- Rt Rs are addresses
-- Rd_M address & WB_M write back signal in memory stage
-- Rd_W address & WB_W write back signal  in write back stage


entity FU is 
port(
Rs,Rt,Rd_M, Rd_W:in std_logic_vector (2 downto 0 );
WB_M,WB_W:in std_logic;
Rs_en,Rt_en : out std_logic_vector (1 downto 0)
);

end FU;


ARCHITECTURE FU_ARCH OF FU IS

BEGIN

Rs_en <= "01" when Rs = Rd_M and WB_M ='1'

else 
	 "10" when Rs = Rd_W and WB_W ='1'
else
	"00";

Rt_en <= "01" when Rt = Rd_M and WB_M ='1'

else 
 	 "10" when Rt = Rd_W and WB_W ='1'
else
	"00";
  
END FU_ARCH ;
 




