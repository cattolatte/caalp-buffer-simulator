# CAALP Buffer Overflow Simulator

<p align="center">
  <b>Stack-Based Buffer Overflow Demonstration in Pure 8086 Assembly</b><br>
  <i>Designed for Computer Architecture and Assembly Language Programming (20CS22002)</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/8086-Assembly-blueviolet?style=for-the-badge" alt="8086 Assembly" />
  <img src="https://img.shields.io/badge/CAALP-PBL-success?style=for-the-badge" alt="CAALP PBL" />
  <img src="https://img.shields.io/badge/Academic-Educational-informational?style=for-the-badge" alt="Educational" />
</p>

---

## Overview

This project is an academic simulation of a **stack-based buffer overflow** written in **pure 8086 assembly language**. It was developed as a **Project-Based Learning (PBL)** work for the subject:

**Computer Architecture and Assembly Language Programming (20CS22002)**  
**II Year B.Tech – II Semester**  
**Geethanjali College of Engineering and Technology**

The simulator demonstrates, in a controlled and syllabus-aligned way, how unsafe writing into a **local stack buffer** can corrupt nearby stack data such as the **saved base pointer** and the **return address**, eventually altering program control flow.

Unlike a high-level language demonstration, this project exposes the mechanism directly at the assembly level, making it highly suitable for explaining:

- stack frame organization
- `CALL` and `RET` behavior
- `BP` and `SP` usage
- local variable allocation on stack
- unsafe copying into memory
- return address overwrite
- control-flow hijacking in an educational environment

---

## Academic Purpose

This project is designed around core low-level computing concepts commonly studied in computer architecture and assembly language programming.

It connects strongly with topics such as:

### Control Flow and Program Execution
- procedure call and return behavior
- program control transfer
- instruction flow redirection

### 8086 and Register-Level Operation
- 8086 architecture
- register organization
- assembly language programming
- use of `BP`, `SP`, `IP`, and segment-aware memory access

### Memory and Stack Concepts
- stack organization
- local variable allocation on stack
- addressing through stack-frame offsets
- memory corruption through unsafe writes

### Broader Learning Value
The project helps students visualize how low-level memory and stack behavior affects execution of a program. It bridges theory and implementation by showing how a simple memory overwrite can redirect execution to a different procedure.

---

## Key Idea Demonstrated

The program creates a **4-byte local buffer on the stack** inside a procedure. It then copies **more than 4 bytes** into that buffer. Since the copy exceeds the allocated space, the additional bytes overwrite adjacent stack contents.

This overflow affects:

1. the local buffer
2. the saved `BP`
3. the stored return address

When the procedure executes `RET`, the CPU pops the now-overwritten return address and transfers control to a different function, demonstrating execution flow hijacking.

---

## Features

- Written entirely in **8086 assembly**
- Uses standard **DOS interrupt services**
- Demonstrates **stack frame creation**
- Shows a realistic **local stack buffer overflow style**
- Overwrites the **saved return address**
- Redirects execution to a hidden function
- Designed specifically for **academic explanation and viva presentation**
- Clean and well-commented for student understanding

---

## Project Structure

```text
caalp-buffer-simulator/
├── src/
│   └── vuln.asm         # Main 8086 assembly demonstration
├── docs/
│   └── report.md        # Supporting report/documentation
├── Makefile             # Build/run helper commands
├── simulator            # Built output (if assembled)
└── README.md            # Project documentation
```

---

## How the Demonstration Works

## 1. Normal Procedure Call

The main program calls a vulnerable procedure:

```asm
CALL VULNERABLE_PROC
```

When this executes, the CPU automatically pushes the **return address** onto the stack.

---

## 2. Stack Frame Setup

Inside the vulnerable procedure:

```asm
PUSH BP
MOV  BP, SP
SUB  SP, 4
```

This does three things:

- saves the old base pointer
- establishes a new stack frame
- allocates **4 bytes** of local buffer space

So the stack frame becomes:

```text
[BP+2] -> return address
[BP+0] -> saved BP
[BP-1] -> local buffer byte 4
[BP-2] -> local buffer byte 3
[BP-3] -> local buffer byte 2
[BP-4] -> local buffer byte 1
```

