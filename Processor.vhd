LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY processor IS
    GENERIC (n : INTEGER := 32);
    PORT (
        rst, clk : IN STD_LOGIC;
        IN_PORT : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
    );

END processor;

ARCHITECTURE processor_arch OF processor IS

    --------------------------- Buffer component ---------------------------
    COMPONENT buffer_component IS
        PORT (
            clk, rst : IN STD_LOGIC;
            reg_in : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            reg_out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
        );

    END COMPONENT;

    --------------------------- Fetching component ---------------------------

    --------------------------- Decoding component ---------------------------

    COMPONENT decode_stage IS
        GENERIC (n : INTEGER := 32);
        PORT (
            rst, clk : IN STD_LOGIC;
            IN_PORT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            IF_ID_BUFFER : IN STD_LOGIC_VECTOR(62 DOWNTO 0);
            ID_IE_BUFFER : OUT STD_LOGIC_VECTOR(104 DOWNTO 0)
        );

    END COMPONENT;

    --------------------------- Execution component ---------------------------

    COMPONENT EX_STAGE IS
        GENERIC (n : INTEGER := 16);
        PORT (
            ID_IE_BUFFER : IN STD_LOGIC_VECTOR (104 DOWNTO 0);
            IE_IM_BUFFER : OUT STD_LOGIC_VECTOR (74 DOWNTO 0)

        );
    END COMPONENT;

    --------------------------- Memory component ---------------------------

    --------------------------- Writing component ---------------------------
    --------------------------- SIGNALS -----------------------------------
    SIGNAL IF_ID_BUFFER_FROM_FETCHING, IF_ID_BUFFER_TO_DECODING : STD_LOGIC_VECTOR(62 DOWNTO 0);
    SIGNAL ID_IE_FROM_DECODING, ID_IE_TO_EXECUTION : STD_LOGIC_VECTOR(104 DOWNTO 0);
    SIGNAL IE_IM_FROM_EXECUTION, IE_IM_TO_MEMORY : STD_LOGIC_VECTOR(74 DOWNTO 0);
    SIGNAL IM_IW_FROM_MEMORY, IM_IW_TO_WB : STD_LOGIC_VECTOR(50 DOWNTO 0);
    ------------------------------------------------------------------------
BEGIN
    --------------------------- Fetching stage ---------------------------
    --------------------------- Decoding stage ---------------------------

    IF_ID_BUFFER : buffer_component GENERIC MAP(n => 63) PORT MAP(clk, rst, IF_ID_BUFFER_FROM_FETCHING, IF_ID_BUFFER_TO_DECODING);
    DECODING : decode_stage GENERIC MAP(n => 16) PORT MAP(rst, clk, IN_PORT, IF_ID_BUFFER_TO_DECODING, ID_IE_FROM_DECODING);

    --------------------------- Execution stage ---------------------------
    ID_IE_BUFFER : buffer_component GENERIC MAP(n => 105) PORT MAP(clk, rst, ID_IE_FROM_DECODING, ID_IE_TO_EXECUTION);
    EXECUTION : EX_STAGE GENERIC MAP(n => 16) PORT MAP(ID_IE_TO_EXECUTION, IE_IM_FROM_EXECUTION);

    --------------------------- Memory stage ---------------------------
    IE_IM_BUFFER : buffer_component GENERIC MAP(n => 75) PORT MAP(clk, rst, IE_IM_FROM_EXECUTION, IE_IM_TO_MEMORY);

    --------------------------- Writing stage ---------------------------
    IM_IW_BUFFER : buffer_component GENERIC MAP(n => 51) PORT MAP(clk, rst, IM_IW_FROM_MEMORY, IM_IW_TO_WB);

END processor_arch;