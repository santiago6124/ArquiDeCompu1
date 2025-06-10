.text
.global colision_asm

colision_asm:
    PUSH    {R4-R7, LR}
    
    MOV     R4, #0x81    
    MOV     R5, #0xC3    
    MOV     R6, #0xE7
    MOV     R7, #0xFF    
    
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
    