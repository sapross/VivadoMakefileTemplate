##
# BitSerialCompareSwap
#
# @file
# @version 0.1

# Author: Stephan Proß
# Date: 05.03.2023
# Description: Makefile for implementing test sorter using vivado.
# 			   Based on Makefile used in CVA6

PROJECT_NAME := VivadoMakefileTemplate
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
root-dir := $(dir $(mkfile_path))

# --------------------------------------------------------------------
# ------- CONSTRAINTS AND BOARD DEFINITIONS --------------------------
# --------------------------------------------------------------------

# Either provide name of the board via CLI or change the
# default value here.
BOARD ?= nexys4ddr

# Don't forget to add your hardware target if it's not in the
# list. You can get the specific parameters from the Vivado GUI.
ifeq ($(BOARD), nexys4ddr)
	XILINX_PART              := xc7a100tcsg324-1
	XILINX_BOARD             := digilentinc.com:nexys4_ddr:part0:1.1
	CONSTRAINTS 		 := $(root-dir)/constr/nexys4ddr.xdc
else ifeq($(BOARD), zedboard)
	XILINX_PART              := xc7z020clg484-1
	XILINX_BOARD             := avnet.com:zedboard:part0:1.4
	CONSTRAINTS 		 := $(root-dir)/constr/zedboard.xdc
else
$(error Unknown board - please specify a supported FPGA board)
endif

# --------------------------------------------------------------------
# ------- SOURCES ----------------------------------------------------
# --------------------------------------------------------------------

# Add your library files containing packages and or global definitions
# here.
lib := \
			lib/ExamplePackage.vhd
# Turn relative to absolute path here.
lib := $(addprefix $(root-dir)/, $(lib))

# Add your sources here. Don't forget to include your top file here.
src := \
			src/Debouncer/Debouncer.vhd                        \
			top/Debouncer_Top.vhd
# wildcard imports
src += $(wildcard src/**/*.vhd)
# Turn relative to absolute path here.
src := $(addprefix $(root-dir)/, $(src))

# Work directory to contain all files relevant for building.
work-dir := work_dir

# TOP-Module/Component for synthesis & implementation. Module must be somewhere in
# the source listing.
TOP ?= DEBOUNCER_TOP

BIT_FILE := $(work-dir)/$(TOP).bit
bit := $(BIT_FILE)


VIVADOENV := PROJECT_NAME=$(PROJECT_NAME) BOARD=$(BOARD) XILINX_PART=$(XILINX_PART) XILINX_BOARD=$(XILINX_BOARD) CONSTRAINTS=$(CONSTRAINTS) BIT_FILE=$(BIT_FILE)
VIVADO ?= vivado
VIVADOFLAGS ?= -nojournal -mode batch -source $(root-dir)/scripts/prologue.tcl

#==== Default target - running simulation without drawing waveforms ====#
all: $(bit)

fpga: $(src)
	mkdir -p $(work-dir)
	@echo "[FPGA] Generate sources"
	@echo read_vhdl        {$(src)}    > $(work-dir)/add_sources.tcl
	@echo read_vhdl        {$(lib)}    >> $(work-dir)/add_sources.tcl
	@echo set_property IS_GLOBAL_INCLUDE 0 [get_files $(lib)] >> $(work-dir)/add_sources.tcl
	@echo set_property TOP ${TOP} [current_fileset] >> $(work-dir)/add_sources.tcl
	@echo set_property file_type {VHDL 2008} [get_files  *] >> $(work-dir)/add_sources.tcl
	@echo "[FPGA] Generate Bitstream"
.PHONY: fpga

$(bit): fpga
	cd $(work-dir) && $(VIVADOENV) $(VIVADO) $(VIVADOFLAGS) -source $(root-dir)/scripts/run.tcl
	cp $(work-dir)/$(PROJECT_NAME).runs/impl_1/$(TOP)* ./$(work-dir)

program:
	$(VIVADOENV) $(VIVADO) $(VIVADOFLAGS) -source $(root-dir)/scripts/program.tcl

clean:
	rm -rf $(work-dir)

.PHONY:
	clean


# end
