
vsim -gui work.memory_stage

add wave -position end  sim:/memory_stage/clk
add wave -position end  sim:/memory_stage/IE_IM_BUFFER
add wave -position end  sim:/memory_stage/IM_IW_BUFFER
add wave -position end  sim:/memory_stage/Alu_result
add wave -position end  sim:/memory_stage/PC
add wave -position end  sim:/memory_stage/dataMem/address
add wave -position end  sim:/memory_stage/dataMem/data
add wave -position end  sim:/memory_stage/dataMem/my_address
add wave -position end  sim:/memory_stage/dataMem/write_mem
add wave -position end  sim:/memory_stage/dataMem/dataMem/address
add wave -position end  sim:/memory_stage/dataMem/dataMem/stack_OP
add wave -position end  sim:/memory_stage/dataMem/dataMem/write_mem
add wave -position end  sim:/memory_stage/dataMem/dataMem/PC_Read
add wave -position end  sim:/memory_stage/dataMem/dataMem/PC
add wave -position end  sim:/memory_stage/dataMem/dataMem/mem_Read
add wave -position end  sim:/memory_stage/memRead
add wave -position end  sim:/memory_stage/current_SP


force -freeze sim:/memory_stage/IE_IM_BUFFER 0FFF0000000000000016 0
force -freeze sim:/memory_stage/clk 1 0, 0 {50 ps} -r 100
run
run

force -freeze sim:/memory_stage/IE_IM_BUFFER 0F6F0000000000000016 0
run
run

force -freeze sim:/memory_stage/IE_IM_BUFFER 0F970000000000000016 0
run
run

force -freeze sim:/memory_stage/IE_IM_BUFFER 00000000000000000016 0
run
run


force -freeze sim:/memory_stage/IE_IM_BUFFER 010F0FF0000000000016 0
run
run
force -freeze sim:/memory_stage/IE_IM_BUFFER 01300000000000000016 0
run
run
force -freeze sim:/memory_stage/IE_IM_BUFFER 00000000000000000016 0
run
run
