
--________________________________________________________________
--Exexcution stage
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- ###### NOTES :
-- ?? 12 signal bs kam bit?  CSs + PC + Rs & Rt data + instruction 32 bit
-- ID_IE_BUFFER[0:31] PC+1
-- ID_IE_BUFFER[32:47] Rs data
-- ID_IE_BUFFER[48:63] Rt data
-- ID_IE_BUFFER[64:95] instruction 32 bit => 80:95 imm. value
-- 79:64 inst=>> 79:75 op code, 74:72 Rs, 71:69 Rt, 68:66 Rd
-- ID_IE_BUFFER[96 SETC ,  97,98,99 FlagEn , 100 AluSrc , 101:103 AluOP ]
-- 105:load,  104:WB     106:inEn ,122:107 in port,  123:out_en

ENTITY EX_STAGE IS
    GENERIC (n : INTEGER := 16);
    PORT (

        ID_IE_BUFFER : IN STD_LOGIC_VECTOR (133 DOWNTO 0);
        IE_IM_BUFFER : OUT STD_LOGIC_VECTOR (76 DOWNTO 0);
        Rd_M_address, Rd_W_address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        Rd_M_data, Rd_W_data : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        clk, rst, WB_M, WB_W : IN STD_LOGIC;
        will_branch : OUT STD_LOGIC;
        target : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        exception : IN STD_LOGIC;
        int_index : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        int_en : OUT STD_LOGIC;
        LUC : IN STD_LOGIC
    );

END EX_STAGE;

