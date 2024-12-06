# Compile the design files and testbench
vlib work
vlog -lint APBDesign.sv +acc
vlog -lint APBONESlave.sv +acc
vlog -lint TB.sv +acc
vlog -lint APBSlave.sv +acc
vlog -lint Package.sv +acc
vlog -lint APBinterface.sv +acc

# Simulate the testbench
vsim work.tb_one_slave

# Source the wave-related do files
 
add wave -group "APB_Master" sim:/tb_one_slave/dut/m1/*
add wave -group "APB_Slave 1" sim:/tb_one_slave/dut/s1/*

run -all               

    
