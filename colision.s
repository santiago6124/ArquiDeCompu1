.data
    .balign 4

patrones:
    .byte   0x81, 0xC3, 0xE7, 0xFF, 0xE7, 0xC3, 0x81, 0x00
instructions_string:
    .asciz "Has elegido la Función de Colisión al Centro (ASM v2):\n\n(Para salir pulsa la tecla 'q'. Para cambiar la velocidad, con las flechas)\n\n"
clear_command:
    .asciz "clear"
KEY_UP_val:
    .word 259
KEY_DOWN_val:
    .word 258

.text
.global colision_asm

.extern manejar_teclado
.extern delay, disp_binary, initscr, keypad, nodelay, noecho
.extern mvprintw, refresh, endwin, system, stdscr

colision_asm:
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
    LDR     R2, =instructions_string
    BL      mvprintw
    BL      refresh

    LDR     R4, =patrones
    LDR     R6, =200
    
MainLoop:
    MOV     R5, #0

AnimationStep:
    CMP     R5, #8
    BGE     MainLoop

    LDRB    R0, [R4, R5]
    BL      disp_binary

    MOV     R0, R6
    BL      delay
    
    SUB     SP, SP, #4
    STR     R6, [SP]
    
    MOV     R0, SP
    MOV     R1, #20
    MOV     R2, #20
    MOV     R3, #500

    BL      manejar_teclado

    LDR     R6, [SP]
    ADD     SP, SP, #4

    CMP     R0, #1
    BEQ     Quit

    ADD     R5, R5, #1
    B       AnimationStep

Quit:
    POP     {R4-R6, PC}
    