import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock

@cocotb.test()
async def test_cfar(dut):
    # Create clock (you have a 'clk' port in project.v)
    clock = Clock(dut.clk, 10, units="ns")
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

    # Apply some ADC input – here just a test value
    # ui_in[7:0] = lower 8 bits, uio_in[5:0] = upper 6 bits
    dut.ui_in.value = 200          # example: 0b11001000
    dut.uio_in.value = 0           # upper 6 bits = 0

    # Wait and retry until valid
    valid = False
    val = None

    for _ in range(50):
        await RisingEdge(dut.clk)
        # Detection flag is uo_out[7] per your README
        val = dut.uo_out.value[7]

        if val.is_resolvable:
            valid = True
            break

    # Final check
    assert valid, "Output never resolved from X!"
    assert int(val) in [0, 1], f"Unexpected output value: {int(val)}"

