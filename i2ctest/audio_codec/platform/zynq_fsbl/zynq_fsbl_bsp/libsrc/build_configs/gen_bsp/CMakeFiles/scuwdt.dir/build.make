# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.24

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Produce verbose output by default.
VERBOSE = 1

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /tools/Xilinx/Vitis/2023.2/tps/lnx64/cmake-3.24.2/bin/cmake

# The command to remove a file.
RM = /tools/Xilinx/Vitis/2023.2/tps/lnx64/cmake-3.24.2/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/somalianpirate/Documents/projects/audio_codec/platform/zynq_fsbl/zynq_fsbl_bsp

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/somalianpirate/Documents/projects/audio_codec/platform/zynq_fsbl/zynq_fsbl_bsp/libsrc/build_configs/gen_bsp

# Utility rule file for scuwdt.

# Include any custom commands dependencies for this target.
include CMakeFiles/scuwdt.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/scuwdt.dir/progress.make

CMakeFiles/scuwdt:
	lopper -O /home/somalianpirate/Documents/projects/audio_codec/platform/zynq_fsbl/zynq_fsbl_bsp/libsrc/scuwdt/src /home/somalianpirate/Documents/projects/audio_codec/platform/zynq_fsbl/zynq_fsbl_bsp/hw_artifacts/ps7_cortexa9_0_baremetal.dts -- baremetalconfig_xlnx ps7_cortexa9_0 /tools/Xilinx/Vitis/2023.2/data/embeddedsw/XilinxProcessorIPLib/drivers/scuwdt_v2_5/src

scuwdt: CMakeFiles/scuwdt
scuwdt: CMakeFiles/scuwdt.dir/build.make
.PHONY : scuwdt

# Rule to build all files generated by this target.
CMakeFiles/scuwdt.dir/build: scuwdt
.PHONY : CMakeFiles/scuwdt.dir/build

CMakeFiles/scuwdt.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/scuwdt.dir/cmake_clean.cmake
.PHONY : CMakeFiles/scuwdt.dir/clean

CMakeFiles/scuwdt.dir/depend:
	cd /home/somalianpirate/Documents/projects/audio_codec/platform/zynq_fsbl/zynq_fsbl_bsp/libsrc/build_configs/gen_bsp && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/somalianpirate/Documents/projects/audio_codec/platform/zynq_fsbl/zynq_fsbl_bsp /home/somalianpirate/Documents/projects/audio_codec/platform/zynq_fsbl/zynq_fsbl_bsp /home/somalianpirate/Documents/projects/audio_codec/platform/zynq_fsbl/zynq_fsbl_bsp/libsrc/build_configs/gen_bsp /home/somalianpirate/Documents/projects/audio_codec/platform/zynq_fsbl/zynq_fsbl_bsp/libsrc/build_configs/gen_bsp /home/somalianpirate/Documents/projects/audio_codec/platform/zynq_fsbl/zynq_fsbl_bsp/libsrc/build_configs/gen_bsp/CMakeFiles/scuwdt.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/scuwdt.dir/depend

