LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY processor IS
    GENERIC (n : INTEGER := 32);
    PORT (
        rst, clk : IN STD_LOGIC;
        IN_PORT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        OUT_PORT : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
    );

END processor;

ARCHITECTURE processor_arch OF processor IS

    --------------------------- Buffer component ---------------------------
    COMPONENT buffer_component IS
        GENERIC (n : INTEGER := 16);
        PORT (
            clk, rst : IN STD_LOGIC;
            reg_in : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            reg_out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
        );

    END COMPONENT;

    --------------------------- Fetching component ---------------------------

    COMPONENT fetch_stage IS
        PORT (
            rst, clk, pc_write, instType : IN STD_LOGIC;
            in_port : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            IF_ID_BUFFER : OUT STD_LOGIC_VECTOR(80 DOWNTO 0)
        );

    END COMPONENT;

    --------------------------- Decoding component ---------------------------

    COMPONENT decode_stage IS
        GENERIC (n : INTEGER := 32);
        PORT (
            rst, clk : IN STD_LOGIC;
            -- IN_PORT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            WB : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            IF_ID_BUFFER : IN STD_LOGIC_VECTOR(80 DOWNTO 0);
            pc_en : OUT STD_LOGIC;
            ID_IE_BUFFER : OUT STD_LOGIC_VECTOR(122 DOWNTO 0)
        );

    END COMPONENT;

    --------------------------- Execution component ---------------------------

    COMPONENT EX_STAGE IS
        GENERIC (n : INTEGER := 16);
        PORT (
            ID_IE_BUFFER : IN STD_LOGIC_VECTOR (122 DOWNTO 0);
            IE_IM_BUFFER : OUT STD_LOGIC_VECTOR (75 DOWNTO 0);
            Rd_M_address, Rd_W_address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            Rd_M_data, Rd_W_data : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            clk, rst, WB_M, WB_W : IN STD_LOGIC
        );

    END COMPONENT;

    --------------------------- Memory component ---------------------------
    COMPONENT MEMORY_STAGE IS
        GENERIC (n : INTEGER := 16);
        PORT (
            IE_IM_BUFFER : IN STD_LOGIC_VECTOR (75 DOWNTO 0);
            clk : IN STD_LOGIC;
            IM_IW_BUFFER : OUT STD_LOGIC_VECTOR (52 DOWNTO 0)
        );
    END COMPONENT;

    --------------------------- Writing component ---------------------------
    COMPONENT WB_STAGE IS
        GENERIC (n : INTEGER := 16);
        PORT (
            clk : IN STD_LOGIC;
            IM_IW_BUFFER : IN STD_LOGIC_VECTOR (52 DOWNTO 0);
            wb_data, Rd_data : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            Rd_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            WB : OUT STD_LOGIC

        );
    END COMPONENT;
    --------------------------- SIGNALS -----------------------------------
    SIGNAL pc_write : STD_LOGIC;
    SIGNAL IF_ID_BUFFER_FROM_FETCHING, IF_ID_BUFFER_TO_DECODING : STD_LOGIC_VECTOR(80 DOWNTO 0);
    SIGNAL ID_IE_FROM_DECODING, ID_IE_TO_EXECUTION : STD_LOGIC_VECTOR(122 DOWNTO 0);
    SIGNAL IE_IM_FROM_EXECUTION, IE_IM_TO_MEMORY : STD_LOGIC_VECTOR(75 DOWNTO 0);
    SIGNAL IM_IW_FROM_MEMORY, IM_IW_TO_WB : STD_LOGIC_VECTOR(52 DOWNTO 0);

    SIGNAL wb_data, Rd_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Rd_address : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL WB : STD_LOGIC;
    ------------------------------------------------------------------------
BEGIN
    --------------------------- Fetching stage ---------------------------
    -- pc_write <= '0';
    FETCHING : fetch_stage PORT MAP(rst, clk, pc_write, '0', IN_PORT, IF_ID_BUFFER_FROM_FETCHING);

    --------------------------- Decoding stage ---------------------------
    IF_ID_BUFFER : buffer_component GENERIC MAP(n => 81) PORT MAP(clk, rst, IF_ID_BUFFER_FROM_FETCHING, IF_ID_BUFFER_TO_DECODING);
    DECODING : decode_stage GENERIC MAP(n => 16) PORT MAP(rst, clk, wb_data, IF_ID_BUFFER_TO_DECODING, pc_write, ID_IE_FROM_DECODING);

    --------------------------- Execution stage ---------------------------
    ID_IE_BUFFER : buffer_component GENERIC MAP(n => 123) PORT MAP(clk, rst, ID_IE_FROM_DECODING, ID_IE_TO_EXECUTION);
    EXECUTION : EX_STAGE GENERIC MAP(n => 16) PORT MAP(ID_IE_TO_EXECUTION, IE_IM_FROM_EXECUTION, "111", "111", "0000000000000000", "0000000000000000", clk, rst, '0', '0');

    --------------------------- Memory stage ---------------------------
    IE_IM_BUFFER : buffer_component GENERIC MAP(n => 76) PORT MAP(clk, rst, IE_IM_FROM_EXECUTION, IE_IM_TO_MEMORY);
    MEMORY : MEMORY_STAGE GENERIC MAP(n => 16) PORT MAP(IE_IM_TO_MEMORY, clk, IM_IW_FROM_MEMORY);

    --------------------------- Writing stage ---------------------------
    IM_IW_BUFFER : buffer_component GENERIC MAP(n => 53) PORT MAP(clk, rst, IM_IW_FROM_MEMORY, IM_IW_TO_WB);
    WRITE_BACK : WB_STAGE GENERIC MAP(n => 16) PORT MAP(clk, IM_IW_TO_WB, wb_data, Rd_data, Rd_address, WB);
END processor_arch;