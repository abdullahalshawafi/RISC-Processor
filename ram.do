vsim -gui work.ram
add wave -position end  sim:/ram/address
add wave -position end  sim:/ram/clk
add wave -position end  sim:/ram/data_in
add wave -position end  sim:/ram/data_out
add wave -position end  sim:/ram/write_address
force -freeze sim:/ram/write_address 1 0
force -freeze sim:/ram/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/ram/address 32#0 0
force -freeze sim:/ram/data_in 16#20 0
run
run

