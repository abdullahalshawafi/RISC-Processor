
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

  -- Rs_en, Rt_en, flush from CU 
  -- Mem_read, Rd_address from ID_IE_BUFFER
  -- Rs_address, Rt_address from IF_ID_BUFFER 
  -- OUT SIGNAL IS MISSING FOR FREEZING EL PC
ENTITY HDU IS
        PORT (
                Rs_address, Rt_address, Rd_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                Rs_en, Rt_en, Mem_read, flush : IN STD_LOGIC;
                stall_pipe : OUT STD_LOGIC -- ORed m3 flush signal 
        );

END HDU;
ARCHITECTURE HDU_ARCH OF HDU IS

signal flush_HDU:  STD_LOGIC;
BEGIN

        flush_HDU <= '1'  when (Mem_read = '1' and ((Rs_en = '1' AND Rs_address = Rd_address) OR (Rt_en = '1' AND Rt_address = Rd_address)))
        else '0';

        stall_pipe<= FLUSH OR flush_HDU;
END HDU_ARCH;