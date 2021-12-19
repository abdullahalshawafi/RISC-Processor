LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY fetch_stage IS
    GENERIC (n : INTEGER := 32);
    PORT (
        rst, clk, instType : IN STD_LOGIC;
        IF_ID_BUFFER : OUT STD_LOGIC_VECTOR(64 DOWNTO 0)
    );

END fetch_stage;

ARCHITECTURE fetch_stage_arch OF fetch_stage IS

    COMPONENT PC IS
        PORT (
            rst, clk, en : IN STD_LOGIC;
            current_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT INSTRUCTION_MEMORY IS
        GENERIC (n : INTEGER := 16);
        PORT (
            clk : IN STD_LOGIC;
            pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            read_instruction : IN STD_LOGIC;
            instruction : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL instr : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL pc_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN

    x : PC PORT MAP(rst, clk, '1', pc_out);
    y : INSTRUCTION_MEMORY PORT MAP(clk, pc_out, '1', instr);

    PROCESS (rst, clk)
    BEGIN
        IF (rst = '1') THEN
            IF_ID_BUFFER <= (OTHERS => '0');
        ELSIF (rising_edge(clk)) THEN
            IF_ID_BUFFER <= (OTHERS => '0');
            IF_ID_BUFFER(64 DOWNTO 17) <= pc_out & instr;
        END IF;
    END PROCESS;

END fetch_stage_arch;