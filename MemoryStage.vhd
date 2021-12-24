LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.all;
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
        IE_IM_BUFFER : IN STD_LOGIC_VECTOR (76 DOWNTO 0);
        clk,rst : IN STD_LOGIC;
        IM_IW_BUFFER : OUT STD_LOGIC_VECTOR (53 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE MEMORY_STAGE1 OF MEMORY_STAGE IS

    COMPONENT DATA_MEMORY IS
        GENERIC (n : INTEGER := 16);
        PORT (
            clk : IN STD_LOGIC;
            my_address : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            PC,current_SP,modified_SP : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            data : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            write_mem, mem_Read,stack_signal : IN STD_LOGIC;
            stack_OP : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            PC_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            write_back : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT SP IS
    PORT (
        rst, clk, en : IN STD_LOGIC;
        modified_SP : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        current_SP : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    SIGNAL memRead : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    SIGNAL PC,PC_OUT,PC_New : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Alu_result : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    SIGNAL Rs_data : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    SIGNAL Rd_address : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL WB, flush, stack_signal, mem_Read, mem_Write, load,en,EmptyStackException : STD_LOGIC;
    SIGNAL stack_OP : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL current_SP,modified_SP : STD_LOGIC_VECTOR(31 DOWNTO 0) := STD_LOGIC_VECTOR'(x"000FFFFF") ;
    
BEGIN
    dataMem : DATA_MEMORY GENERIC MAP(16) PORT MAP(clk, alu_result,PC,current_SP,modified_SP, RS_data, mem_Write, mem_Read,stack_signal,stack_OP,PC_OUT, memRead);
    
    Stack : SP PORT MAP(rst,clk,en, modified_SP,current_SP);
    
----------------------------------take the inputs----------------------------------------------------------

    PC <= IE_IM_BUFFER(31 DOWNTO 0);
    Alu_result <= IE_IM_BUFFER(47 DOWNTO 32);
    RS_data <= IE_IM_BUFFER(63 DOWNTO 48);
    Rd_address <= IE_IM_BUFFER(66 DOWNTO 64);
    mem_Write <= IE_IM_BUFFER(67);
    mem_Read <= IE_IM_BUFFER(68);
    stack_OP <= IE_IM_BUFFER(71 downto 69);
    stack_signal <= IE_IM_BUFFER(72);
    flush <= IE_IM_BUFFER(73);
    WB <= IE_IM_BUFFER(74);
    load <= IE_IM_BUFFER(75);

    
---------------------------------- Stack process ----------------------------------------------------------

    en <= '1' when stack_signal = '1' else '0';
    
    
    modified_SP <= current_SP + 1 when stack_signal = '1' and stack_OP = "001"   --POP
            else  current_SP + 2 when stack_signal = '1' and (stack_OP = "010" or stack_OP = "100")   --RET or RTI
            else  current_SP - 1 when stack_signal = '1' and stack_OP = "000"   --PUSH
            else  current_SP - 2 when stack_signal = '1' and (stack_OP = "011"or stack_OP = "101");   --CALL or int

    PC_New <= PC_OUT when stack_signal = '1' and (stack_OP = "010" or stack_OP = "100")
            else PC;   --RET or RTI


---------------------------------- pass the output to the buffer ----------------------------------------------------------
    IM_IW_BUFFER(53) <= IE_IM_BUFFER(76);
    IM_IW_BUFFER(52) <= load;
    IM_IW_BUFFER(51) <= WB;
    IM_IW_BUFFER(50 DOWNTO 48) <= Rd_address;
    IM_IW_BUFFER(47 DOWNTO 32) <= (OTHERS => '0');
    IM_IW_BUFFER(31 DOWNTO 16) <= Alu_result;
    IM_IW_BUFFER(15 DOWNTO 0) <= memRead;

END MEMORY_STAGE1;