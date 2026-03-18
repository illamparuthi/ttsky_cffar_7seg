import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge

@cocotb.test()
async def test_cfar_integration(dut):
    """Test CFAR detection logic and 7-segment mapping"""
    dut._log.info("Starting CFAR + 7-Segment Integration Test")
    
    # 1. Start the clock in Python (10 ns period -> 100 MHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # 2. Initialize Inputs and Reset
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    
    # Wait for 5 clock cycles while in reset
    for _ in range(5):
        await RisingEdge(dut.clk)
    
    # Release reset
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)
    dut._log.info("System Reset Released")

    # 3. Test Case 1: Noise Floor (No Detection)
    # Signal (14'd10) < Initial Threshold (14'd100)
    dut.ui_in.value = 10 
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)
    await Timer(2, units="ns") # Allow combinational logic to settle
    
    # uo_out should be 0x40 (Detect=0, Segments display '0')
    assert dut.uo_out.value == 0x40, f"Expected '0' on display (0x40), got {hex(dut.uo_out.value)}"
    dut._log.info("Passed: No detection with low signal")

    # 4. Test Case 2: Detection (High Signal)
    # Signal: 500. High bits = 1 (0x01), Low bits = 244 (0xF4)
    dut.uio_in.value = 0x01
    dut.ui_in.value = 0xF4
    
    await RisingEdge(dut.clk)
    await Timer(2, units="ns")
    
    # uo_out should be 0xF9 (Detect=1, Segments display '1')
    assert dut.uo_out.value == 0xF9, f"Expected '1' on display (0xF9), got {hex(dut.uo_out.value)}"
    dut._log.info("Passed: Signal detected and 7-segment updated to '1'")

    # 5. Return to Idle
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)
    await Timer(2, units="ns")
    
    assert dut.uo_out.value == 0x40
    dut._log.info("Passed: System returned to idle")
