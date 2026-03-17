![](../../workflows/gds/badge.svg) 
![](../../workflows/docs/badge.svg) 
![](../../workflows/test/badge.svg) 
![](../../workflows/fpga/badge.svg)

# 📡 CFAR-Based Signal Detection (TinyTapeout)

- [Project Documentation](docs/info.md)

---

## 🚀 Overview

This project implements a **Constant False Alarm Rate (CFAR) based signal detection system** using Verilog, designed for TinyTapeout.

The system processes a **14-bit ADC input**, applies an **adaptive threshold**, and detects whether a target signal is present. The result is displayed on a **7-segment output**.

---

## 🧠 How It Works

- Input is received from:
  - `ui_in[7:0]` → lower 8 bits  
  - `uio_in[5:0]` → upper 6 bits  

- These are combined to form a **14-bit signal**

- A simplified CFAR algorithm:
  - Computes a **running average threshold**
  - Compares input signal with threshold

- Detection logic:
  - `signal > threshold` → **Detected (1)**
  - Otherwise → **Not detected (0)**

- Output:
  - `uo_out[6:0]` → 7-segment display  
  - `uo_out[7]` → detection flag  

---

## 🔌 Pin Configuration

### Inputs
- `ui_in[7:0]` → ADC bits [7:0]
- `uio_in[5:0]` → ADC bits [13:8]

### Outputs
- `uo_out[6:0]` → 7-segment display  
- `uo_out[7]` → detection output  

### Bidirectional Pins
- Used as inputs (`uio_oe = 0`)

---

## 🧪 How to Test

1. Apply clock and reset:
   - `rst_n = 0` → reset  
   - `rst_n = 1` → run  

2. Provide input signal:


Expected output:
- 7-segment → 0  
- detection → 0  

**Case 2: Detection**
Expected output:
- 7-segment → 1  
- detection → 1  

---

## 🏗️ Project Structure

   **Case 1: No detection**

   
---

## ⚙️ Key Features

- ✅ 14-bit ADC input using limited IO pins  
- ✅ Adaptive threshold (CFAR logic)  
- ✅ No buzzer (optimized pin usage)  
- ✅ 7-segment display output  
- ✅ TinyTapeout compatible  

---

## 🌍 What is Tiny Tapeout?

Tiny Tapeout is an educational initiative that enables designers to fabricate their digital designs on real silicon at low cost.

👉 Learn more: https://tinytapeout.com

---

## 📌 Notes

- This design uses a **simplified CFAR algorithm** (running average) instead of full sliding window CFAR  
- Optimized for **low area and IO constraints**  

---

## 🚀 Next Steps

- Submit your design: https://app.tinytapeout.com/  
- Share your project:
  - LinkedIn: #tinytapeout  
  - X (Twitter): #tinytapeout  
  - Discord: TinyTapeout community  

---

## 👨‍💻 Author

**Ilamparuthi G**
- Email: ilamparithi2343@gmail.com
