import cocotb
from cocotb.triggers import Timer, RisingEdge

@cocotb.test()
async def test_cfar_integration(dut):
    """Test CFAR detection logic and 7-segment mapping"""
    
    dut._log.info("Starting CFAR + 7-Segment Integration Test")
    
    # 1. Initialize Clock and Reset
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.ena.value = 1
    
    # Wait for a few clock cycles
    for _ in range(5):
        await RisingEdge(dut.clk)
    
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)
    dut._log.info("System Reset Released")

    # 2. Test Case: Noise Floor (No Detection)
    # Signal (14'd10) < Reset Threshold (14'd100)
    dut.ui_in.value = 10 
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)
    await Timer(1, units="ns") # Allow combinational logic to settle
    
    # Check: uo_out[7] should be 0, segments should show '0' (0x40)
    # Binary: 0_1000000 = 0x40
    assert dut.uo_out.value == 0x40, f"Expected '0' on display, got {hex(dut.uo_out.value)}"
    dut._log.info("Passed: No detection with low signal")

    # 3. Test Case: Detection (High Signal)
    # We send a signal of 500. 
    # High bits (uio): 500 >> 8 = 1 (0x01)
    # Low bits (ui): 500 & 0xFF = 244 (0xF4)
    dut.uio_in.value = 0x01
    dut.ui_in.value = 0xF4
    
    # Wait for logic to process detection
    await RisingEdge(dut.clk)
    await Timer(1, units="ns")
    
    # Check: uo_out[7] should be 1, segments should show '1' (0x79)
    # Binary: 1_1111001 = 0xF9
    assert dut.uo_out.value == 0xF9, f"Expected '1' on display + Detect flag, got {hex(dut.uo_out.value)}"
    dut._log.info("Passed: Signal detected and 7-segment updated to '1'")

    # 4. Test Case: Return to Idle
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await RisingEdge(dut.clk)
    await Timer(1, units="ns")
    
    assert dut.uo_out.value == 0x40
    dut._log.info("Passed: System returned to idle '0' display")
