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
            reg_in : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            clk, rst : IN STD_LOGIC;
            reg_out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
        );

    END COMPONENT;

    TYPE reg_type IS ARRAY(0 TO 7) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL reg_in, reg_out, reg_out_withoutWB : reg_type;
    SIGNAL reg_out_withWB : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    loop1 : FOR i IN 0 TO (7) GENERATE
        rx : register_component GENERIC MAP(n => 16) PORT MAP(reg_in(i), clk, rst, reg_out_withoutWB(i));
    END GENERATE;

    reg_out_withWB <= Wd WHEN (reg_write = '1');

    reg_out(0) <= reg_out_withoutWB(0) WHEN (reg_write = '0')
ELSE
    reg_out_withWB WHEN (Rd_address = "000");

    reg_out(1) <= reg_out_withoutWB(1) WHEN (reg_write = '0')
ELSE
    reg_out_withWB WHEN (Rd_address = "001");

    reg_out(2) <= reg_out_withoutWB(2) WHEN (reg_write = '0')
ELSE
    reg_out_withWB WHEN (Rd_address = "010");

    reg_out(3) <= reg_out_withoutWB(3) WHEN (reg_write = '0')
ELSE
    reg_out_withWB WHEN (Rd_address = "011");

    reg_out(4) <= reg_out_withoutWB(4) WHEN (reg_write = '0')
ELSE
    reg_out_withWB WHEN (Rd_address = "100");

    reg_out(5) <= reg_out_withoutWB(5) WHEN (reg_write = '0')
ELSE
    reg_out_withWB WHEN (Rd_address = "101");

    reg_out(6) <= reg_out_withoutWB(6) WHEN (reg_write = '0')
ELSE
    reg_out_withWB WHEN (Rd_address = "110");

    reg_out(7) <= reg_out_withoutWB(7) WHEN (reg_write = '0')
ELSE
    reg_out_withWB WHEN (Rd_address = "111");

    
    Rs_data <= reg_out(0) WHEN (Rs_address = "000")
        ELSE
        reg_out(1) WHEN (Rs_address = "001")
        ELSE
        reg_out(2) WHEN (Rs_address = "010")
        ELSE
        reg_out(3) WHEN (Rs_address = "011")
        ELSE
        reg_out(4) WHEN (Rs_address = "100")
        ELSE
        reg_out(5) WHEN (Rs_address = "101")
        ELSE
        reg_out(6) WHEN (Rs_address = "110")
        ELSE
        reg_out(7);

    Rt_data <= reg_out(0) WHEN (Rt_address = "000")
        ELSE
        reg_out(1) WHEN (Rt_address = "001")
        ELSE
        reg_out(2) WHEN (Rt_address = "010")
        ELSE
        reg_out(3) WHEN (Rt_address = "011")
        ELSE
        reg_out(4) WHEN (Rt_address = "100")
        ELSE
        reg_out(5) WHEN (Rt_address = "101")
        ELSE
        reg_out(6) WHEN (Rt_address = "110")
        ELSE
        reg_out(7);
END register_file_arch;