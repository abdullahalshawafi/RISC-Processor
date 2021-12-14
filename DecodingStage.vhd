LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY decode_stage IS
    GENERIC (n : INTEGER := 32);
    PORT (
        rst, clk : IN STD_LOGIC;
        IN_PORT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IF_ID_BUFFER : IN STD_LOGIC_VECTOR(66 DOWNTO 0);
        ID_IE_BUFFER : OUT STD_LOGIC_VECTOR(103 DOWNTO 0)
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

    SIGNAL in_en, reg_write, inst_type : STD_LOGIC;
    SIGNAL Rs_address, Rt_address, Rd_address : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Wd, Rs_data, Rt_data : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    Rd_address <= IF_ID_BUFFER(29 DOWNTO 27);
    Rs_address <= IF_ID_BUFFER(26 DOWNTO 24);
    Rt_address <= IF_ID_BUFFER(23 DOWNTO 21);
    inst_type <= IF_ID_BUFFER(2);
    in_en <= IF_ID_BUFFER(1);
    reg_write <= IF_ID_BUFFER(0);

    -----------------------------------------------------------------
    Wd <= IN_PORT WHEN (in_en = '1'); --replace it with a mux

    -----------------------------------------------------------------

    Rx : register_file PORT MAP(clk, rst, reg_write, Rs_address, Rt_address, Rd_address, Wd, Rs_data, Rt_data);

    -----------------------------------------------------------------
    -- ID_IE_BUFFER<= IF_ID_BUFFER(66 downto 35 ) & 

END decode_stage_arch;