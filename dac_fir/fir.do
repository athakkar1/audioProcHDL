quit -sim
vdel -all
vlib work
vcom D:fir_filter/src/arraypkg.vhd
vcom D:fir_filter/src/fir.vhd
vcom D:fir_filter/src/test_fir.vhd

vsim -novopt test_fir
add wave /test_fir/*
add wave -radix decimal -format analog /fir_inst/data_in
add wave -radix decimal -format analog /fir_inst/data_out

run 5 ms

view wave