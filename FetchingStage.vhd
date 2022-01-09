LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FETCH_STAGE IS
    PORT (
        rst, clk, pc_write : IN STD_LOGIC;
        in_port : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC_MODIFIED, target : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        CHANGE_PC, ex1, ex2, will_branch,int : IN STD_LOGIC;
        int_index : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        IF_ID_BUFFER : OUT STD_LOGIC_VECTOR(80 DOWNTO 0)
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
            pc, target : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            index : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            read_instruction, ex1, ex2, will_branch,int : IN STD_LOGIC;
            inst_type : OUT STD_LOGIC;
            instruction : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL instr_en, instType, pc_signal, pc_address_en : STD_LOGIC;
    SIGNAL instr : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL pc_out, pc_instruction : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN
    instr_en <= '1' WHEN pc_write = 'U' OR pc_write = '1'
        ELSE
        '0';

    pc_signal <= rst OR ex1 OR ex2 OR CHANGE_PC OR will_branch;
    pc_address_en <= rst OR ex1 OR ex2;
    x : PC PORT MAP(pc_signal, clk, instr_en, instType, pc_instruction, pc_out);
    y : INSTRUCTION_MEMORY PORT MAP(rst, clk, pc_instruction, target,int_index, instr_en, ex1, ex2, will_branch,int, instType, instr);

    pc_instruction <= instr WHEN pc_address_en = '1'
        ELSE
        PC_MODIFIED WHEN CHANGE_PC = '1'
        ELSE
        target WHEN will_branch = '1'
        ELSE
        pc_out;

    IF_ID_BUFFER <= in_port & instType & instr & pc_instruction;

END FETCH_STAGE;