---

## 3. Unsafe Copy

The procedure copies more data than the local buffer can hold.

- First 4 bytes fill the buffer
- Next 2 bytes overwrite saved `BP`
- Final 2 bytes overwrite the return address

This simulates the classic effect of a **stack-based overflow**.

---

## 4. Control Flow Hijack

After the overwrite, the procedure finishes with:

```asm
MOV SP, BP
POP BP
RET
```

At `RET`, the CPU pops the overwritten return address into `IP`, and control jumps to the hidden function instead of returning normally.

---

## Current Assembly File

The main implementation is in:

```text
src/vuln.asm
```

It contains:

- data section with messages and payload bytes
- main procedure
- vulnerable procedure
- secret/hijacked function

---

## Why This Version Is Academically Better

This project originally used a direct manual overwrite of the return address. That was useful, but less realistic.

The updated version is better because it demonstrates:

- an actual **local stack buffer**
- a **copy beyond buffer bounds**
- memory corruption of adjacent stack values
- return-address corruption as a consequence of overflow

This makes the example more suitable for:

- project demonstrations
- report writing
- viva explanations
- syllabus-based justification

---

## Learning Outcomes

By studying this project, a student can understand:

- how stack frames are formed in 8086 assembly
- how `CALL` stores a return address
- how `RET` resumes execution using stack contents
- how local variables may be placed on the stack
- how unsafe writes can corrupt surrounding memory
- how control flow can be redirected by return-address overwrite
- why memory safety matters in low-level programming

---

## Conceptual Alignment

This project is closely aligned with foundational topics in computer architecture and assembly language programming.

It demonstrates:
- procedure handling
- stack layout
- register usage
- memory addressing
- assembly-level control transfer

### Core Concepts Reflected in the Project
- 8086 register organization
- addressing modes
- program control
- call and return instructions
- stack pointer and base pointer usage
- assembly language programming

---

## Build and Execution

This project may be assembled and tested using an **8086-compatible assembler/emulator** such as:

- EMU8086
- DOSBox with MASM/TASM
- similar 16-bit x86 educational tools

### Typical workflow
1. Open `src/vuln.asm`
2. Assemble the source
3. Run the generated executable in DOS environment/emulator
4. Observe the hijacked execution path

---

## Expected Output

When the overflow succeeds, the program should print the hijacked execution message:

```text
Return Address Overwritten - Control Hijacked.
```

If the return path were not corrupted, the normal message would be:

```text
Normal Execution Path Reached.
```

In the current educational setup, the overflow is intentional, so the hijacked path is expected.

---

## Suggested Viva Explanation

A concise explanation for presentation:

> This project demonstrates a stack-based buffer overflow in 8086 assembly. Inside a vulnerable procedure, a 4-byte local buffer is created on the stack using `SUB SP, 4`. More than 4 bytes are then copied into that buffer, which overwrites the saved base pointer and the return address stored by `CALL`. When `RET` executes, the overwritten return address is loaded into the instruction pointer, causing execution to jump to a different function. This shows how unsafe memory writes on the stack can change program control flow.

---

## Professional Notes

- This is an **educational simulation**, not a real-world attack tool.
- The objective is to explain **computer architecture and assembly behavior**, not offensive exploitation.
- The implementation is intentionally simplified so the stack effect can be observed clearly in an academic setting.

---

## Disclaimer

This project is created **strictly for academic and educational purposes** as part of CAALP PBL work.

It should only be used:
- for subject demonstration
- for understanding stack behavior
- for learning secure programming concepts
- in controlled lab or classroom environments

It must not be used against any real system, software, or environment without explicit authorization.

---

## Authors

**K. Satya Sai Nischal**  
GitHub: `@cattolatte`

**Riyaz Dudekula**

---

## Institution

**Geethanjali College of Engineering and Technology**  
Department of Computer Science and Engineering

---

## Final Note

This project is a compact but powerful demonstration of how assembly language, stack organization, and procedure control interact at the hardware-near level. For CAALP, it serves as a strong example of applying 8086 concepts in a practical and memorable way.
