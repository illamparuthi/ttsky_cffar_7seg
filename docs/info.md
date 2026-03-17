<!---
This file is used to generate your project datasheet.
--->

## How it works

This project implements a **Constant False Alarm Rate (CFAR) based signal detection system** using a 14-bit digital input.

The input signal is received from an external ADC and mapped using:
- `ui_in[7:0]` → lower 8 bits  
- `uio_in[5:0]` → upper 6 bits  

These are combined to form a **14-bit signal**.

A simplified CFAR algorithm is used:
- The system estimates a **noise threshold** using a running average
- The incoming signal is compared with this adaptive threshold
- If `signal > threshold` → **target detected (1)**
- Else → **no detection (0)**

The detection result is:
- Converted into a **BCD value (0 or 1)**
- Displayed on a **7-segment output (`uo_out[6:0]`)**
- Also available as a **detection flag (`uo_out[7]`)**

This adaptive approach allows reliable detection under varying noise conditions.

---

## How to test

1. Apply clock and reset:
   - Provide clock to `clk`
   - Set `rst_n = 0`, then `rst_n = 1`

2. Provide ADC input:
   - Lower 8 bits → `ui_in[7:0]`
   - Upper 6 bits → `uio_in[5:0]`

3. Test cases:

   - Low signal (no detection):
     ```
     ui_in = 10
     uio_in = 0
     ```
     Expected output:
     - 7-segment → 0
     - detection flag → 0

   - High signal (detection):
     ```
     ui_in = 200
     uio_in = 0
     ```
     Expected output:
     - 7-segment → 1
     - detection flag → 1

4. Observe outputs:
   - `uo_out[6:0]` → 7-segment display
   - `uo_out[7]` → detection result

---

## External hardware

- **ADC (Analog-to-Digital Converter)**  
  Provides the 14-bit input signal

- **7-Segment Display**  
  Displays detection result (0 or 1)

No additional external hardware (such as buzzer) is used.

---

## Notes

This design is optimized for **low area and limited I/O constraints**, making it suitable for TinyTapeout.
