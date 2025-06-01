transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Verilog/Modulo3/Lab1_C9999 {D:/Verilog/Modulo3/Lab1_C9999/counter_9999.v}
vlog -vlog01compat -work work +incdir+D:/Verilog/Modulo3/Lab1_C9999 {D:/Verilog/Modulo3/Lab1_C9999/bin_to_bcd.v}
vlog -vlog01compat -work work +incdir+D:/Verilog/Modulo3/Lab1_C9999 {D:/Verilog/Modulo3/Lab1_C9999/bcd_to_7seg.v}
vlog -vlog01compat -work work +incdir+D:/Verilog/Modulo3/Lab1_C9999 {D:/Verilog/Modulo3/Lab1_C9999/top_counter_display.v}

vlog -vlog01compat -work work +incdir+D:/Verilog/Modulo3/Lab1_C9999 {D:/Verilog/Modulo3/Lab1_C9999/tb_counter_9999.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_top_counter_display

add wave *
view structure
view signals
run -all
