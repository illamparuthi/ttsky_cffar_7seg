![](../../workflows/gds/badge.svg) 
![](../../workflows/docs/badge.svg) 
![](../../workflows/test/badge.svg) 
![](../../workflows/fpga/badge.svg)

# 📡 CFAR-Based Signal Detection (Tiny Tapeout)

[![Tiny Tapeout](https://img.shields.io/badge/Tiny_Tapeout-Ready-blue.svg)](https://tinytapeout.com)
[![Documentation](https://img.shields.io/badge/Docs-info.md-green.svg)](docs/info.md)

## 🚀 Overview
This project implements a hardware-efficient **Constant False Alarm Rate (CFAR)** signal detection engine in Verilog, designed specifically for fabrication via the Tiny Tapeout educational ASIC program. 

The core RTL processes a **14-bit ADC input signal**, dynamically calculates an adaptive noise threshold, and flags valid target signals. To meet strict I/O and area constraints, the design utilizes a simplified running-average CFAR architecture and outputs the detection status directly to an onboard 7-segment display.

---

## 🧠 Architecture & Algorithm

Traditional sliding-window CFAR algorithms require significant memory (shift registers) which consumes valuable silicon area. This design is highly optimized for the Tiny Tapeout footprint by using an Infinite Impulse Response (IIR) style running average:

1. **Input Concatenation:** The 14-bit input is constructed by concatenating standard input pins and bidirectional pins configured as inputs (`{uio_in[5:0], ui_in[7:0]}`).
2. **Adaptive Thresholding:** The baseline threshold dynamically updates continuously: `threshold = (threshold + signal) >> 1`.
3. **Detection Logic:** A signal is flagged as a valid target if it exceeds the running threshold multiplied by a hardcoded gain factor (`signal > (threshold * GAIN)`).
4. **Visual Output:** The system drives a 7-segment display (showing `1` for detection, `0` for no detection) and sets a dedicated flag bit.

---

## 🔌 Pin Mapping

| Port Type | Pin(s) | Function | Description |
| :--- | :--- | :--- | :--- |
| **Input** | `ui_in[7:0]` | ADC Low | Lower 8 bits of the incoming signal. |
| **Input (Bidir)** | `uio_in[5:0]`| ADC High | Upper 6 bits of the incoming signal (`uio_oe` = 0). |
| **Output** | `uo_out[6:0]` | 7-Segment | Drives the standard Tiny Tapeout 7-segment display. |
| **Output** | `uo_out[7]` | Detect Flag | Goes HIGH (`1`) when a target is detected. |

*Note: The remaining bidirectional pins are tied off to ground to prevent floating inputs.*

---

## 🧪 Simulation & Testing

The design can be verified using standard Verilog testbenches (e.g., via Icarus Verilog and GTKWave/EPWave). 

**Initialization Sequence:**
1. Apply Clock (`clk`).
2. Assert Reset (`rst_n = 0`) to clear the threshold baseline.
3. De-assert Reset (`rst_n = 1`) to begin normal operation.

**Behavioral Test Cases:**

* **Case 1: Baseline / No Detection**
    * **Action:** Apply a steady low signal (e.g., `signal = 50`).
    * **Result:** The threshold adapts to the noise floor. 
    * **Expected Output:** 7-Segment displays `0`. Detection flag (`uo_out[7]`) remains `0`.
* **Case 2: Target Detection (Spike)**
    * **Action:** Apply a sudden high signal spike (e.g., `signal = 250`).
    * **Result:** The signal overcomes the `threshold * GAIN` condition.
    * **Expected Output:** 7-Segment displays `1`. Detection flag (`uo_out[7]`) goes HIGH to `1`.

---

## ⚙️ Key Features
- ✅ **Optimized Synthesizable RTL:** Fully prepared for the OpenLane RTL-to-GDSII flow.
- ✅ **14-bit ADC Support:** Clever utilization of bidirectional pins to maximize input bandwidth.
- ✅ **Adaptive Logic:** Self-adjusting CFAR noise floor tracking.
- ✅ **Area & I/O Conscious:** Eliminates unnecessary peripherals (like buzzers) to fit within the Tiny Tapeout tile limits.

---

## 🌍 About Tiny Tapeout
Tiny Tapeout is an educational project that aims to make it easier and cheaper than ever to get your digital designs manufactured on a real silicon chip. 

👉 Learn more at [tinytapeout.com](https://tinytapeout.com)

---

## 👨‍💻 Author
**Ilamparuthi G**
* **Email:** ilamparithi2343@gmail.com
