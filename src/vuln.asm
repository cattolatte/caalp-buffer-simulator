; -----------------------------------------------------------------
; CAALP PBL: Stack-Based Buffer Overflow Demonstration on 8086
; demonstrates how overflowing a local stack buffer
; can overwrite the saved return address and alter control flow.
; -----------------------------------------------------------------

DATA SEGMENT
    ; Messages displayed during normal and hijacked execution paths
    MSG_NORMAL DB 10, 13, 'Normal Execution Path Reached.$'
    MSG_HACKED DB 10, 13, 'Return Address Overwritten - Control Hijacked.$'

    ; Attack data:
    ; 4 bytes fill the local buffer
    ; next 2 bytes overwrite saved BP
    ; final 2 bytes overwrite the return address with SECRET_FUNCTION
    ATTACK_PAYLOAD DB 41H, 42H, 43H, 44H, 55H, 66H
    ATTACK_RETADDR DW SECRET_FUNCTION
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA

START:
    ; Initialize DS for data access
    MOV AX, DATA
    MOV DS, AX

    ; CALL pushes the return address onto the stack
    CALL VULNERABLE_PROC

    ; If no overwrite occurred, execution returns here
    LEA DX, MSG_NORMAL
    MOV AH, 09H
    INT 21H

    ; Terminate program
    MOV AH, 4CH
    INT 21H

; -----------------------------------------------------------------
; VULNERABLE_PROC
; Demonstrates a simple local stack buffer and an unsafe copy loop.
;
; Stack layout after:
;   PUSH BP
;   MOV  BP, SP
;   SUB  SP, 4
;
; [BP+2]   -> return address
; [BP+0]   -> saved BP
; [BP-1]   -> local buffer byte 4
; [BP-2]   -> local buffer byte 3
; [BP-3]   -> local buffer byte 2
; [BP-4]   -> local buffer byte 1
;
; Copying 8 bytes into a 4-byte local buffer causes overwrite of:
; - saved BP
; - return address
; -----------------------------------------------------------------
VULNERABLE_PROC PROC
    PUSH BP
    MOV BP, SP
    SUB SP, 4

    ; SI points to source payload in data segment
    LEA SI, ATTACK_PAYLOAD

    ; DI points to the start of the local buffer on the stack
    LEA DI, [BP-4]

    ; Copy first 6 bytes:
    ; 4 fill local buffer, 2 overwrite saved BP
    MOV CX, 6
COPY_FIRST_PART:
    MOV AL, [SI]
    MOV [DI], AL
    INC SI
    INC DI
    LOOP COPY_FIRST_PART

    ; Copy the final 2 bytes which overwrite the stored return address
    MOV AX, ATTACK_RETADDR
    MOV [DI], AX

    ; Restore stack pointer from BP.
    ; Even though saved BP and return address have been corrupted,
    ; LEAVE-style cleanup still allows RET to use the overwritten address.
    MOV SP, BP
    POP BP
    RET
VULNERABLE_PROC ENDP

; -----------------------------------------------------------------
; SECRET_FUNCTION
; This code executes only because the overwritten return address causes
; RET to jump here instead of back to the normal caller location.
; -----------------------------------------------------------------
SECRET_FUNCTION PROC
    LEA DX, MSG_HACKED
    MOV AH, 09H
    INT 21H

    MOV AH, 4CH
    INT 21H
SECRET_FUNCTION ENDP

CODE ENDS
END START
