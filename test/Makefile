# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

SIM ?= icarus
FST ?= -fst
TOPLEVEL_LANG ?= verilog

SRC_DIR = $(PWD)/../src

ifneq ($(GATES),yes)

# RTL simulation:
SIM_BUILD = sim_build/rtl

# ✅ Include ALL Verilog files automatically
VERILOG_SOURCES += $(wildcard $(SRC_DIR)/*.v)

else

# Gate level simulation:
SIM_BUILD = sim_build/gl

COMPILE_ARGS += -DGL_TEST
COMPILE_ARGS += -DFUNCTIONAL
COMPILE_ARGS += -DUSE_POWER_PINS
COMPILE_ARGS += -DSIM
COMPILE_ARGS += -DUNIT_DELAY=\#1

VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

# Gate netlist
VERILOG_SOURCES += $(PWD)/gate_level_netlist.v

endif

# Include directories
COMPILE_ARGS += -I$(SRC_DIR)

# Testbench
VERILOG_SOURCES += $(PWD)/tb.v
TOPLEVEL = tb

# Cocotb test
COCOTB_TEST_MODULES = test

include $(shell cocotb-config --makefiles)/Makefile.sim
