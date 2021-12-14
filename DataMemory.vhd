LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY DATA_MEMORY IS
    GENERIC (n : INTEGER := 16);
    PORT (
        clk : IN std_logic;
        address: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        data: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        write_mem: IN std_logic;
        write_back: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE DATA_MEMORY1 OF DATA_MEMORY IS
    
    component RAM is
    Generic ( n : integer := 16);
    port( 
        clk,write_mem : in std_logic;
        data_in : in std_logic_vector(n-1 downto 0);
        address : in std_logic_vector(31 downto 0);
        data_out : out std_logic_vector(n-1 downto 0)    
    );
   end component;
    signal memRead:std_logic_vector(n-1 downto 0);
    signal address:std_logic_vector(31 downto 0);

   
BEGIN
    dataMem: RAM generic map(16) port map(clk,write_mem,data,address,memRead);
    PROCESS(clk) IS 
        BEGIN
        IF rising_edge(clk) THEN 
        
            write_back <= data;
        
        END IF;
    END PROCESS;
            
    
END DATA_MEMORY1;

