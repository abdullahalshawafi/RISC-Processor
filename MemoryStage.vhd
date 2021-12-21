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
        IE_IM_BUFFER : IN STD_LOGIC_VECTOR (75 DOWNTO 0);
        clk : IN STD_LOGIC;
        IM_IW_BUFFER : OUT STD_LOGIC_VECTOR (52 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE MEMORY_STAGE1 OF MEMORY_STAGE IS

    COMPONENT DATA_MEMORY IS
        GENERIC (n : INTEGER := 16);
        PORT (
            clk : IN STD_LOGIC;
            my_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            data : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            write_mem : IN STD_LOGIC;
            write_back : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL memRead : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    SIGNAL PC : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Alu_result : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    SIGNAL Rs_data : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    SIGNAL Rd_address : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL WB, flush, stack_signal, mem_Read, mem_Write, load : STD_LOGIC;
    SIGNAL stack_OP : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN
    dataMem : DATA_MEMORY GENERIC MAP(16) PORT MAP(clk, alu_result, RS_data, mem_Write, memRead);

    PROCESS (clk) IS
    BEGIN
        IF (rising_edge(clk)) THEN
            PC <= IE_IM_BUFFER(31 DOWNTO 0);
            Alu_result <= IE_IM_BUFFER(47 DOWNTO 32);
            RS_data <= IE_IM_BUFFER(63 DOWNTO 48);
            Rd_address <= IE_IM_BUFFER(66 DOWNTO 64);
            mem_Write <= '0'; ---IE_IM_BUFFER(67)
            mem_Read <= '0'; ---IE_IM_BUFFER(68)
            stack_OP <= (OTHERS => '0'); ---IE_IM_BUFFER(69 downto 71)
            stack_signal <= '0'; ---IE_IM_BUFFER(72)
            flush <= '0'; ---IE_IM_BUFFER(73)
            WB <= IE_IM_BUFFER(74);
            load <= IE_IM_BUFFER(75);
            IM_IW_BUFFER(52) <= load;
            IM_IW_BUFFER(51) <= WB;
            IM_IW_BUFFER(50 DOWNTO 48) <= Rd_address;
            IM_IW_BUFFER(47 DOWNTO 32) <= (OTHERS => '0');
            IM_IW_BUFFER(31 DOWNTO 16) <= Alu_result;
            IM_IW_BUFFER(15 DOWNTO 0) <= memRead;
        END IF;
    END PROCESS;

END MEMORY_STAGE1;