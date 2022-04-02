transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/roby/Documents/ISEL/Projeto-LIC/hardware/LIC/serial_control.vhd}

vcom -93 -work work {C:/Users/roby/Documents/ISEL/Projeto-LIC/hardware/LIC/serial_control_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  serial_control_tb

add wave *
view structure
view signals
run -all
