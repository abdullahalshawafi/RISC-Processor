LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY PROCESSOR IS
    GENERIC (n : INTEGER := 32);
    PORT (
        rst, clk : IN STD_LOGIC;
        IN_PORT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        OUT_PORT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );

END PROCESSOR;

ARCHITECTURE PROCESSOR OF PROCESSOR IS

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

    COMPONENT FETCH_STAGE IS
        PORT (
            rst, clk, pc_write : IN STD_LOGIC;
            in_port : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            PC_MODIFIED, target : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            CHANGE_PC, ex1, ex2, will_branch : IN STD_LOGIC;
            int_index : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            IF_ID_BUFFER : OUT STD_LOGIC_VECTOR(80 DOWNTO 0)
        );

    END COMPONENT;

    --------------------------- Decoding component ---------------------------

    COMPONENT DECODING_STAGE IS
        GENERIC (n : INTEGER := 32);
        PORT (
            rst, clk : IN STD_LOGIC;
            WB_address : STD_LOGIC_VECTOR(2 DOWNTO 0);
            WB_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            WB_signal : IN STD_LOGIC;
            IF_ID_BUFFER : IN STD_LOGIC_VECTOR(80 DOWNTO 0);
            Rs_address_FOR_HDU, Rt_address_FOR_HDU, Rd_address_FOR_HDU : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Mem_read_HDU : IN STD_LOGIC;
            exception : IN STD_LOGIC;
            branch_taken : IN STD_LOGIC;
            pc_en : OUT STD_LOGIC := '1';
            inst_type : OUT STD_LOGIC := '0';
            ID_IE_BUFFER : OUT STD_LOGIC_VECTOR(131 DOWNTO 0);
            final_flush : OUT STD_LOGIC
        );
    END COMPONENT;

    --------------------------- Execution component ---------------------------

    COMPONENT EX_STAGE IS
        GENERIC (n : INTEGER := 16);
        PORT (

            ID_IE_BUFFER : IN STD_LOGIC_VECTOR (131 DOWNTO 0);
            IE_IM_BUFFER : OUT STD_LOGIC_VECTOR (76 DOWNTO 0);
            Rd_M_address, Rd_W_address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            Rd_M_data, Rd_W_data : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            clk, rst, WB_M, WB_W : IN STD_LOGIC;
            will_branch : OUT STD_LOGIC;
            target : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            exception : IN STD_LOGIC
        );

    END COMPONENT;

    --------------------------- Memory component ---------------------------
    COMPONENT MEMORY_STAGE IS
        GENERIC (n : INTEGER := 16);
        PORT (
            IE_IM_BUFFER : IN STD_LOGIC_VECTOR (76 DOWNTO 0);
            clk, rst : IN STD_LOGIC;
            IM_IW_BUFFER : OUT STD_LOGIC_VECTOR (53 DOWNTO 0);
            PC_MODIFIED : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            CHANGE_PC, EmptyStackException, InvalidAddressException : OUT STD_LOGIC
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
    SIGNAL pc_write : STD_LOGIC := '1';
    SIGNAL instType : STD_LOGIC := '0';
    SIGNAL IF_ID_BUFFER_FROM_FETCHING, IF_ID_BUFFER_TO_DECODING : STD_LOGIC_VECTOR(80 DOWNTO 0);
    SIGNAL ID_IE_FROM_DECODING, ID_IE_TO_EXECUTION : STD_LOGIC_VECTOR(131 DOWNTO 0);
    SIGNAL IE_IM_FROM_EXECUTION, IE_IM_TO_MEMORY : STD_LOGIC_VECTOR(76 DOWNTO 0);
    SIGNAL IM_IW_FROM_MEMORY, IM_IW_TO_WB : STD_LOGIC_VECTOR(53 DOWNTO 0);
    SIGNAL PC_MODIFIED, TARGET : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL wb_data, Rd_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Rd_address : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL WB, out_en, CHANGE_PC, EmptyStack, InvalidAddress, Mem_flush, WILL_BRANCH, flush_CU : STD_LOGIC;
    SIGNAL Z_flag, N_flag, C_flag : STD_LOGIC;

    -------------------------- reset signals for buffers------------------
    SIGNAL reset_IF_ID, reset_ID_IE, reset_IE_IM : STD_LOGIC;
    ------------------------------------------------------------------------
BEGIN
    Mem_flush <= '1' WHEN (EmptyStack = '1' OR InvalidAddress = '1' OR CHANGE_PC = '1') ELSE
        '0';
    --------------------------- Fetching Stage ---------------------------
    FETCHING : FETCH_STAGE PORT MAP(rst, clk, pc_write, IN_PORT, PC_MODIFIED, TARGET, CHANGE_PC, EmptyStack, InvalidAddress, WILL_BRANCH, IF_ID_BUFFER_FROM_FETCHING);

    --------------------------- Decoding Stage ---------------------------
    reset_IF_ID <= '1' WHEN (flush_CU = '1')
        ELSE
        rst;

    IF_ID_BUFFER : buffer_component GENERIC MAP(n => 81) PORT MAP(clk, reset_IF_ID, '1', IF_ID_BUFFER_FROM_FETCHING, IF_ID_BUFFER_TO_DECODING);

    DECODING : DECODING_STAGE GENERIC MAP(n => 16) PORT MAP(rst, clk, Rd_address, wb_data, WB, IF_ID_BUFFER_TO_DECODING, IF_ID_BUFFER_TO_DECODING(58 DOWNTO 56), IF_ID_BUFFER_TO_DECODING(55 DOWNTO 53), ID_IE_TO_EXECUTION(68 DOWNTO 66), ID_IE_TO_EXECUTION(124), Mem_flush, WILL_BRANCH, pc_write, instType, ID_IE_FROM_DECODING, flush_CU);

    --------------------------- Execution Stage ---------------------------
    reset_ID_IE <= '1' WHEN (flush_CU = '1')
        ELSE
        rst;

    ID_IE_BUFFER : buffer_component GENERIC MAP(n => 132) PORT MAP(clk, reset_ID_IE, '1', ID_IE_FROM_DECODING, ID_IE_TO_EXECUTION);
    EXECUTION : EX_STAGE GENERIC MAP(n => 16) PORT MAP(ID_IE_TO_EXECUTION, IE_IM_FROM_EXECUTION, IE_IM_TO_MEMORY(66 DOWNTO 64), IM_IW_TO_WB(50 DOWNTO 48), IE_IM_TO_MEMORY(47 DOWNTO 32), wb_data, clk, rst, IE_IM_TO_MEMORY(74), WB, WILL_BRANCH, TARGET, Mem_flush);

    --------------------------- Memory Stage ---------------------------
    reset_IE_IM <= '1' WHEN (flush_CU = '1' AND WILL_BRANCH = '0')
        ELSE
        rst;
    IE_IM_BUFFER : buffer_component GENERIC MAP(n => 77) PORT MAP(clk, rst, '1', IE_IM_FROM_EXECUTION, IE_IM_TO_MEMORY);
    MEMORY : MEMORY_STAGE GENERIC MAP(n => 16) PORT MAP(IE_IM_TO_MEMORY, clk, rst, IM_IW_FROM_MEMORY, PC_MODIFIED, CHANGE_PC, EmptyStack, InvalidAddress);

    --------------------------- Writing Stage ---------------------------
    IM_IW_BUFFER : buffer_component GENERIC MAP(n => 54) PORT MAP(clk, rst, '1', IM_IW_FROM_MEMORY, IM_IW_TO_WB);
    WRITE_BACK : WB_STAGE GENERIC MAP(n => 16) PORT MAP(clk, IM_IW_TO_WB, wb_data, Rd_data, Rd_address, WB, out_en);

    --------------------------- OUTPUT PORT ---------------------------
    OUT_PORT_BUFFER : buffer_component GENERIC MAP(n => 16) PORT MAP(clk, rst, out_en, wb_data, OUT_PORT);
END PROCESSOR;