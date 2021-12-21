LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY register_file IS
    GENERIC (n : INTEGER := 32);
    PORT (
        clk, rst : IN STD_LOGIC;
        reg_write : IN STD_LOGIC;
        Rs_address, Rt_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rd_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Wd : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Rs_data, Rt_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );

END register_file;

ARCHITECTURE register_file_arch OF register_file IS

    COMPONENT register_component IS
        PORT (
            clk, rst, en : IN STD_LOGIC;
            reg_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            reg_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
        );

    END COMPONENT;

    TYPE reg_type IS ARRAY(0 TO 7) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL reg_out : reg_type;
    SIGNAL en : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    -- m7taga a-check 3l clock bs 
    -----------------------------------------------------------------

    en(0) <= reg_write WHEN (Rd_address = "000") ELSE
    '0';
    en(1) <= reg_write WHEN (Rd_address = "001") ELSE
    '0';
    en(2) <= reg_write WHEN (Rd_address = "010") ELSE
    '0';
    en(3) <= reg_write WHEN (Rd_address = "011") ELSE
    '0';
    en(4) <= reg_write WHEN (Rd_address = "100") ELSE
    '0';
    en(5) <= reg_write WHEN (Rd_address = "101") ELSE
    '0';
    en(6) <= reg_write WHEN (Rd_address = "110") ELSE
    '0';
    en(7) <= reg_write WHEN (Rd_address = "111") ELSE
    '0';

    -----------------------------------------------------------------

    loop1 : FOR i IN 0 TO (7) GENERATE
        rx : register_component GENERIC MAP(n => 16) PORT MAP(clk, rst, en(i), Wd, reg_out(i));
    END GENERATE;

    -----------------------------------------------------------------

    WITH Rs_address SELECT
        Rs_data <=
        reg_out(0) WHEN "000",
        reg_out(1) WHEN "001",
        reg_out(2) WHEN "010",
        reg_out(3) WHEN "011",
        reg_out(4) WHEN "100",
        reg_out(5) WHEN "101",
        reg_out(6) WHEN "110",
        reg_out(7) WHEN OTHERS;

    -----------------------------------------------------------------

    WITH Rt_address SELECT
        Rt_data <=
        reg_out(0) WHEN "000",
        reg_out(1) WHEN "001",
        reg_out(2) WHEN "010",
        reg_out(3) WHEN "011",
        reg_out(4) WHEN "100",
        reg_out(5) WHEN "101",
        reg_out(6) WHEN "110",
        reg_out(7) WHEN OTHERS;

    -----------------------------------------------------------------

END register_file_arch;