
vsim -gui work.memory_stage

add wave -position end  sim:/memory_stage/clk
add wave -position end  sim:/memory_stage/IE_IM_BUFFER
add wave -position end  sim:/memory_stage/IM_IW_BUFFER
add wave -position end  sim:/memory_stage/Alu_result
add wave -position end  sim:/memory_stage/PC
add wave -position end  sim:/memory_stage/dataMem/address
add wave -position end  sim:/memory_stage/dataMem/data
add wave -position end  sim:/memory_stage/dataMem/memRead
add wave -position end  sim:/memory_stage/dataMem/my_address
add wave -position end  sim:/memory_stage/dataMem/write_back
add wave -position end  sim:/memory_stage/dataMem/write_mem

force -freeze sim:/memory_stage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/memory_stage/IE_IM_BUFFER 0000000000000000000000010101000000000001000001000000000000000000000000000000 0
run
run
run