quit -sim
vdel -all
vlib work

vcom /home/somalianpirate/Documents/projects/audioProcHDL/arraypkg.vhd +cover
vcom /home/somalianpirate/Documents/projects/audioProcHDL/mask_gen.vhd +cover
vcom /home/somalianpirate/Documents/projects/audioProcHDL/sinewave.vhd +cover
vcom /home/somalianpirate/Documents/projects/audioProcHDL/dac.vhd +cover
vcom /home/somalianpirate/Documents/projects/audioProcHDL/fir.vhd +cover
vcom /home/somalianpirate/Documents/projects/audioProcHDL/top.vhd +cover
vcom /home/somalianpirate/Documents/projects/audioProcHDL/tb_top.vhd +cover

vsim -novopt -coverage tb_top
add wave /top_inst/*

run 6 ms

view wave