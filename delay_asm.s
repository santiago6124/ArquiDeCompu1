.global delay_asm
delay_asm:
    PUSH    {R4, LR}
    MOV     R4, R0          // Save delay time in R4
    
delay_loop:
    SUBS    R4, R4, #1      // Decrement counter
    BNE     delay_loop      // If not zero, continue loop
    
    POP     {R4, PC}        // Return from subroutine 
    