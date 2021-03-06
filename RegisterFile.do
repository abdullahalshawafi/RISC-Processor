vsim -gui work.register_file 
# Start time: 21:29:03 on Dec 10,2021
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.register_file(register_file_arch)
# Loading work.register_component(register_component_arch)
force -freeze sim:/register_file/clk 1 0, 0 {50 ps} -r 100
add wave -position insertpoint  \
sim:/register_file/clk \
sim:/register_file/reg_write \
sim:/register_file/Rs_address \
sim:/register_file/Rt_address \
sim:/register_file/Rd_address \
sim:/register_file/Wd \
sim:/register_file/Rs_data \
sim:/register_file/Rt_data \
sim:/register_file/reg_in \
sim:/register_file/reg_out \
sim:/register_file/reg_out_withWB
# WARNING: No extended dataflow license exists
force -freeze sim:/register_file/rst 1 0
run
force -freeze sim:/register_file/reg_write 0 0
force -freeze sim:/register_file/reg_in(0) 16#0 0
force -freeze sim:/register_file/reg_in(1) 16#1 0
force -freeze sim:/register_file/reg_in(2) 16#2 0
force -freeze sim:/register_file/reg_in(3) 16#3 0
force -freeze sim:/register_file/reg_in(4) 16#4 0
force -freeze sim:/register_file/reg_in(5) 16#5 0
force -freeze sim:/register_file/reg_in(6) 16#6 0
force -freeze sim:/register_file/reg_in(7) 16#7 0
force -freeze sim:/register_file/Wd 16#afaf 0
run
force -freeze sim:/register_file/Rs_address 001 0
force -freeze sim:/register_file/Rt_address 010 0
force -freeze sim:/register_file/Rd_address 001 0
run
force -freeze sim:/register_file/rst 0 0
run
run

