# UART RECEIVER in Verilog for FPGA (Basys 3)

## Source Files

The source files (Design and Constraints) are in the `pc_to_FPGA_UART` folder.

A complete **UART Receiver** (Universal Asynchronous Receiver) implementation for FPGAs, written in Verilog HDL. This project includes:

- Receiver module
- Baud rate generator module
- Seven-segment display module
- Debounce modules for hardware implementation

---

## Overview

This repository contains a full-featured UART receiver targeting FPGA devices. The design supports:

- Configurable baud rate generation
- Standard data frame: **8 data bits, no parity, 1 stop bit**
- 16x oversampling for reliable data reception
- Clean and modular design architecture

---

## Features

- Baud rate generator
- RX module
- Seven-segment display module for **BASYS 3 (Artix-7)**
- FPGA pin constraints file (`.xdc`)
- Debounce logic for push buttons

---

## Repository Structure

```
pc_to_FPGA_UART.srcs/
  ├── top_module.v # Top-level module
  │ ├── baud_rate_generator.sv # Baud rate generation
  │ ├── uart_receiver.v # UART receiver
  │ ├── sevenSegment_display.v # Seven-segment display driver (Basys 3)
  │ ├── binary_to_BCD.v # Converts binary to BCD for display
  │ ├── debounce_rst.v # Debounce for external reset
  │ └── debounce_tx_start.v # Debounce for external tx_start
  │
  ├── constrs_1/
  │ └── constraints.xdc # FPGA pin constraints (Basys 3)
README.md/ # This file
sendingBinary.py

```


---

## Prerequisites

- **Vivado Design Suite 2017.4** or later
- **FPGA Board:** Basys 3 (Artix-7)

---

## Hardware Implementation

### Add the Constraints File
1. Include the provided `.xdc` file in your Vivado project.
2. This file maps your module’s ports to the physical pins on your FPGA board.

### Modify Pin Assignments
- Open the `.xdc` file.
- Update the pin assignments to match your specific FPGA board and connected peripherals (switches, LEDs, Pmod connectors, etc.).

### Project Configuration
- This design implements a UART receiver in **`top_module.v`**.

### Connecting I/O
- **Received Data (`rx_data`):** Connect to on-board LEDs, seven-segment displays, or Pmod connectors for output.  
- **Note:** `rx_data` resets to `8'hFF`.

## Synthesis & Implementation

1. Run **Synthesis** in Vivado.
2. Run **Implementation** to place and route the design.

## Generate Bitstream & Program the FPGA

1. After successful implementation, generate the `.bit` file.
2. Program the FPGA board using Vivado’s Hardware Manager.
---
## Setting Up UART Communication with PC (Windows)

### Open the Windows command terminal
### Check if Python is installed
  - python --version

### Check if PySerial is installed
  - pip show PySerial

### If not installed, install PySerial
  - pip install PySerial

### Open the Python file "sendingBinary.py" Located in the pc_to_FPGA_UART folder.

### Edit the COM port number (“COM Digit”) — check the assigned COM port in Device Manager.

### Run the Python script
  - python sendingBinary.py

### Transmit data
  - The script will enter write mode.
  - Transmit any binary 8-bit number from your terminal — it will be received by the FPGA and displayed on LEDs and the seven-segment display.


