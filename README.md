# temaASC

# Memory Management Simulation

## Overview

This project implements a memory management system that simulates managing a storage device (e.g., hard disk or SSD). It models memory in two ways:

- **1D Linear Space**
- **2D Matrix Space**

The system manages "files" identified by a unique numeric descriptor ID (1–255), and supports operations for adding, locating, deleting, and defragmenting files in memory.

---

## Simplified Model

- **Memory Block**: 8 kB simulated by 1 Byte (8 bits).
- **1D Total Memory**: 8 MB, divided into 8 kB blocks.
- **2D Total Memory**: 8 MB × 8 MB space.

**File Allocation Logic:**

- A file requires at least **two blocks**.
- Number of blocks = ceiling of file size in kB (treated as Bytes in simulation).

---

## Supported Operations

### ADD

- **Purpose**: Adds one or more files to memory.
- **Logic**: Finds the first free interval (left-to-right) and allocates it.
- **Output**:
  - **1D**: `%d: (%d, %d)\n`
  - **2D**: `%d: ((%d, %d), (%d, %d))\n`
  - If not enough space: `(0, 0)` or `((0, 0), (0, 0))`

---

### GET

- **Purpose**: Locates a file by its descriptor ID.
- **Logic**: Finds the start and end blocks for that file.
- **Output**:
  - **1D**: `(%d, %d)\n`
  - **2D**: `((%d, %d), (%d, %d))\n`
  - If not found: `(0, 0)` or `((0, 0), (0, 0))`

---

### DELETE

- **Purpose**: Deletes a file from memory.
- **Logic**: Sets all blocks occupied by the file to `0`.
- **Output**: Prints updated memory state.

---

### DEFRAGMENTATION

- **Purpose**: Reorganizes memory to remove gaps.
- **Logic**:
  - **1D**: Moves files to eliminate gaps.
  - **2D**: Moves files so free space is pushed towards the bottom-right.
- **Output**: Prints compacted memory layout.

---

## Source Files

| File Name                                | Description                                    |
|------------------------------------------|------------------------------------------------|
| `152_Buzdugan_IoanMichael_0.s`           | Implements **1D vector memory** logic         |
| `152_Buzdugan_IoanMichael_1.s`           | Implements **2D matrix memory** logic         |

---

## Compilation

The code is designed for **32-bit Linux** systems.

> **Note**: On 64-bit systems, install `gcc-multilib`.

```bash
# Compile 1D vector simulation
gcc -m32 -o task0 152_Buzdugan_IoanMichael_0.s

# Compile 2D matrix simulation
gcc -m32 -o task1 152_Buzdugan_IoanMichael_1.s
