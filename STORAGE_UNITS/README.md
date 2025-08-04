# 📘 Flip-Flop Based Storage Unit – RTL Reference Model for ASIC Memory

## 🔎 Overview

In RTL (Register Transfer Level) design for ASICs, we do **not directly code the physical memories** (like SRAMs, ROMs, CAMs, etc.). These memory components are **technology-specific IP blocks** provided by semiconductor foundries or standard cell libraries. They are highly optimized in terms of area, speed, and power, and are tailored for a particular process node (e.g., 7nm, 14nm, 28nm).

However, during the RTL development and simulation stages, we still need to **model the behavior** of these memory blocks. For this purpose, **flip-flop based storage units** are written in synthesizable RTL to emulate the memory functionality. These **reference models** are:

- Fully synthesizable.
- Behave like real memories (read/write interfaces, latencies, etc.).
- Used **only for simulation, verification, and synthesis**.

## ⚠️ Why Not Use Flip-Flop Memory in Final ASIC?

- Flip-flop based memory consumes **~10x more area** compared to specialized memory macros.
- Not optimized for power or performance like true memories.
- So, during the **Physical Design stage**, synthesis tools recognize these structures and replace them with **foundry-provided memory macros** through a process called **memory inference** or **macro replacement**.

---

## 🧠 Key Design Considerations

- Write and Read operations are synchronous.
- Storage modeled using 2D array of flip-flops (`reg [WIDTH-1:0] mem [DEPTH-1:0]`).
- Can be parameterized for different word widths and depths.
- Interface usually includes `clk`, `rst`, `write_en`, `read_en`, `addr`, `data_in`, `data_out`.

---

This directory contains a synthesizable **flip-flop based memory module** written in SystemVerilog. It is meant as a reference model for ASIC memories (such as SRAM or ROM) and is typically replaced with foundry-optimized memory macros during the physical design phase.

## 🧠 Purpose
In ASIC designs, memory macros are **not coded explicitly** in RTL. Instead:
- Designers use **register arrays** (flip-flops) to mimic memory behavior.
- During **Physical Design**, these are **replaced by efficient standard cell-based or SRAM-based memory macros**.

This module:
- Supports **parameterizable width and depth**.
- Provides **synchronous write** and **combinational read**.
- Uses `$clog2(DEPTH)` to auto-determine address width.

## 🔧 Parameters
| Parameter | Description                  | Default |
|-----------|------------------------------|---------|
| WIDTH     | Bit width of each memory word| 1024    |
| DEPTH     | Number of memory locations   | 512     |

## ⚙️ Ports
| Name      | Direction | Width                | Description            |
|-----------|-----------|----------------------|------------------------|
| clk       | input     | 1                    | Clock signal           |
| rst_n     | input     | 1                    | Async reset (active low)|
| rd_en     | input     | 1                    | Read enable            |
| rd_addrs  | input     | $\log_2$(DEPTH) bits | Read address           |
| rd_data   | output    | WIDTH                | Output data            |
| wr_en     | input     | 1                    | Write enable           |
| wr_addrs  | input     | $\log_2$(DEPTH) bits | Write address          |
| wr_data   | input     | WIDTH                | Data to write          |

## 📝 Notes
- Use only for **simulation**, **testbenches**, or **logic synthesis**.
- Replace with **SRAM macros** or **IP memories** during layout.