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
        Rs_address_FOR_HDU, Rt_address_FOR_HDU, Rd_address_FOR_HDU : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Mem_read_HDU : IN STD_LOGIC;
        pc_en, inst_type : OUT STD_LOGIC;
        ID_IE_BUFFER : OUT STD_LOGIC_VECTOR(131 DOWNTO 0)
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

    -------------------------------- MUX ----------------------------------
    COMPONENT MUX2 IS
        GENERIC (n : INTEGER := 16);
        PORT (
            sel : IN STD_LOGIC;
            in1, in2 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            my_out : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));
    END COMPONENT;

    --------------------------------- HDU ---------------------------------
    COMPONENT HDU IS
        PORT (
            Rs_address, Rt_address, Rd_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Rs_en, Rt_en, Mem_read, flush : IN STD_LOGIC;
            stall_pipe : OUT STD_LOGIC
        );

    END COMPONENT;

    ---------------------------------------------------------------------------------------------------------------------------------------

    SIGNAL Rs_address, Rt_address, Rd_address : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Wd, Rs_data, Rt_data : STD_LOGIC_VECTOR(15 DOWNTO 0);

    ---------------------- CONTROL UNIT SIGNALS ---------------------------------------------------------------------------------------------
    SIGNAL set_flush, pc_write, flush, set_carry, branch, alu_src, Rs_en, Rt_en, mem_read, mem_write, interrupt_en, stack, load, reg_write, in_en, out_en : STD_LOGIC;
    SIGNAL instType : STD_LOGIC;
    SIGNAL alu_op, flag_en, stack_op : STD_LOGIC_VECTOR(2 DOWNTO 0);

    ------------------------The final signals--> Flushed or not ----------------------------------------
    SIGNAL pc_write_final, flush_final, set_carry_final, branch_final, alu_src_final, Rs_en_final, Rt_en_final, mem_read_final, mem_write_final, interrupt_en_final, stack_final, load_final, reg_write_final, in_en_final, out_en_final : STD_LOGIC;
    SIGNAL inst_type_final : STD_LOGIC;
    SIGNAL alu_op_final, flag_en_final, stack_op_final : STD_LOGIC_VECTOR(2 DOWNTO 0);

    -----------------------------------------------------------------------------------------------------
    SIGNAL op_code : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL CONTROL_SIGNALS, FLUSHED_SIGNALS, FINAL_SIGNALS : STD_LOGIC_VECTOR(24 DOWNTO 0);

    ----------------------------- HDU SIGNALS --------------------------------------------------------------------------------------------------------------
    SIGNAL stall_pipe : STD_LOGIC;
    ------------------------------------------------------------------------------------------------------------------------------------------
BEGIN

    Rs_address <= IF_ID_BUFFER(58 DOWNTO 56);
    Rt_address <= IF_ID_BUFFER(55 DOWNTO 53);
    Rd_address <= IF_ID_BUFFER(52 DOWNTO 50);
    instType <= IF_ID_BUFFER(64);
    op_code <= IF_ID_BUFFER(63 DOWNTO 59);
    ------- 49:34 immediate value 
    ------- 2 extra bits
    -------------------------------------------------------------------------------------------------------------------------------

    CU : CONTROL_UNIT PORT MAP('0', op_code, pc_write, instType, flush, set_carry, branch, alu_src, Rs_en, Rt_en, mem_read, mem_write, interrupt_en, stack, load, reg_write, in_en, out_en, alu_op, flag_en, stack_op);
    ----------------------------------------------------------------------------------------------------------------------------------

    Rx : register_file PORT MAP(clk, rst, WB_signal, Rs_address, Rt_address, WB_address, WB_data, Rs_data, Rt_data);
    ----------------------------------------------------------------------------------------------------------------------------------

    HDU_result : HDU PORT MAP(Rs_address_FOR_HDU, Rt_address_FOR_HDU, Rd_address_FOR_HDU, Rs_en, Rt_en, Mem_read_HDU, flush, stall_pipe);

    FLUSHED_SIGNALS <= (OTHERS => '0');

    CONTROL_SIGNALS <= pc_write & instType & flush & set_carry
        & branch & alu_src & Rs_en & Rt_en &
        mem_read & mem_write & interrupt_en &
        stack & load & reg_write & in_en & out_en
        & alu_op & flag_en & stack_op;

    FLUSH_MUX : MUX2 GENERIC MAP(n => 25) PORT MAP(stall_pipe, CONTROL_SIGNALS, FLUSHED_SIGNALS, FINAL_SIGNALS);

    --------------------------- Final control signals -----------------------------------------------------------
    pc_write_final <= FINAL_SIGNALS(24);
    inst_type_final <= FINAL_SIGNALS(23);
    flush_final <= FINAL_SIGNALS(22);
    set_carry_final <= FINAL_SIGNALS(21);
    branch_final <= FINAL_SIGNALS(20);
    alu_src_final <= FINAL_SIGNALS(19);
    Rs_en_final <= FINAL_SIGNALS(18);
    Rt_en_final <= FINAL_SIGNALS(17);
    mem_read_final <= FINAL_SIGNALS(16);
    mem_write_final <= FINAL_SIGNALS(15);
    interrupt_en_final <= FINAL_SIGNALS(14);
    stack_final <= FINAL_SIGNALS(13);
    load_final <= FINAL_SIGNALS(12);
    reg_write_final <= FINAL_SIGNALS(11);
    in_en_final <= FINAL_SIGNALS(10);
    out_en_final <= FINAL_SIGNALS(9);
    alu_op_final <= FINAL_SIGNALS(8 DOWNTO 6);
    flag_en_final <= FINAL_SIGNALS(5 DOWNTO 3);
    stack_op_final <= FINAL_SIGNALS(2 DOWNTO 0);

    -------------------------------------------------------------------------------------------------------------------------------------

    ID_IE_BUFFER(130 DOWNTO 124) <= flush_final & stack_final & stack_op_final & mem_read_final & mem_write_final;
    ID_IE_BUFFER(123) <= out_en_final;
    ID_IE_BUFFER(122 DOWNTO 107) <= IF_ID_BUFFER(80 DOWNTO 65); -- INPUT PORT 
    ID_IE_BUFFER(106 DOWNTO 96) <= in_en_final & load_final & reg_write_final & alu_op_final & alu_src_final & flag_en_final & set_carry_final;
    ID_IE_BUFFER(95 DOWNTO 64) <= IF_ID_BUFFER(49 DOWNTO 34) & op_code & Rs_address & Rt_address & Rd_address & "00";
    ID_IE_BUFFER(63 DOWNTO 48) <= Rt_data;
    ID_IE_BUFFER(47 DOWNTO 32) <= Rs_data;
    ID_IE_BUFFER(31 DOWNTO 0) <= IF_ID_BUFFER(31 DOWNTO 0); --pc+1
    -----------------------------------------------------------------
    pc_en <= pc_write_final;
    inst_type <= inst_type_final;
    -------------------------------------------------------------------
END DECODING_STAGE_arch;