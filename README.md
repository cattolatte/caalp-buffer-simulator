# CAALP Buffer Overflow Simulator

<p align="center">
  <b>Stack-Based Buffer Overflow Demonstration in Pure 8086 Assembly</b><br>
  <i>An educational low-level memory and control-flow simulation built for project-based academic study.</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/8086-Assembly-6f42c1?style=for-the-badge" alt="8086 Assembly" />
  <img src="https://img.shields.io/badge/Project-Academic-0a7ea4?style=for-the-badge" alt="Academic Project" />
  <img src="https://img.shields.io/badge/Focus-Stack%20Internals-1f883d?style=for-the-badge" alt="Stack Internals" />
  <img src="https://img.shields.io/badge/Domain-Computer%20Architecture-24292f?style=for-the-badge" alt="Computer Architecture" />
</p>

---

## Overview

`CAALP Buffer Overflow Simulator` is a compact but detailed educational project that demonstrates how a **stack-based buffer overflow** can affect **program control flow** at the assembly level.

The entire core demonstration is written in **pure 8086 assembly**, allowing the behavior of the stack, procedure calls, return addresses, and memory overwrites to be observed in a direct and low-level form.

The project focuses on a classic idea in systems programming:

- a procedure allocates a small local buffer on the stack
- more data is written than the buffer can hold
- nearby stack values are corrupted
- the saved return address is overwritten
- execution returns to an unintended target

This makes the project useful for understanding the relationship between:

- stack memory layout
- procedure call mechanics
- register usage
- addressing through `BP`/`SP`
- unsafe memory writes
- instruction flow redirection

---

## What This Project Demonstrates

At a conceptual level, the simulator shows how a small mistake in stack-based memory handling can lead to major changes in execution behavior.

### Core ideas covered
- **8086 procedure call and return flow**
- **stack frame construction**
- **base pointer and stack pointer usage**
- **local buffer allocation on the stack**
- **overflow into adjacent control data**
- **return-address overwrite**
- **control-flow hijacking through `RET`**

Instead of explaining the idea only theoretically, the project demonstrates it step by step in assembly code.

---

## Why the Assembly Version Matters

A high-level language version can show the effect of an overflow, but assembly makes the mechanism much clearer.

With this project, you can directly see:

- where the buffer lives
- where the saved `BP` is stored
- where the return address is stored
- which bytes overflow first
- how `RET` uses the overwritten address

Because everything happens close to the machine level, the project is particularly useful for students studying:

- computer architecture
- assembly language programming
- stack-based procedure handling
- memory organization
- low-level execution flow

---

## Repository Structure

The repository now contains only the files relevant to the assembly-based version of the project.

```text
caalp-buffer-simulator/
├── README.md
└── src/
    └── vuln.asm
```

### File descriptions

#### `src/vuln.asm`
The main 8086 assembly source file.

It contains:
- the data segment
- the main execution path
- the vulnerable procedure
- the crafted overflow logic
- the redirected execution target

#### `README.md`
The main project documentation for the repository.

---

## Technical Model of the Demonstration

The program simulates a stack-based overflow using a small local stack buffer inside a procedure.

### Procedure prologue
Inside the vulnerable procedure, the stack frame is set up using:

```asm
PUSH BP
MOV  BP, SP
SUB  SP, 4
```

This creates a local buffer of **4 bytes** on the stack.

### Stack layout

After the procedure prologue, the stack frame can be understood as:

```text
[BP+2] -> stored return address
[BP+0] -> saved BP
[BP-1] -> local buffer byte 4
[BP-2] -> local buffer byte 3
[BP-3] -> local buffer byte 2
[BP-4] -> local buffer byte 1
```

### Overflow behavior

The copy logic writes more than 4 bytes into this local buffer.

That means:
- the first bytes fill the buffer correctly
- the next bytes overwrite saved `BP`
- the final bytes overwrite the return address

