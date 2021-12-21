LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

-- ###### NOTES :
-- ?? 12 signal bs kam bit?  CSs + PC + Rs & Rt data + instruction 32 bit
-- IE_IM_BUFFER[0:31] PC+1
-- IE_IM_BUFFER[32:47] ALU result
-- IE_IM_BUFFER[48:63] Rs data
-- IE_IM_BUFFER[64:66] Rd address
-- IE_IM_BUFFER[67:74] Control Unit

-- IM_IW_BUFFER:in std_logic_vector (32 downto 0 );
-- read data 0:15
-- alu result 16 :31
-- Rd data 32:47
-- Rd address 48:50 
-- wb signal 51
-- load signal 52
 

ENTITY MEMORY_STAGE IS
    GENERIC (n : INTEGER := 16);
    PORT (
	    IE_IM_BUFFER:in std_logic_vector (74 downto 0 );
        clk : IN std_logic;
        IM_IW_BUFFER:out std_logic_vector (52 downto 0 )
    );
END ENTITY;

ARCHITECTURE MEMORY_STAGE1 OF MEMORY_STAGE IS
    
    component DATA_MEMORY is
    Generic ( n : integer := 16);
    port(
        clk : IN std_logic;
        my_address: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        data: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        write_mem: IN std_logic;
        write_back: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
   end component;
   signal memRead:std_logic_vector(n-1 downto 0);
   signal PC :std_logic_vector(31 downto 0);
   signal Alu_result:std_logic_vector(n-1 downto 0);
   signal Rs_data:std_logic_vector(n-1 downto 0);
   signal Rd_address:std_logic_vector(2 downto 0);
   signal WB,flush,stack_signal,stack_OP,mem_Read,mem_Write,load : std_logic;
   
BEGIN
	PC <= IE_IM_BUFFER(31 downto 0);
	Alu_result <= IE_IM_BUFFER(47 downto 32);
    IM_IW_BUFFER(31 downto 16) <= Alu_result;
	RS_data <= IE_IM_BUFFER(63 downto 48);
	Rd_address <= IE_IM_BUFFER(66 downto 64);
	dataMem: DATA_MEMORY generic map(16) port map(clk,alu_result,RS_data,mem_Write,memRead);
    IM_IW_BUFFER(15 downto 0) <= memRead;
	            
    
END MEMORY_STAGE1;

