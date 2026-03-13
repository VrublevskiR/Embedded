    .global _start

_start:
    MOV     r0, #2      // repeat
    MOV     r1, #2      // x
    MOV     r2, #3      // y 

    BL      calculate

    MOV     r7, #1
    SVC     #0

calculate:
    PUSH    {r4, r5, r6, r7}

    MOV     r3, #10            // max 
    MOV     r4, #0             // res
    MOV     r5, #0             // i

.loop_start:
    CMP     r5, r0
    BGE     .Lloop_end         // if i >= repeat

    ADD     r6, r1, r2         // x + y
    MUL     r7, r1, r2         // x * y

    ADD     r4, r4, r6         // res += sum
    ADD     r4, r4, r7         // res += mul

    CMP     r6, r3           
    
    MOVLT   r1, r6             // if (sum < max)
    MOVGE   r1, r3             // if (sum >= max)

    ADD     r5, r5, #1         // i++
    B       .loop_start      

    
.Lloop_end:
		
    MOV     r0, r4             
    POP     {r4, r5, r6, r7}
    BX      lr                 

