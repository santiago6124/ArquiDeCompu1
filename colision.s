//============== SECCIÓN DE DATOS ===============================================
.data
    .balign 4

// Patrones, strings y constantes (sin cambios)
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


//============== SECCIÓN DE CÓDIGO ===============================================
.text
// --- EXPORTAMOS ---
.global colision_asm

// --- IMPORTAMOS ---
// ¡Añadimos nuestra nueva función de ayuda a la lista!
.extern manejar_teclado
.extern delay, disp_binary, initscr, keypad, nodelay, noecho
.extern mvprintw, refresh, endwin, system, stdscr

colision_asm:
    // Solo necesitamos guardar R4, R5, R6 ahora
    PUSH    {R4-R6, LR}

    // --- 1. Inicialización de Ncurses (CON LA CORRECCIÓN del puntero stdscr) ---
    BL      initscr
    LDR     R0, =stdscr         // Carga la DIRECCIÓN de stdscr
    LDR     R0, [R0]            // Carga el VALOR (el puntero real)
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
    LDR     R2, =instructions_string
    BL      mvprintw
    BL      refresh

    // --- 3. Inicialización de variables de la animación ---
    LDR     R4, =patrones       // R4 = Puntero al array de patrones
    LDR     R6, =200            // R6 = on_time (delay inicial de 200ms)
    
MainLoop:
    MOV     R5, #0              // R5 = i (contador del bucle de animación)

AnimationStep:
    CMP     R5, #8
    BGE     MainLoop

    // Carga y muestra el patrón
    LDRB    R0, [R4, R5]
    BL      disp_binary

    // Aplica el delay
    MOV     R0, R6
    BL      delay

    // --- 4. Comprobación de Teclado via Función de Ayuda en C ---
    
    // Preparar la llamada a manejar_teclado(int *on_time, int step, int min, int max)
    SUB     SP, SP, #4          // 1. Hacemos espacio en la pila para on_time
    STR     R6, [SP]            // 2. Guardamos el valor de R6 (on_time) en la pila
    
    MOV     R0, SP              // 3. R0 = Puntero a on_time (la dirección de la pila)
    MOV     R1, #20             // 4. R1 = step (20)
    MOV     R2, #20             // 5. R2 = min_time (20)
    MOV     R3, #500            // 6. R3 = max_time (500)

    BL      manejar_teclado     // 7. Llamamos a la función de ayuda en C

    LDR     R6, [SP]            // 8. Recuperamos el valor de on_time desde la pila a R6
    ADD     SP, SP, #4          // 9. Limpiamos la pila

    // Ahora, comprobamos el valor de retorno de la función
    CMP     R0, #1              // ¿La función devolvió true (1)?
    BEQ     Quit                // Si es así, significa que se presionó 'q', así que salimos.

    // Si no salimos, continuamos la animación
    ADD     R5, R5, #1          // i++
    B       AnimationStep

Quit:
    // --- 5. Limpieza y Salida ---
    // 'endwin' y 'system("clear")' ahora se llaman dentro de 'manejar_teclado',
    // por lo que no es estrictamente necesario llamarlos de nuevo aquí.
    // La función simplemente puede terminar.

    // --- Epílogo ---
    POP     {R4-R6, PC}         // Restaura registros y retorna al menú en C
    