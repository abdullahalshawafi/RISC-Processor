vsim -gui work.processor

mem load -i instruction.mem /processor/FETCHING/y/addressing_instruction

add wave -position end  sim:/processor/rst
add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/FETCHING/pc_out
#add wave -position end  sim:/processor/DECODING/pc_en
add wave -position end  sim:/processor/DECODING/set_carry
add wave -position end  sim:/processor/DECODING/in_en
add wave -position end  sim:/processor/EXECUTION/alu_src2
add wave -position end  sim:/processor/EXECUTION/alu_result_temp
add wave -position end  sim:/processor/EXECUTION/Cfinal
add wave -position end  sim:/processor/pc_write
add wave -position end  sim:/processor/IN_PORT

force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100

# reset all
force -freeze sim:/processor/rst 1 0
force -freeze sim:/processor/IN_PORT X"AF01" 0
run

force -freeze sim:/processor/rst 0 0
run
run
run
run
run
run