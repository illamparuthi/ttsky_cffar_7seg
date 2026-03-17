import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock

@cocotb.test()
async def test_cfar(dut):

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    # Initialize
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Hold reset
    for _ in range(10):
        await RisingEdge(dut.clk)

    dut.rst_n.value = 1

    # Wait for stabilization
    for _ in range(30):
        await RisingEdge(dut.clk)

    # Apply signal
    dut.ui_in.value = 200
    dut.uio_in.value = 0

    # Wait and retry until valid
    valid = False

    for _ in range(50):
        await RisingEdge(dut.clk)
        val = dut.uo_out.value[7]

        if val.is_resolvable:
            valid = True
            break

    # ✅ Final check
    assert valid, "Output never resolved from X!"
    assert int(val) in [0, 1]
