transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/Verilog/Modulo3/Lab7_AdderTree {D:/Verilog/Modulo3/Lab7_AdderTree/adder_tree.sv}

vlog -sv -work work +incdir+D:/Verilog/Modulo3/Lab7_AdderTree {D:/Verilog/Modulo3/Lab7_AdderTree/adder_tree_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  adder_tree_tb

add wave *
view structure
view signals
run -all
