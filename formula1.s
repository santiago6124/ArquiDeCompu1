.text
.global disp_binary
.global delay
.global formula1

formula1:
    MOV     R0, #2
    BL      F1
    B       Termino

F1:
    PUSH {R4, R5, R6, R7, LR}
    MOV     R4, #0x80
    MOV     R5, #1

ForFormula1:
    MOV     R0, R4
    BL      disp_binary
    MOV     R0, R6
    BL      delay
    
    CMP     R4, #0x80
    MOVEQ   R4, #0xC0
    MOVNE   R4, R4, LSR #1

    CMP     R4, #0xFF
    BNE     ForFormula1


Termino:
    POP {R4, R5, R6, R7, PC}
