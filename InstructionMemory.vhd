LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY INSTRUCTION_MEMORY IS
    PORT (
        rst, clk : IN STD_LOGIC;
        pc, target : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        index : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        read_instruction, ex1, ex2, will_branch,int : IN STD_LOGIC;
        inst_type : OUT STD_LOGIC;
        instruction : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE INSTRUCTION_MEMORY1 OF INSTRUCTION_MEMORY IS

    TYPE memory IS ARRAY(INTEGER RANGE <>) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL addressing_instruction : memory(0 TO ((2 ** 20) - 1));

BEGIN
    PROCESS (rst, clk, pc, target, read_instruction, ex1, ex2, will_branch, instruction) IS
    BEGIN
        IF rst = '1' THEN
            instruction <= addressing_instruction(1) & addressing_instruction(0);
        ELSIF ex1 = '1' THEN
            instruction <= addressing_instruction(3) & addressing_instruction(2);
        ELSIF ex2 = '1' THEN
            instruction <= addressing_instruction(5) & addressing_instruction(4);
        ELSIF int = '1' THEN
            instruction <= addressing_instruction(to_integer(unsigned((index + 7)))) & addressing_instruction(to_integer(unsigned((index + 6))));
        ELSIF will_branch = '1' THEN
            instruction <= addressing_instruction(to_integer(unsigned((target)))) & X"0000";
            inst_type <= '0';

            IF instruction(31 DOWNTO 27) = "01100" OR instruction(31 DOWNTO 27) = "10010" OR instruction(31 DOWNTO 27) = "10011" OR instruction(31 DOWNTO 27) = "10100" THEN
                instruction(15 DOWNTO 0) <= addressing_instruction(to_integer(unsigned((target))) + 1);
                inst_type <= '1';
            END IF;
        ELSIF read_instruction = '1' THEN
            instruction <= addressing_instruction(to_integer(unsigned((pc)))) & X"0000";
            inst_type <= '0';

            IF instruction(31 DOWNTO 27) = "01100" OR instruction(31 DOWNTO 27) = "10010" OR instruction(31 DOWNTO 27) = "10011" OR instruction(31 DOWNTO 27) = "10100" THEN
                instruction(15 DOWNTO 0) <= addressing_instruction(to_integer(unsigned((pc))) + 1);
                inst_type <= '1';
            END IF;
        END IF;
    END PROCESS;
END INSTRUCTION_MEMORY1;