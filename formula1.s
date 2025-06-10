.data
    .balign 4

formula1_instructions_string:
    .asciz "Has elegido la Función de Fórmula 1 (ASM v2):\n\n(Para salir pulsa la tecla 'q'. Para cambiar la velocidad, con las flechas)\n\n"

clear_command:
    .asciz "clear"
KEY_UP_val:
    .word 259
KEY_DOWN_val:
    .word 258

.text
.global formula1
.global div

.extern manejar_teclado
.extern delay, disp_binary, initscr, keypad, nodelay, noecho
.extern mvprintw, refresh, endwin, system, stdscr

formula1:
    PUSH    {R4-R6, LR}

    BL      initscr
    LDR     R0, =stdscr
    LDR     R0, [R0]
    MOV     R1, #1
    BL      keypad
    LDR     R0, =stdscr
    LDR     R0, [R0]
    MOV     R1, #1
    BL      nodelay
    BL      noecho

    MOV     R0, #0
    MOV     R1, #0
    LDR     R2, =formula1_instructions_string
    BL      mvprintw
    BL      refresh

    LDR     R6, =500
    
MainLoop:
    MOV     R4, #0x80
    MOV     R5, #2

ForFormula1:
    CMP     R5, #512
    BGE     MainLoop

    MOV     R0, R4
    BL      disp_binary

    MOV     R0, R6
    BL      delay

    SUB     SP, SP, #4
    STR     R6, [SP]
    
    MOV     R0, SP
    MOV     R1, #100
    MOV     R2, #200
    MOV     R3, #1000

    BL      manejar_teclado

    LDR     R6, [SP]
    ADD     SP, SP, #4

    CMP     R0, #1
    BEQ     Quit

AlgorithmUpdate:
    MOV     R0, R4
    MOV     R1, R5
    BL      div
    ADD     R4, R4, R0
    LSL     R5, R5, #1
    ADD     R5, R5, #2
    B       ForFormula1

Quit:
    POP     {R4-R6, PC}

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
