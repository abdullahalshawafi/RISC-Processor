LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FETCH_STAGE IS
    PORT (
        rst, clk, pc_write : IN STD_LOGIC;
        in_port : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IF_ID_BUFFER : OUT STD_LOGIC_VECTOR(80 DOWNTO 0);
        PC_MODIFIED,target : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        CHANGE_PC, EmptyStackException, InvalidAddressException,will_branch : IN STD_LOGIC
    );

END FETCH_STAGE;

ARCHITECTURE FETCH_STAGE OF FETCH_STAGE IS

    COMPONENT PC IS
        PORT (
            rst, clk, en, inst_type : IN STD_LOGIC;
            input_pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            current_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT INSTRUCTION_MEMORY IS
        PORT (
            rst, clk : IN STD_LOGIC;
            pc : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            read_instruction : IN STD_LOGIC;
            inst_type : OUT STD_LOGIC;
            instruction : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            EmptyStackException, InvalidAddressException : IN STD_LOGIC
        );
    END COMPONENT;

    SIGNAL instr_en, instType : STD_LOGIC;
    SIGNAL instr : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL pc_out,pc_instruction : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN
    instr_en <= '1' WHEN pc_write = 'U' OR pc_write = '1'
        ELSE
        '0';

    x : PC PORT MAP(rst, clk, instr_en, instType, instr, pc_out);
    y : INSTRUCTION_MEMORY PORT MAP(rst, clk, pc_instruction, instr_en, instType, instr,EmptyStackException, InvalidAddressException);



    pc_instruction <= PC_MODIFIED when CHANGE_PC = '1'
                else  target    when will_branch = '1'
                else pc_out;
    IF_ID_BUFFER <= in_port & instType & instr & pc_instruction;

END FETCH_STAGE;