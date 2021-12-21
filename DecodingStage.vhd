LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY decode_stage IS
    GENERIC (n : INTEGER := 32);
    PORT (
        rst, clk : IN STD_LOGIC;
        IN_PORT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IF_ID_BUFFER : IN STD_LOGIC_VECTOR(62 DOWNTO 0);
        ID_IE_BUFFER : OUT STD_LOGIC_VECTOR(104 DOWNTO 0)
    );

END decode_stage;

ARCHITECTURE decode_stage_arch OF decode_stage IS

    COMPONENT register_file IS
        PORT (
            clk, rst : IN STD_LOGIC;
            reg_write : IN STD_LOGIC;
            Rs_address, Rt_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Rd_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Wd : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Rs_data, Rt_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );

    END COMPONENT;

    -- in_en & reg_write will be taken from control unit 
    SIGNAL in_en, reg_write, inst_type : STD_LOGIC;
    SIGNAL Rs_address, Rt_address, Rd_address : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Wd, Rs_data, Rt_data : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    -- PC+1 <=IF_ID_BUFFER(31 DOWNTO 0)
    -- opcode <= IF_ID_BUFFER(32 downto 36)
    Rs_address <= IF_ID_BUFFER(39 DOWNTO 37);
    Rt_address <= IF_ID_BUFFER(42 DOWNTO 40);
    Rd_address <= IF_ID_BUFFER(45 DOWNTO 43);
    ------- 46:61 immediate value 
    inst_type <= IF_ID_BUFFER(62);
    -- in_en <= IF_ID_BUFFER(1);
    -- reg_write <= IF_ID_BUFFER(0);

    -----------------------------------------------------------------
    Wd <= IN_PORT WHEN (in_en = '1'); --replace it with a mux 

    -----------------------------------------------------------------

    Rx : register_file PORT MAP(clk, rst, reg_write, Rs_address, Rt_address, Rd_address, Wd, Rs_data, Rt_data);

    ------------------- ----------------------------------------------
    ID_IE_BUFFER(103 DOWNTO 96) <= "01100000";
    ID_IE_BUFFER(95 DOWNTO 64) <= (OTHERS => '0');
    ID_IE_BUFFER(63 DOWNTO 48) <= Rt_data;
    ID_IE_BUFFER(47 DOWNTO 32) <= Rs_data;
    ID_IE_BUFFER(31 DOWNTO 0) <= IF_ID_BUFFER(31 DOWNTO 0);
    -- ID_IE_BUFFER[96 SETC ,  97,98,99 FlagEn znc , 100 AluSrc , 101:103 AluOP i will assume for now it is 3 bits] 
    -- ID_IE_BUFFER(64:95) instruction 32 bit => 80:95 imm. value

END decode_stage_arch;