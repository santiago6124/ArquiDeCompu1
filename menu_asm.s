.global menu_asm
menu_asm:
    PUSH    {R4-R7, LR}
    
    LDR     R0, =menu_str
    BL      printf
    
    LDR     R0, =input_format
    LDR     R1, =input_buffer
    BL      scanf
    
    LDR     R0, =input_buffer
    LDR     R0, [R0]
    
    CMP     R0, #1
    BEQ     case1
    CMP     R0, #2
    BEQ     case2
    CMP     R0, #3
    BEQ     case3
    CMP     R0, #4
    BEQ     case4
    CMP     R0, #5
    BEQ     case5
    B       default_case
    
case1:
    BL      autofantastico
    B       end_switch
    
case2:
    BL      choque
    B       end_switch
    
case3:
    BL      formula1
    B       end_switch
    
case4:
    BL      colision_asm
    B       end_switch
    
case5:
    MOV     R0, #0
    BL      exit
    
default_case:
    LDR     R0, =invalid_option
    BL      printf
    
end_switch:
    POP     {R4-R7, PC}

    .data
menu_str:
    .asciz  "\n   MENU  \n1) Auto Fantastico\n2) Choque\n3) Formula 1\n4) Colisión al Centro\n5) Salir\nElija su opcion: "
input_format:
    .asciz  "%d"
input_buffer:
    .word   0
invalid_option:
    .asciz  "Opcion no valida\n" 
    