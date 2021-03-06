vsim -gui work.processor

mem load -i instruction.mem /processor/FETCHING/y/addressing_instruction

add wave -position end  sim:/processor/rst
add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/FETCHING/pc_instruction
#add wave -position end  sim:/processor/FETCHING/will_branch
#add wave -position end  sim:/processor/FETCHING/pc_signal
#add wave -position end  sim:/processor/FETCHING/change_pc
#add wave -position end  sim:/processor/FETCHING/IF_ID_BUFFER
#add wave -position end  sim:/processor/Mem_flush
#add wave -position end  sim:/processor/WILL_BRANCH
add wave -position end  sim:/processor/DECODING/Rx/loop1(0)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(1)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(2)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(3)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(4)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(5)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(6)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(7)/rx/reg_out  
#add wave -position end  sim:/processor/DECODING/set_carry_final
#add wave -position end  sim:/processor/DECODING/set_flush
#add wave -position end  sim:/processor/DECODING/exception
#add wave -position end  sim:/processor/DECODING/branch_taken
#add wave -position end  sim:/processor/DECODING/branch_final
#add wave -position end  sim:/processor/EXECUTION/target
#add wave -position end  sim:/processor/EXECUTION/branch_signal
#add wave -position end  sim:/processor/EXECUTION/jump_signal
#add wave -position end  sim:/processor/EXECUTION/will_branch
add wave -position end  sim:/processor/EXECUTION/res_Z
add wave -position end  sim:/processor/EXECUTION/res_N
add wave -position end  sim:/processor/EXECUTION/res_C
add wave -position end  sim:/processor/EXECUTION/res_flag_en
add wave -position end  sim:/processor/EXECUTION/setting_flag/Z_out
add wave -position end  sim:/processor/EXECUTION/setting_flag/N_out
add wave -position end  sim:/processor/EXECUTION/setting_flag/C_out
#add wave -position end  sim:/processor/EXECUTION/latest_Z
#add wave -position end  sim:/processor/EXECUTION/latest_N
#add wave -position end  sim:/processor/EXECUTION/latest_C
#add wave -position end  sim:/processor/EXECUTION/latest2_Z
#add wave -position end  sim:/processor/EXECUTION/latest2_N
#add wave -position end  sim:/processor/EXECUTION/latest2_C
add wave -position end  sim:/processor/EXECUTION/Z_reset
add wave -position end  sim:/processor/EXECUTION/N_reset
add wave -position end  sim:/processor/EXECUTION/C_reset
add wave -position end  sim:/processor/MEMORY/current_SP
add wave -position end  sim:/processor/MEMORY/EPC_val
add wave -position end  sim:/processor/IN_PORT
add wave -position end  sim:/processor/OUT_PORT

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
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run