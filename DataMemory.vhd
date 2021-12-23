LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY DATA_MEMORY IS
    GENERIC (n : INTEGER := 16);
    PORT (
        clk : IN STD_LOGIC;
        my_address : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        data : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        write_mem,mem_Read : IN STD_LOGIC;
        write_back : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE DATA_MEMORY1 OF DATA_MEMORY IS

    COMPONENT RAM IS
        GENERIC (n : INTEGER := 16);
        PORT (
            clk, write_mem,mem_Read : IN STD_LOGIC;
            data_in : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            address : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL memRead : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    SIGNAL address : STD_LOGIC_VECTOR(19 DOWNTO 0);
BEGIN
    address(19 DOWNTO 16) <= (OTHERS => '0');
    address(15 DOWNTO 0) <= my_address;
    dataMem : RAM GENERIC MAP(16) PORT MAP(clk, write_mem,mem_Read, data, address, memRead);
    write_back <= data;
END DATA_MEMORY1;