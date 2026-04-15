# 🛡️ CAALP Buffer Overflow Simulator

![C](https://img.shields.io/badge/C-00599C?style=for-the-badge&logo=c&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)

A Project-Based Learning (PBL) simulation demonstrating the mechanics of a classic stack-based buffer overflow vulnerability in C. Built for **Computer Architecture and Assembly Language Programming (20CS22002)**.

**Authors:** K Satya Sai Nischal (`@cattolatte`) and Riyaz Dudekula  
**Institution:** Geethanjali College of Engineering and Technology (B.Tech CSE)

---

## 📖 Overview

This project demonstrates how a stack-based buffer overflow can occur in a deliberately vulnerable C program. By exploiting unsafe string handling through `strcpy()`, the simulation shows how data can overflow a fixed-size buffer, overwrite adjacent memory, and alter program behavior.

By running the simulator with both safe and oversized input, you can observe:

- normal execution with valid input
- memory corruption caused by unchecked copying
- unauthorized state changes through overwritten stack data

This project is intended to help students understand:

- low-level memory behavior
- the risks of insecure string handling in C
- the importance of compiler and runtime protections

---

## ✨ Features

- Focused demonstration of a stack-based buffer overflow
- Vulnerable C program using `strcpy()`
- Python script for payload generation
- Simple `Makefile`-based build workflow
- Suitable for academic demonstrations and lab exercises

---

## 📂 Project Structure

```text
caalp-buffer-simulator/
├── src/
│   ├── vulnerable.c      # Vulnerable C program
│   └── payload_gen.py    # Payload generator script
├── docs/
│   └── report.md         # Supporting documentation/report
├── Makefile              # Build and cleanup commands
├── simulator             # Compiled executable
└── README.md             # Project documentation
```

---

## ⚙️ Prerequisites

To run and test this simulation, ensure the following are installed:

- **GCC** — for compiling the C source code
- **Make** — for build automation
- **Python 3** — for payload generation

---

## 🚀 Getting Started

### Build the Simulator

The project is compiled with stack protection disabled so the overflow behavior can be demonstrated clearly.

```bash
make build
```

This command generates the `simulator` executable.

---

## 💥 Running the Simulation

### 1. Normal Execution

Run the program with a short input string:

```bash
./simulator "Hello"
```

**Expected behavior:**

- the input fits within the 16-byte buffer
- the program executes normally
- `auth_flag` remains unchanged

### 2. Exploit Demonstration

Run the program with a generated oversized payload:

```bash
./simulator "$(python3 src/payload_gen.py)"
```

**Expected behavior:**

- the payload exceeds the 16-byte buffer size
- adjacent stack memory is overwritten
- `auth_flag` is modified
- the hidden logic is triggered successfully

---

## 🧠 How It Works

1. **The vulnerability:** Inside `process_input()`, the program allocates a fixed-size buffer:
   ```c
   char buffer[16];
   ```
2. **The unsafe copy:** The user input is copied using `strcpy()`, which does not check whether the input fits inside the buffer.
3. **The overflow:** If the input is longer than 16 bytes, the extra data spills into adjacent memory.
4. **The overwrite:** The overflow modifies the nearby variable `auth_flag`, changing its value from `0` to a non-zero value.
5. **The effect:** Once `auth_flag` is overwritten, the program behaves as though authorization succeeded and executes the hidden function.

---

## 🎯 Learning Outcomes

This simulator helps illustrate why:

- unchecked memory operations are dangerous
- secure input handling is essential
- modern compiler protections exist
- safer alternatives to insecure C library functions should be preferred

---

## 🧹 Cleanup

To remove the compiled binary, run:

```bash
make clean
```

---

## ⚠️ Disclaimer

This project is intended strictly for **academic and educational purposes**. It is designed to help students understand memory safety issues and secure coding practices in a controlled environment.

Do not use these techniques on systems, applications, or networks without explicit authorization.
