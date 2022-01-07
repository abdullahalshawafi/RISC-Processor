LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY DATA_MEMORY IS
    GENERIC (n : INTEGER := 16);
    PORT (
        clk : IN STD_LOGIC;
        my_address : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        PC, current_SP, modified_SP : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Exception:IN STD_LOGIC;
        data : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        write_mem, mem_Read, stack_signal : IN STD_LOGIC;
        stack_OP : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        PC_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_back : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE DATA_MEMORY1 OF DATA_MEMORY IS

    COMPONENT RAM IS
        GENERIC (n : INTEGER := 16);
        PORT (
            clk, write_mem, mem_Read : IN STD_LOGIC;
            stack_OP : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            data_in : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            address : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            PC_Read : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL memRead : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL PC_Read : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL address : STD_LOGIC_VECTOR(19 DOWNTO 0);
    SIGNAL write_mem_modified, mem_Read_modified : STD_LOGIC;
    
BEGIN
    address <= "0000" & my_address WHEN stack_signal = '0'
        ELSE
        current_SP(19 DOWNTO 0) WHEN (stack_OP = "000" OR stack_OP = "011"OR stack_OP = "101")
        ELSE
        modified_SP(19 DOWNTO 0) WHEN (stack_OP = "010" OR stack_OP = "100" OR stack_OP = "001");
    write_mem_modified <= write_mem WHEN Exception = '0' ELSE '0' ;
    mem_Read_modified <= mem_Read WHEN Exception = '0' ELSE '0' ;
    
    dataMem : RAM GENERIC MAP(16) PORT MAP(clk, write_mem_modified, mem_Read_modified, stack_OP, data, address, memRead, PC, PC_Read);
    write_back <= memRead;
    PC_OUT <= PC_Read;
END DATA_MEMORY1;