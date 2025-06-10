.text
.global disp_binary
.global delay
.global formula1

formula1:
    PUSH    {R4-R7, LR}
    LDR     R6, =3000000
    MOV     R4, #0x80
    MOV     R5, #2

ForFormula1:
    MOV     R0, R4
    BL      disp_binary
    MOV     R0, R6
    BL      delay

    MOV     R0, R4
    MOV     R1, R5
    BL      div
    ADD     R4, R4, R0

    LSL     R5, R5, #1
    ADD     R5, R5, #2

    CMP     R5, #512
    BLT     ForFormula1

    POP     {R4-R7, PC}

div:
    PUSH    {R2-R3, LR}
    MOV     R2, #0
    MOV     R3, R0

div_loop:
    CMP     R3, R1
    BLT     div_end
    SUB     R3, R3, R1
    ADD     R2, R2, #1
    B       div_loop

div_end:
    MOV     R0, R2
    POP     {R2-R3, PC}