When the procedure ends and `RET` executes, the overwritten return address is popped into the instruction pointer, causing control to jump to another procedure.

---

## Execution Flow Summary

The overall demonstration follows this sequence:

1. The main program initializes the data segment.
2. It calls the vulnerable procedure.
3. The vulnerable procedure builds a stack frame.
4. A local buffer is allocated on the stack.
5. More bytes are copied than the buffer can safely hold.
6. The saved frame data and return address are corrupted.
7. The procedure restores state and executes `RET`.
8. `RET` transfers execution to the overwritten target instead of the normal caller continuation.
9. The hijacked function prints the success message and exits.

---

## Conceptual Areas Reflected in the Project

This project naturally connects with several important low-level programming and architecture concepts.

### Procedure and control-flow behavior
- `CALL`
- `RET`
- return-address storage
- control transfer

### Register-level reasoning
- `BP`
- `SP`
- `AX`
- `SI`
- `DI`
- segment-aware memory use

### Addressing and memory access
- stack-relative addressing
- `[BP-4]`
- `[BP+2]`
- offset-based access within a frame

### Memory organization
- local stack variables
- adjacent memory corruption
- structured frame layout

### Assembly programming practice
- segmented program structure
- DOS interrupt usage
- low-level procedural design
- explicit data movement and control

---

## Expected Output

In the current educational setup, the overflow is intentional, so the hijacked path is the expected result.

### Hijacked execution path
```text
Return Address Overwritten - Control Hijacked.
```

### Normal execution path
If the return address were not corrupted, the program would continue normally and display:

```text
Normal Execution Path Reached.
```

---

## How to Study This Project Effectively

A good way to understand the simulator is to read it in the following order:

### 1. Start at `START`
See how the data segment is initialized and how the vulnerable procedure is called.

### 2. Move to `VULNERABLE_PROC`
Observe:
- stack frame setup
- local buffer creation
- pointer initialization
- copy logic

### 3. Track the stack layout
Pay attention to:
- `BP`
- `SP`
- the meaning of `[BP-4]`, `[BP+0]`, and `[BP+2]`

### 4. Follow the overflow
Notice how writing more bytes than allocated causes the overwrite to move upward into stack control data.

### 5. Observe `RET`
Understand that `RET` does not “know” the address is corrupted; it simply trusts the stack and transfers control there.

---

## Educational Value

This project is useful because it turns a commonly discussed vulnerability into a visible low-level execution model.

### It helps explain:
- why stack discipline matters
- how return addresses are stored and used
- why unsafe writes are dangerous
- how memory corruption can alter execution
- how architecture concepts connect to real program behavior

### It is especially valuable for:
- low-level systems discussions
- understanding assembly procedure design
- relating theory to execution flow

---

## Notes on Design

This project is intentionally designed to be:

- **compact** enough to study easily
- **explicit** enough to trace manually
- **low-level** enough to show actual stack mechanics
- **structured** enough for clear technical documentation

The code is simplified intentionally so the central ideas remain clear and observable.

---

## Tools for Running the Code

The assembly source can be assembled and tested using 8086-oriented educational tools such as:

- **EMU8086**
- **DOSBox + MASM/TASM**
- other compatible 16-bit x86 emulators or assemblers

A typical process is:

1. open `src/vuln.asm`
2. assemble the file
3. run the executable in the emulator
4. observe the redirected output path

---

## Disclaimer

This repository is intended **strictly for academic and educational use**.

Its purpose is to:
- explain low-level memory behavior
- study stack-based procedure execution
- illustrate the consequences of unsafe writes
- support learning in controlled environments

It is not intended as an offensive security tool, and it should not be used against real systems or software without explicit authorization.

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

## Closing Note

This project is a focused demonstration of how assembly language, stack organization, and procedure control interact at the machine-near level. By reducing the example to a clean 8086 implementation, it becomes easier to understand not just that a buffer overflow can happen, but exactly **how** it affects execution internally.
