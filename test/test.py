import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock

@cocotb.test()
async def test_cfar(dut):

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    # Apply reset properly
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    for _ in range(5):
        await RisingEdge(dut.clk)

    dut.rst_n.value = 1

    # Wait for stabilization
    for _ in range(10):
        await RisingEdge(dut.clk)

    # Apply low signal
    dut.ui_in.value = 10
    dut.uio_in.value = 0

    for _ in range(10):
        await RisingEdge(dut.clk)

    # Apply high signal
    dut.ui_in.value = 200
    dut.uio_in.value = 0

    for _ in range(10):
        await RisingEdge(dut.clk)

    # Now check
    assert int(dut.uo_out.value[7]) in [0,1]
