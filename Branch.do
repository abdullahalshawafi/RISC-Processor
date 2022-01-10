vsim -gui work.processor

mem load -i instruction.mem /processor/FETCHING/y/addressing_instruction

add wave -position end  sim:/processor/rst
add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/IF_ID_BUFFER_FROM_FETCHING
add wave -position end  sim:/processor/IF_ID_BUFFER_TO_DECODING
add wave -position end  sim:/processor/ID_IE_TO_EXECUTION
add wave -position end  sim:/processor/FETCHING/target
add wave -position end  sim:/processor/FETCHING/will_branch
add wave -position end  sim:/processor/FETCHING/pc_instruction
add wave -position end  sim:/processor/FETCHING/pc_write
add wave -position end  sim:/processor/DECODING/Rx/loop1(0)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(1)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(2)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(3)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(4)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(5)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(6)/rx/reg_out
add wave -position end  sim:/processor/DECODING/Rx/loop1(7)/rx/reg_out
add wave -position end  sim:/processor/DECODING/stall_pipe
add wave -position end sim:/processor/DECODING/ID_IE_BUFFER(133)
add wave -position end sim:/processor/EXECUTION/ID_IE_BUFFER(133)

add wave -position end  sim:/processor/EXECUTION/TARGET
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
force -freeze sim:/processor/IN_PORT X"0700" 0
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