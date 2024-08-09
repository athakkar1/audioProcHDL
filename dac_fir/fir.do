quit -sim
vdel -all
vlib work

vcom /home/somalianpirate/Documents/projects/audioProcHDL/dac_fir/src/arraypkg.vhd +cover
vcom /home/somalianpirate/Documents/projects/audioProcHDL/dac_fir/src/mask_gen.vhd +cover
vcom /home/somalianpirate/Documents/projects/audioProcHDL/dac_fir/src/sinewave.vhd +cover
vcom /home/somalianpirate/Documents/projects/audioProcHDL/dac_fir/src/dac.vhd +cover
vcom /home/somalianpirate/Documents/projects/audioProcHDL/dac_fir/src/fir.vhd +cover
vcom /home/somalianpirate/Documents/projects/audioProcHDL/dac_fir/src/top.vhd +cover
vcom /home/somalianpirate/Documents/projects/audioProcHDL/dac_fir/src/tb_top.vhd +cover

vsim -coverage tb_top
add wave /top_inst/*

run 6 ms

view wave