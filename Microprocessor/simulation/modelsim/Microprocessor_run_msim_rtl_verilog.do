transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Microprocessor {C:/Users/megge/Documents/GitHub/ECE385/Microprocessor/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Microprocessor {C:/Users/megge/Documents/GitHub/ECE385/Microprocessor/IR_module.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Microprocessor {C:/Users/megge/Documents/GitHub/ECE385/Microprocessor/PC_module.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Microprocessor {C:/Users/megge/Documents/GitHub/ECE385/Microprocessor/mux2.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Microprocessor {C:/Users/megge/Documents/GitHub/ECE385/Microprocessor/MDR_module.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Microprocessor {C:/Users/megge/Documents/GitHub/ECE385/Microprocessor/tristate.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Microprocessor {C:/Users/megge/Documents/GitHub/ECE385/Microprocessor/test_memory.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Microprocessor {C:/Users/megge/Documents/GitHub/ECE385/Microprocessor/SLC3_2.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Microprocessor {C:/Users/megge/Documents/GitHub/ECE385/Microprocessor/Mem2IO.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Microprocessor {C:/Users/megge/Documents/GitHub/ECE385/Microprocessor/ISDU.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Microprocessor {C:/Users/megge/Documents/GitHub/ECE385/Microprocessor/datapath.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Microprocessor {C:/Users/megge/Documents/GitHub/ECE385/Microprocessor/MAR_module.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Microprocessor {C:/Users/megge/Documents/GitHub/ECE385/Microprocessor/slc3.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Microprocessor {C:/Users/megge/Documents/GitHub/ECE385/Microprocessor/memory_contents.sv}
vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Microprocessor {C:/Users/megge/Documents/GitHub/ECE385/Microprocessor/lab6_toplevel.sv}

vlog -sv -work work +incdir+C:/Users/megge/Documents/GitHub/ECE385/Microprocessor {C:/Users/megge/Documents/GitHub/ECE385/Microprocessor/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns