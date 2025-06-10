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
    UDIV    R0, R0, R1      
    BX      LR     
             