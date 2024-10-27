vsim -novopt i2s_tb


add wave i2s_tb/mclk
add wave i2s_tb/bclk
add wave i2s_tb/pbdat
add wave i2s_tb/pblrc
add wave i2s_tb/recdat
add wave i2s_tb/reclrc
add wave i2s_tb/pbword
add wave i2s_tb/recword_left
add wave i2s_tb/recword_right
add wave i2s_tb/reset
add wave i2s_tb/errnum
add wave i2s_tb/recdat_i
add wave i2s_tb/i2s_instance/recshift
add wave i2s_tb/i2s_instance/pbshift




run 20 us