ARCHITECTURE struct OF EX_STAGE IS

    COMPONENT ALU IS

        PORT (
            Rs, Rt : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            AluOP : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            Rd : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            C, Ne, Z : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT MUX2 IS

        PORT (
            sel : IN STD_LOGIC;
            in1, in2 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            my_out : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));
    END COMPONENT;

    COMPONENT MUX4 IS

        GENERIC (n : INTEGER := 16);
        PORT (
            sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            in1, in2, in3, in4 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            my_out : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));

    END COMPONENT;

    COMPONENT FLAG_REG IS
        PORT (
            clk, rst : IN STD_LOGIC;
            en_z, en_n, en_c, Z, N, C : IN STD_LOGIC;
            Z_out, N_out, C_out : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT FLAG_MUX IS
        PORT (
            sel : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            Z1, N1, C1, Z2, N2, C2 : IN STD_LOGIC;
            Z, N, C : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT R_FLAG_REG IS
        PORT (
            clk, rst : IN STD_LOGIC;
            Z, N, C : IN STD_LOGIC;
            en : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            Z_out, N_out, C_out : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT FU IS
        PORT (
            Rs, Rt, Rd_M, Rd_W : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            WB_M, WB_W : IN STD_LOGIC;
            Rs_en, Rt_en : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
        );

    END COMPONENT;

    COMPONENT BRANCH_MUX IS
        PORT (
            sel : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            z, n, c : IN STD_LOGIC;
            my_out : OUT STD_LOGIC;
            Z_reset, N_reset, C_reset : OUT STD_LOGIC
        );
    END COMPONENT;

    -- #### SIGNALS
    SIGNAL Z, Ne, C, Z0, N0, C0, Cfinal, res_Z, res_N, res_C, latest_Z, latest_N, latest_C, latest2_Z, latest2_N, latest2_C : STD_LOGIC := '0';
    SIGNAL alu_src2, alu_result_temp, alu_result_temp2, alu_result_final, Rs_data, Rt_data, Rs_final, Rt_final, zeroVector, in_port, imm_value, sign_extend : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    SIGNAL alu_op, Rd_address, Rs_address, Rt_address : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL alusrc, setc, inEn, reg_write, branch_signal, jump_signal, Z_en, N_en, C_en, call_signal,
    int_signal, Z_reset, N_reset, C_reset, branch_int : STD_LOGIC;
    SIGNAL Rs_en, Rt_en : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL res_flag_en : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL zeroVector32 : STD_LOGIC_VECTOR (31 DOWNTO 0);
BEGIN

    ------------------------------ signal <= input buffer
    zeroVector <= (OTHERS => '0');
    zeroVector32 <= (OTHERS => '0');
    in_port <= ID_IE_BUFFER(122 DOWNTO 107);
    inEn <= ID_IE_BUFFER(106);
    Cfinal <= ID_IE_BUFFER(96) OR C0;
    Rt_data <= ID_IE_BUFFER(63 DOWNTO 48);
    Rs_data <= ID_IE_BUFFER(47 DOWNTO 32);
    Rd_address <= ID_IE_BUFFER(68 DOWNTO 66);
    Rs_address <= ID_IE_BUFFER(74 DOWNTO 72);
    Rt_address <= ID_IE_BUFFER(71 DOWNTO 69);
    imm_value <= ID_IE_BUFFER(95 DOWNTO 80);
    branch_signal <= ID_IE_BUFFER(131);
    res_flag_en <= ID_IE_BUFFER(129 DOWNTO 126);
    int_index <= ID_IE_BUFFER(74 DOWNTO 73);
    int_en <= ID_IE_BUFFER(132);
    -- exception handling
    alu_op <= ID_IE_BUFFER(103 DOWNTO 101) WHEN exception = '0'
        ELSE
        "000";
    alusrc <= ID_IE_BUFFER(100);
    Z_en <= ID_IE_BUFFER(99) WHEN exception = '0'
        ELSE
        '0';
    N_en <= ID_IE_BUFFER(98) WHEN exception = '0'
        ELSE
        '0';
    C_en <= ID_IE_BUFFER(97) WHEN exception = '0'
        ELSE
        '0';

    --------------------------------- logic :
    FU_Call : FU PORT MAP(Rs_address, Rt_address, Rd_M_address, Rd_W_address, WB_M, WB_W, Rs_en, Rt_en);

    Rs_Mux : MUX4 PORT MAP(Rs_en, Rs_data, Rd_M_data, Rd_W_data, zeroVector, Rs_final);
    Rt_Mux : MUX4 PORT MAP(Rt_en, Rt_data, Rd_M_data, Rd_W_data, zeroVector, alu_src2);

    imm_src_mux : MUX2 PORT MAP(alusrc, alu_src2, imm_value, Rt_final);
    in_alu_result : MUX2 PORT MAP(inEn, alu_result_temp, in_port, alu_result_temp2);

    Alu_unit : ALU PORT MAP(Rs_final, Rt_final, alu_op, alu_result_temp, C0, N0, Z0);

    --setting_flag : FLAG_REG PORT MAP(clk, rst, Z_en, N_en, C_en, Z0, N0, Cfinal, Z, Ne, C);

    -- ldm 
    alu_result_final <= imm_value WHEN alu_op = "111"
        ELSE
        alu_result_temp2;
    -- JUMP OR NOT ACCCORDING TO FLAGS
    branch : BRANCH_MUX PORT MAP(
        ID_IE_BUFFER(77 DOWNTO 75), Z, Ne, C, jump_signal
        , Z_reset, N_reset, C_reset);
    -- call 1011 signal = 1
    call_signal <= '1' WHEN res_flag_en = "1011"
        ELSE
        '0';
    int_signal <= '1' WHEN res_flag_en = "1101"
        ELSE
        '0';
    branch_int <= branch_signal AND (jump_signal OR call_signal OR int_signal);
    will_branch <= branch_int WHEN ID_IE_BUFFER(133) = '0'
        ELSE
        '1';
    sign_extend <= (OTHERS => Rs_final(15));
    target <= sign_extend & Rs_final;
    -- WHEN LUC = '0'
    -- ELSE
    -- zeroVector32;
    -- INT  save flags:
    --reserving_flags:  R_FLAG_REG PORT MAP(clk, rst,latest_Z,latest_N,latest_C,res_flag_en,res_Z,res_N,res_C );
    reserving_flags : R_FLAG_REG PORT MAP(clk, rst, Z, Ne, Cfinal, res_flag_en, res_Z, res_N, res_C);
    -- RTI restore Flags
    restoring_flags : FLAG_MUX PORT MAP(res_flag_en, res_Z, res_N, res_C, Z0, N0, Cfinal, latest_Z, latest_N, latest_C);
    -- resetting flags if a jump is taken
    latest2_Z <= latest_Z WHEN Z_reset = '0'
        ELSE
        '0';
    latest2_N <= latest_N WHEN N_reset = '0'
        ELSE
        '0';
    latest2_C <= latest_C WHEN C_reset = '0'
        ELSE
        '0';
    -- Setting flags in flag register Z Ne C
    setting_flag : FLAG_REG PORT MAP(clk, rst, Z_en, N_en, C_en, latest2_Z, latest2_N, latest2_C, Z, Ne, C);

    --------------------------------- output buffer <= signals
    -- PC+1
    IE_IM_BUFFER(31 DOWNTO 0) <= ID_IE_BUFFER(31 DOWNTO 0);
    IE_IM_BUFFER(47 DOWNTO 32) <= alu_result_final;
    -- STORE HANDLING
    IE_IM_BUFFER(63 DOWNTO 48) <= alu_src2 WHEN (ID_IE_BUFFER(124) = '1' AND ID_IE_BUFFER(129) = '0')
ELSE
    Rs_final;
    -- Rd address
    IE_IM_BUFFER(66 DOWNTO 64) <= Rd_address;
    -- control signals 
    -- load , wb
    IE_IM_BUFFER(75 DOWNTO 74) <= ID_IE_BUFFER(105) & ID_IE_BUFFER(104) WHEN (exception = '0' OR branch_int = '1')
ELSE
    "00";
    --flush & stack & stack_op &  mem_read& mem_write
    IE_IM_BUFFER(73 DOWNTO 67) <= ID_IE_BUFFER(130 DOWNTO 124) WHEN (exception = '0' OR branch_int = '1')
ELSE
    "0000000";

    -- Out Enable
    IE_IM_BUFFER(76) <= ID_IE_BUFFER(123) WHEN (exception = '0' OR branch_int = '1')
ELSE
    '0';

END struct;