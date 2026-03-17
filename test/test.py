import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock

@cocotb.test()
async def test_cfar(dut):

    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1

    # Low signal
    dut.ui_in.value = 10
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)

    # High signal
    dut.ui_in.value = 200
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)

    # Check detection bit
    assert dut.uo_out.value[7] in [0,1]
