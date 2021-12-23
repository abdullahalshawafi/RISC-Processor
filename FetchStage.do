vsim -gui work.fetch_stage

mem load -i instruction.mem /fetch_stage/y/addressing_instruction

add wave -position end  sim:/fetch_stage/rst
add wave -position end  sim:/fetch_stage/clk
add wave -position end  sim:/fetch_stage/instType
add wave -position end  sim:/fetch_stage/IF_ID_BUFFER

force -freeze sim:/fetch_stage/clk 1 0, 0 {50 ps} -r 100

# reset all
force -freeze sim:/fetch_stage/rst 1 0
force -freeze sim:/fetch_stage/instType 0 0
run

force -freeze sim:/fetch_stage/rst 0 0
run
run
run
run
run
run
run
run
run