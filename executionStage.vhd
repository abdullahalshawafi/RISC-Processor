
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
-- ID_IE_BUFFER[96 SETC ,  97,98,99 FlagEn , 100 AluSrc , 101:103 AluOP i will assume for now it is 3 bits]
ENTITY EX_STAGE IS
    GENERIC (n : INTEGER := 16);
    PORT (
        ID_IE_BUFFER : IN STD_LOGIC_VECTOR (104 DOWNTO 0);
        IE_IM_BUFFER : OUT STD_LOGIC_VECTOR (74 DOWNTO 0)

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

    COMPONENT FLAG_REG IS
        PORT (
            en_z, en_n, en_c, Z, N, C : IN STD_LOGIC;
            Z_out, N_out, C_out : OUT STD_LOGIC);

    END COMPONENT;

    -- #### SIGNALS
    SIGNAL Z, Ne, C, Z0, N0, C0, Cfinal : STD_LOGIC;
    SIGNAL alu_src2, alu_result_temp : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    SIGNAL alu_op : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL alusrc, setc : STD_LOGIC;

BEGIN

    alu_op <= ID_IE_BUFFER(103 DOWNTO 101);
    alusrc <= ID_IE_BUFFER(100);
    fx1 : MUX2 PORT MAP(alusrc, ID_IE_BUFFER(63 DOWNTO 48), ID_IE_BUFFER(95 DOWNTO 80), alu_src2);

    fx2 : ALU PORT MAP(ID_IE_BUFFER(47 DOWNTO 32), alu_src2, alu_op, alu_result_temp, C0, N0, Z0);

    fx3 : FLAG_REG PORT MAP(ID_IE_BUFFER(97), ID_IE_BUFFER(98), ID_IE_BUFFER(99), Z0, N0, Cfinal, Z, Ne, C);

    Cfinal <= ID_IE_BUFFER(96) OR C0;
    -- PC+1
    IE_IM_BUFFER(31 DOWNTO 0) <= ID_IE_BUFFER(31 DOWNTO 0);
    IE_IM_BUFFER(47 DOWNTO 32) <= alu_result_temp;
    --Rs data
    IE_IM_BUFFER(63 DOWNTO 48) <= ID_IE_BUFFER(47 DOWNTO 32);
    -- Rd address
    IE_IM_BUFFER(66 DOWNTO 64) <= ID_IE_BUFFER(77 DOWNTO 75);

END struct;