//============== SECCIÓN DE DATOS ===============================================
.data
    .balign 4

// String de instrucciones para la función formula1
formula1_instructions_string:
    .asciz "Has elegido la Función de Fórmula 1 (ASM v2):\n\n(Para salir pulsa la tecla 'q'. Para cambiar la velocidad, con las flechas)\n\n"

// Strings y constantes reutilizadas
clear_command:
    .asciz "clear"
KEY_UP_val:
    .word 259
KEY_DOWN_val:
    .word 258


//============== SECCIÓN DE CÓDIGO ===============================================
.text
// --- EXPORTAMOS ---
.global formula1
.global div

// --- IMPORTAMOS ---
.extern manejar_teclado
.extern delay, disp_binary, initscr, keypad, nodelay, noecho
.extern mvprintw, refresh, endwin, system, stdscr

formula1:
    PUSH    {R4-R6, LR}         // Guardamos registros de estado y el Link Register

    // --- 1. Inicialización de Ncurses (con la corrección del puntero stdscr) ---
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

    // --- 2. Imprimir instrucciones en pantalla ---
    MOV     R0, #0
    MOV     R1, #0
    LDR     R2, =formula1_instructions_string
    BL      mvprintw
    BL      refresh

    // --- 3. Inicialización de variables de la animación ---
    LDR     R6, =500            // R6 = on_time (delay inicial de 500ms)
    
MainLoop:
    // Resetea las variables del algoritmo para cada nueva animación
    MOV     R4, #0x80           // R4 = output (variable principal de la animación)
    MOV     R5, #2              // R5 = i (divisor del algoritmo)

ForFormula1:
    // Condición de fin del algoritmo
    CMP     R5, #512
    BGE     MainLoop            // Si termina, la animación vuelve a empezar

    // Muestra el estado actual
    MOV     R0, R4
    BL      disp_binary

    // Aplica el delay
    MOV     R0, R6
    BL      delay

    // --- 4. Comprobación de Teclado via Función de Ayuda en C ---
    SUB     SP, SP, #4          // 1. Hacemos espacio en la pila para on_time
    STR     R6, [SP]            // 2. Guardamos el valor de R6 (on_time) en la pila
    
    MOV     R0, SP              // 3. R0 = Puntero a on_time
    MOV     R1, #100            // 4. R1 = step (100 para f1)
    MOV     R2, #200            // 5. R2 = min_time (200 para f1)
    MOV     R3, #1000           // 6. R3 = max_time (1000 para f1)

    BL      manejar_teclado     // 7. Llamamos a la función de ayuda en C

    LDR     R6, [SP]            // 8. Recuperamos el valor de on_time desde la pila a R6
    ADD     SP, SP, #4          // 9. Limpiamos la pila

    // Comprobamos el valor de retorno para ver si hay que salir
    CMP     R0, #1
    BEQ     Quit

AlgorithmUpdate:
    // --- 5. Ejecución del Algoritmo de formula1 ---
    MOV     R0, R4
    MOV     R1, R5
    BL      div
    ADD     R4, R4, R0
    LSL     R5, R5, #1
    ADD     R5, R5, #2
    B       ForFormula1         // Vuelve al inicio del bucle del algoritmo

Quit:
    // --- 6. Limpieza y Salida ---
    POP     {R4-R6, PC}         // Restaura registros y retorna al menú en C

//=============================================================================
// SUBRUTINA DE DIVISIÓN ENTERA (Necesaria para formula1)
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
//=============================================================================
