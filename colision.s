.text
.global colision_asm

colision_asm:
    PUSH    {R4-R7, LR}
    
    // Initialize registers for LED pattern
    MOV     R4, #0x81    // Start with outer LEDs
    MOV     R5, #0xC3    // Next pattern
    MOV     R6, #0xE7    // Next pattern
    MOV     R7, #0xFF    // Full pattern
    
    // Stack to center
    MOV     R0, R4
    BL      disp_binary
    BL      delay_asm
    
    MOV     R0, R5
    BL      disp_binary
    BL      delay_asm
    
    MOV     R0, R6
    BL      disp_binary
    BL      delay_asm
    
    MOV     R0, R7
    BL      disp_binary
    BL      delay_asm
    
    // Wipe out from center
    MOV     R0, R6
    BL      disp_binary
    BL      delay_asm
    
    MOV     R0, R5
    BL      disp_binary
    BL      delay_asm
    
    MOV     R0, R4
    BL      disp_binary
    BL      delay_asm
    
    MOV     R0, #0x00
    BL      disp_binary
    BL      delay_asm
    
    POP     {R4-R7, PC} 
    