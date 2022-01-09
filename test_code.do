vsim -gui work.processor

mem load -i instruction.mem /processor/FETCHING/y/addressing_instruction

add wave -position end  sim:/processor/rst
add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/int_en
add wave -position end  sim:/processor/FETCHING/pc_instruction
add wave -position end  sim:/processor/FETCHING/instr
add wave -position end  sim:/processor/FETCHING/target
add wave -position end  sim:/processor/FETCHING/will_branch
add wave -position end  sim:/processor/FETCHING/int
add wave -position end sim:/processor/FETCHING/y/index 
add wave -position end  sim:/processor/FETCHING/y/int
add wave -position end  sim:/processor/FETCHING/y/instruction
add wave -position end  sim:/processor/DECODING/Rx/loop1(0)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(1)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(2)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(3)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(4)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(5)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(6)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(7)/rx/reg_out
add wave -position end  sim:/processor/DECODING/FINAL_SIGNALS
add wave -position end  sim:/processor/DECODING/flag_en_final
add wave -position end  sim:/processor/DECODING/Rs_address
add wave -position end  sim:/processor/DECODING/interrupt_en_final
add wave -position end  sim:/processor/DECODING/interrupt_en
add wave -position end  sim:/processor/DECODING/op_code
add wave -position end  sim:/processor/EXECUTION/jump_signal
add wave -position end  sim:/processor/EXECUTION/branch_signal
add wave -position end  sim:/processor/EXECUTION/target
add wave -position end  sim:/processor/EXECUTION/Z_en
add wave -position end  sim:/processor/EXECUTION/N_en
add wave -position end  sim:/processor/EXECUTION/C_en
add wave -position end  sim:/processor/EXECUTION/setting_flag/Z_out
add wave -position end  sim:/processor/EXECUTION/setting_flag/N_out
add wave -position end  sim:/processor/EXECUTION/setting_flag/C_out
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