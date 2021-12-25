LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY DECODING_STAGE IS
    GENERIC (n : INTEGER := 32);
    PORT (
        rst, clk : IN STD_LOGIC;
        WB_address : STD_LOGIC_VECTOR(2 DOWNTO 0);
        WB_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        WB_signal : IN STD_LOGIC;
        IF_ID_BUFFER : IN STD_LOGIC_VECTOR(80 DOWNTO 0);
        pc_en : OUT STD_LOGIC;
        ID_IE_BUFFER : OUT STD_LOGIC_VECTOR(123 DOWNTO 0)
    );

END DECODING_STAGE;

ARCHITECTURE DECODING_STAGE_arch OF DECODING_STAGE IS

    ---------------------------- Register file -----------------------------
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

    ------------------------- Control unit ----------------------------------
    COMPONENT CONTROL_UNIT IS
        PORT (
            set_flush : IN STD_LOGIC;
            op_code : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            pc_write, inst_type, flush : OUT STD_LOGIC;
            set_carry, branch, alu_src : OUT STD_LOGIC;
            Rs_en, Rt_en, mem_read : OUT STD_LOGIC;
            mem_write, interrupt_en : OUT STD_LOGIC;
            stack, load, reg_write, in_en, out_en : OUT STD_LOGIC;
            alu_op, flag_en, stack_op : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

    -----------------------------------------------------------------------

    SIGNAL Rs_address, Rt_address, Rd_address : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Wd, Rs_data, Rt_data : STD_LOGIC_VECTOR(15 DOWNTO 0);

    ---------------------- CONTROL UNIT SIGNALS ----------------------------
    SIGNAL set_flush, pc_write, flush, set_carry, branch, alu_src, Rs_en, Rt_en, mem_read, mem_write, interrupt_en, stack, load, reg_write, in_en, out_en : STD_LOGIC;
    SIGNAL inst_type : STD_LOGIC;
    SIGNAL alu_op, flag_en, stack_op : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL op_code : STD_LOGIC_VECTOR(4 DOWNTO 0);
    --------------------------------------------------------------------------
BEGIN

    Rs_address <= IF_ID_BUFFER(58 DOWNTO 56);
    Rt_address <= IF_ID_BUFFER(55 DOWNTO 53);
    Rd_address <= IF_ID_BUFFER(52 DOWNTO 50);
    inst_type <= IF_ID_BUFFER(64);
    op_code <= IF_ID_BUFFER(63 DOWNTO 59);
    ------- 49:34 immediate value 
    ------- 2 extra bits
    --------------------------------------------------------------
    CU : CONTROL_UNIT PORT MAP('0', op_code, pc_write, inst_type, flush, set_carry, branch, alu_src, Rs_en, Rt_en, mem_read, mem_write, interrupt_en, stack, load, reg_write, in_en, out_en, alu_op, flag_en, stack_op);
    -----------------------------------------------------------------
    Rx : register_file PORT MAP(clk, rst, WB_signal, Rs_address, Rt_address, WB_address, WB_data, Rs_data, Rt_data);
    -----------------------------------------------------------------
    ID_IE_BUFFER(123) <= out_en;
    ID_IE_BUFFER(122 DOWNTO 107) <= IF_ID_BUFFER(80 DOWNTO 65); -- INPUT PORT 
    ID_IE_BUFFER(106 DOWNTO 96) <= in_en & load & reg_write & alu_op & alu_src & flag_en & set_carry;
    ID_IE_BUFFER(95 DOWNTO 64) <= IF_ID_BUFFER(49 DOWNTO 34) & op_code & Rs_address & Rt_address & Rd_address & "00";
    ID_IE_BUFFER(63 DOWNTO 48) <= Rt_data;
    ID_IE_BUFFER(47 DOWNTO 32) <= Rs_data;
    ID_IE_BUFFER(31 DOWNTO 0) <= IF_ID_BUFFER(31 DOWNTO 0); --pc+1
    -----------------------------------------------------------------
    pc_en <= pc_write;
    -------------------------------------------------------------------
END DECODING_STAGE_arch;