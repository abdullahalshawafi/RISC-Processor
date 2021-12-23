LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

--###### NOTES
-- IM_IW_BUFFER:in std_logic_vector (32 downto 0 );
-- read data 0:15
-- alu result 16 :31
-- Rd data 32:47
-- Rd address 48:50 
-- wb signal 51
-- load signal 52

ENTITY WB_STAGE IS
    GENERIC (n : INTEGER := 16);
    PORT (
        clk : IN STD_LOGIC;
        IM_IW_BUFFER : IN STD_LOGIC_VECTOR (52 DOWNTO 0);
        wb_data, Rd_data : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        Rd_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        WB : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE WB_STAGE_ARCH OF WB_STAGE IS

    COMPONENT MUX2 IS
        PORT (
            sel : IN STD_LOGIC;
            in1, in2 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            my_out : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );

    END COMPONENT;

    SIGNAL load_signal : STD_LOGIC;
    SIGNAL alu_result, read_data, wb_data_temp : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
BEGIN

    WB_MUX : MUX2 PORT MAP(load_signal, alu_result, read_data, wb_data_temp);

    load_signal <= IM_IW_BUFFER(52);
    alu_result <= IM_IW_BUFFER(31 DOWNTO 16);
    read_data <= IM_IW_BUFFER(15 DOWNTO 0);
    wb_data <= wb_data_temp;

    Rd_data <= IM_IW_BUFFER (47 DOWNTO 32);
    Rd_address <= IM_IW_BUFFER(50 DOWNTO 48);
    WB <= IM_IW_BUFFER(51);

END WB_STAGE_ARCH;