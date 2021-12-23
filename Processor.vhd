LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY processor IS
    GENERIC (n : INTEGER := 32);
    PORT (
        rst, clk : IN STD_LOGIC;
        IN_PORT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        OUT_PORT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );

END processor;

ARCHITECTURE processor_arch OF processor IS

    --------------------------- Buffer component ---------------------------
    COMPONENT buffer_component IS
        GENERIC (n : INTEGER := 16);
        PORT (
            clk, rst, en : IN STD_LOGIC;
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
            WB_address : STD_LOGIC_VECTOR(2 DOWNTO 0);
            WB : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            IF_ID_BUFFER : IN STD_LOGIC_VECTOR(80 DOWNTO 0);
            pc_en : OUT STD_LOGIC;
            ID_IE_BUFFER : OUT STD_LOGIC_VECTOR(123 DOWNTO 0)
        );

    END COMPONENT;

    --------------------------- Execution component ---------------------------

    COMPONENT EX_STAGE IS
        GENERIC (n : INTEGER := 16);
        PORT (
            ID_IE_BUFFER : IN STD_LOGIC_VECTOR (123 DOWNTO 0);
            IE_IM_BUFFER : OUT STD_LOGIC_VECTOR (76 DOWNTO 0);
            Rd_M_address, Rd_W_address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            Rd_M_data, Rd_W_data : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            clk, rst, WB_M, WB_W : IN STD_LOGIC
        );

    END COMPONENT;

    --------------------------- Memory component ---------------------------
    COMPONENT MEMORY_STAGE IS
        GENERIC (n : INTEGER := 16);
        PORT (
            IE_IM_BUFFER : IN STD_LOGIC_VECTOR (76 DOWNTO 0);
            clk : IN STD_LOGIC;
            IM_IW_BUFFER : OUT STD_LOGIC_VECTOR (53 DOWNTO 0)
        );

    END COMPONENT;

    --------------------------- Writing component ---------------------------
    COMPONENT WB_STAGE IS
        GENERIC (n : INTEGER := 16);
        PORT (
            clk : IN STD_LOGIC;
            IM_IW_BUFFER : IN STD_LOGIC_VECTOR (53 DOWNTO 0);
            wb_data, Rd_data : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            Rd_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            WB, out_en : OUT STD_LOGIC
        );

    END COMPONENT;
    --------------------------- SIGNALS -----------------------------------
    SIGNAL pc_write : STD_LOGIC;
    SIGNAL IF_ID_BUFFER_FROM_FETCHING, IF_ID_BUFFER_TO_DECODING : STD_LOGIC_VECTOR(80 DOWNTO 0);
    SIGNAL ID_IE_FROM_DECODING, ID_IE_TO_EXECUTION : STD_LOGIC_VECTOR(123 DOWNTO 0);
    SIGNAL IE_IM_FROM_EXECUTION, IE_IM_TO_MEMORY : STD_LOGIC_VECTOR(76 DOWNTO 0);
    SIGNAL IM_IW_FROM_MEMORY, IM_IW_TO_WB : STD_LOGIC_VECTOR(53 DOWNTO 0);

    SIGNAL wb_data, Rd_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Rd_address : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL WB, out_en : STD_LOGIC;
    ------------------------------------------------------------------------
BEGIN
    --------------------------- Fetching Stage ---------------------------
    FETCHING : fetch_stage PORT MAP(rst, clk, pc_write, '0', IN_PORT, IF_ID_BUFFER_FROM_FETCHING);

    --------------------------- Decoding Stage ---------------------------
    IF_ID_BUFFER : buffer_component GENERIC MAP(n => 81) PORT MAP(clk, rst, '1', IF_ID_BUFFER_FROM_FETCHING, IF_ID_BUFFER_TO_DECODING);
    DECODING : decode_stage GENERIC MAP(n => 16) PORT MAP(rst, clk, Rd_address, wb_data, IF_ID_BUFFER_TO_DECODING, pc_write, ID_IE_FROM_DECODING);

    --------------------------- Execution Stage ---------------------------
    ID_IE_BUFFER : buffer_component GENERIC MAP(n => 124) PORT MAP(clk, rst, '1', ID_IE_FROM_DECODING, ID_IE_TO_EXECUTION);
    EXECUTION : EX_STAGE GENERIC MAP(n => 16) PORT MAP(ID_IE_TO_EXECUTION, IE_IM_FROM_EXECUTION, "111", "111", "0000000000000000", "0000000000000000", clk, rst, '0', '0');

    --------------------------- Memory Stage ---------------------------
    IE_IM_BUFFER : buffer_component GENERIC MAP(n => 77) PORT MAP(clk, rst, '1', IE_IM_FROM_EXECUTION, IE_IM_TO_MEMORY);
    MEMORY : MEMORY_STAGE GENERIC MAP(n => 16) PORT MAP(IE_IM_TO_MEMORY, clk, IM_IW_FROM_MEMORY);

    --------------------------- Writing Stage ---------------------------
    IM_IW_BUFFER : buffer_component GENERIC MAP(n => 54) PORT MAP(clk, rst, '1', IM_IW_FROM_MEMORY, IM_IW_TO_WB);
    WRITE_BACK : WB_STAGE GENERIC MAP(n => 16) PORT MAP(clk, IM_IW_TO_WB, wb_data, Rd_data, Rd_address, WB, out_en);

    --------------------------- OUTPUT PORT ---------------------------
    OUT_PORT_BUFFER : buffer_component GENERIC MAP(n => 16) PORT MAP(clk, rst, out_en, wb_data, OUT_PORT);
END processor_arch;