## How it works

This project implements a hardware-efficient **Constant False Alarm Rate (CFAR)** signal detection engine, optimized for area-constrained silicon footprints. It processes a 14-bit digital input to dynamically adapt to varying noise floors and detect valid target signals.

**Input Mapping:**
To bypass the standard 8-pin input limit, the design concatenates standard inputs with bidirectional pins configured as inputs:
* `ui_in[7:0]`: Lower 8 bits of the incoming signal.
* `uio_in[5:0]`: Upper 6 bits of the incoming signal (`uio_oe` = 0).
* These combine to form a unified 14-bit data bus (`{uio_in[5:0], ui_in[7:0]}`).

**CFAR Architecture:**
Instead of a memory-heavy sliding window, this design utilizes an Infinite Impulse Response (IIR) running average to estimate the background noise threshold.
1. The baseline threshold continually updates: `threshold = (threshold + signal) >> 1`.
2. A target is detected if the incoming signal exceeds this adaptive threshold multiplied by a fixed internal gain factor.
3. The resulting binary state is routed directly to a built-in 7-segment display driver, providing immediate visual feedback alongside a dedicated high/low output flag (`uo_out[7]`).

## How to test

1. **Initialization:**
    * Provide a standard clock signal to `clk`.
    * Assert reset (`rst_n = 0`) to clear the internal threshold registers.
    * Release reset (`rst_n = 1`) to begin normal operation.

2. **Baseline / Noise Floor Test (No Detection):**
    * Apply a steady, low-level signal (e.g., `ui_in = 50`, `uio_in = 0`).
    * **Expected Result:** The threshold adapts to the noise floor. The 7-segment display shows `0` and the detection flag (`uo_out[7]`) remains `0`.

3. **Target Detection Test (Spike):**
    * Inject a sudden signal spike (e.g., `ui_in = 250`, `uio_in = 0`).
    * **Expected Result:** The signal abruptly exceeds the calculated `threshold * GAIN` condition. The 7-segment display immediately updates to `1` and the detection flag (`uo_out[7]`) goes HIGH (`1`).

## External hardware

* **14-bit Signal Source:** An external Analog-to-Digital Converter (ADC) or a microcontroller (e.g., Raspberry Pi Pico on the Tiny Tapeout demo board) to generate the input vectors.
* **7-Segment Display:** The standard Tiny Tapeout PCB display to visualize the detection state.

*(Note: To maximize pin availability for the 14-bit data bus, no additional external peripherals, such as buzzers, are used).*
