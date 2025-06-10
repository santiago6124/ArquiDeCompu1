.global delay_asm
delay_asm:
    PUSH    {R4, LR}
    MOV     R4, R0         
    
delay_loop:
    SUBS    R4, R4, #1      
    BNE     delay_loop      
    
    POP     {R4, PC}        
    