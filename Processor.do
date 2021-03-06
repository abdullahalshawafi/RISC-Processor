vsim -gui work.processor

mem load -i instruction.mem /processor/FETCHING/y/addressing_instruction

add wave -position end  sim:/processor/rst
add wave -position end  sim:/processor/clk
#add wave -position end  sim:/processor/FETCHING/instr
#add wave -position end  sim:/processor/FETCHING/instr_en
#add wave -position end  sim:/processor/FETCHING/pc_out
add wave -position end  sim:/processor/FETCHING/pc_instruction
add wave -position end  sim:/processor/FETCHING/x/rst
add wave -position end  sim:/processor/FETCHING/x/current_pc
add wave -position end  sim:/processor/FETCHING/x/temp_pc
add wave -position end  sim:/processor/FETCHING/y/read_instruction
add wave -position end  sim:/processor/FETCHING/y/pc
add wave -position end  sim:/processor/FETCHING/y/will_branch
add wave -position end  sim:/processor/FETCHING/y/target
#add wave -position end  sim:/processor/DECODING/pc_en
#add wave -position end  sim:/processor/DECODING/set_carry
#add wave -position end  sim:/processor/DECODING/reg_write
#add wave -position end  sim:/processor/DECODING/Rs_address
#add wave -position end  sim:/processor/DECODING/Rs_data
#add wave -position end  sim:/processor/DECODING/WB_address
#add wave -position end  sim:/processor/DECODING/alu_op
#add wave -position end  sim:/processor/DECODING/alu_op_final
#add wave -position end  sim:/processor/DECODING/in_en
#add wave -position end  sim:/processor/DECODING/immediate_value
#add wave -position end  sim:/processor/DECODING/flag_en_final
add wave -position end  sim:/processor/DECODING/Rt_address
add wave -position end  sim:/processor/DECODING/Rt_data
#add wave -position end  sim:/processor/DECODING/Rx/Rt_address 
#add wave -position end  sim:/processor/DECODING/Rx/Rd_address
#add wave -position end  sim:/processor/DECODING/Rx/Wd 
#add wave -position end  sim:/processor/DECODING/Rx/Rt_data 
#add wave -position end  sim:/processor/DECODING/Rx/reg_out 
add wave -position end  sim:/processor/DECODING/Rx/en
add wave -position end sim:/processor/EXECUTION/ID_IE_BUFFER(133)
add wave -position end sim:/processor/EXECUTION/res_flag_en
add wave -position end sim:/processor/EXECUTION/res_Z
add wave -position end sim:/processor/EXECUTION/res_N
add wave -position end sim:/processor/EXECUTION/res_C
add wave -position end sim:/processor/EXECUTION/Z
add wave -position end sim:/processor/EXECUTION/Ne
add wave -position end sim:/processor/EXECUTION/C
add wave -position end sim:/processor/EXECUTION/latest_N
add wave -position end sim:/processor/EXECUTION/latest_Z
add wave -position end sim:/processor/EXECUTION/latest_C
add wave -position end sim:/processor/EXECUTION/Z0
add wave -position end sim:/processor/EXECUTION/N0
add wave -position end sim:/processor/EXECUTION/Cfinal
add wave -position end sim:/processor/EXECUTION/C0
add wave -position end sim:/processor/EXECUTION/alu_src2
add wave -position end  sim:/processor/EXECUTION/branch_signal
add wave -position end  sim:/processor/EXECUTION/jump_signal
add wave -position end  sim:/processor/EXECUTION/will_branch
add wave -position end  sim:/processor/EXECUTION/target
add wave -position end  sim:/processor/EXECUTION/Rt_final
add wave -position end  sim:/processor/EXECUTION/Rs_final
add wave -position end  sim:/processor/EXECUTION/Rt_data
add wave -position end  sim:/processor/EXECUTION/Rs_data
add wave -position end  sim:/processor/EXECUTION/Rs_address
#add wave -position end  sim:/processor/EXECUTION/Rs_en
#add wave -position end  sim:/processor/EXECUTION/Rt_en
#add wave -position end  sim:/processor/EXECUTION/Rd_W_data
#add wave -position end  sim:/processor/EXECUTION/Rd_M_address
#add wave -position end  sim:/processor/EXECUTION/Rd_M_data
#add wave -position end  sim:/processor/EXECUTION/Rd_W_address
#add wave -position end  sim:/processor/EXECUTION/alu_op
#add wave -position end  sim:/processor/EXECUTION/alusrc
#add wave -position end  sim:/processor/EXECUTION/alu_src2
#add wave -position end  sim:/processor/EXECUTION/alu_result_temp
add wave -position end  sim:/processor/EXECUTION/alu_result_final
#add wave -position end  sim:/processor/EXECUTION/alu_result_temp2
#add wave -position end  sim:/processor/EXECUTION/inEn
#add wave -position end  sim:/processor/EXECUTION/Cfinal
#add wave -position end  sim:/processor/EXECUTION/Z_en
#add wave -position end  sim:/processor/EXECUTION/N_en
#add wave -position end  sim:/processor/EXECUTION/C_en
add wave -position end  sim:/processor/MEMORY/Alu_result
add wave -position end  sim:/processor/MEMORY/load
add wave -position end  sim:/processor/MEMORY/Rs_data
add wave -position end  sim:/processor/MEMORY/stack_signal
add wave -position end  sim:/processor/MEMORY/mem_Write
add wave -position end  sim:/processor/MEMORY/Rd_address
add wave -position end  sim:/processor/MEMORY/stack_OP
#add wave -position end  sim:/processor/MEMORY/Exception
#add wave -position end  sim:/processor/MEMORY/EmptyStackException 
#add wave -position end  sim:/processor/MEMORY/InvalidAddressException
#add wave -position end  sim:/processor/MEMORY/dataMem/dataMem/address
add wave -position end  sim:/processor/MEMORY/current_SP
add wave -position end  sim:/processor/MEMORY/EPC_val
add wave -position end  sim:/processor/WRITE_BACK/wb_data
add wave -position end  sim:/processor/WRITE_BACK/Rd_address
add wave -position end  sim:/processor/WRITE_BACK/load_signal
#add wave -position end  sim:/processor/DECODING/CU/pc_write
#add wave -position end  sim:/processor/pc_write
#add wave -position end  sim:/processor/instType
add wave -position end  sim:/processor/IN_PORT
add wave -position end  sim:/processor/OUT_PORT
#add wave -position end  sim:/processor/Exception

force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100

# reset all
force -freeze sim:/processor/rst 1 0
force -freeze sim:/processor/IN_PORT X"0000" 0
run

force -freeze sim:/processor/rst 0 0
force -freeze sim:/processor/IN_PORT X"0030" 0
run
force -freeze sim:/processor/IN_PORT X"0050" 0
run
force -freeze sim:/processor/IN_PORT X"0100" 0
run
force -freeze sim:/processor/IN_PORT X"0300" 0
run