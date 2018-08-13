;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;----- Your Sorting lab starts here -------------------------------------------
;Memory allocation of Arrays must be done before the RESET and StopWDT
ARY1	 .set 	 0x0200 ;Memory allocation ARY1
ARY1S	 .set	 0x0210 ;Memory allocation ARYS
ARY2 	 .set	 0x0220 ;Memory allocation ARY2
ARY2S	 .set	 0x0230 ;Memory allocation AR2S
		clr	 	R4 ;clearing all register being use is a good
		clr 	R5 ;programming practice
		clr 	R6
SORT1   mov.w #ARY1, R4 ;initialize R4 as a pointer to array1
		mov.w #ARY1S, R6 ;initialize R4 as a pointer to array1 sorted
		call #ArraySetup1;then call subroutine ArraySetup1
		call #COPY ;Copy elements from ARY1 to ARY1S space
		call #SORT ;Sort elements in ARAY1
SORT2	mov.w #ARY2, R4 ;initialize R4 as a pointer to array2
		mov.w #ARY2S, R6 ;initialize R4 as a pointer to array2 sorted
		call #ArraySetup2;then call subroutine ArraySetup2
		call #COPY ;Copy elements from ARY2 to ARY2S space
		call #SORT ;Sort elements in ARAY2

Mainloop jmp Mainloop ;Infinite Loop

ArraySetup1 mov.b #10, 0(R4) ; Array element initialization Subroutine
			mov.b #17, 1(R4) ;First start with the number of elements
			mov.b #75, 2(R4) ;and then fill in the 10 elements.
			mov.b #-67, 3(R4)
			mov.b #23, 4(R4)
			mov.b #36, 5(R4)
			mov.b #-7, 6(R4)
			mov.b #44, 7(R4)
			mov.b #8, 8(R4)
			mov.b #-74, 9(R4)
			mov.b #18, 10(R4)
			ret

ArraySetup2 mov.b #10, 0(R4)
			mov.b #54, 1(R4)
			mov.b #-4, 2(R4)
			mov.b #-23, 3(R4)
			mov.b #-19, 4(R4)
			mov.b #-72, 5(R4)
			mov.b #-7, 6(R4)
			mov.b #36, 7(R4)
			mov.b #62, 8(R4)
			mov.b #0, 9(R4)
			mov.b #39, 10(R4) ;Similar to ArraySetup1 subroutine
			ret

COPY 		mov.b	@R4, R5
			mov.w	R6, R7
			incd.b	R5
loop		mov.w	@R4+, 0(R6)
			incd.b	R6
			decd.b	R5
			jnz		loop
			ret		  ;Copy original Array to allocated Arrayret


SORT 		mov.b	@R6+, R5   ;R5 = n
			mov.w	R5, R11		;R11 is inner loop counter = n
outer		mov.b	R6, R7		;R6 is beginning of array, store in R7
inner		dec.b	R11			;decrement counter
			jz		done		; if we are at end of array, finish
			mov.w	R7,	R8
			inc.w	R7
			mov.w	R7,R9
			cmp.b	@R9, 0(R8)     
			jl		inner      ; if R8 is less than R9 do nothing and loop
			call	#swapnum
			mov.b	R5, R11
			jmp		outer
done		ret

swapnum		mov.b	@R9, R10
			mov.b	@R8, 0(R9)
			mov.b	R10, 0(R8)
			ret


;----- Your Sorting lab ends here -------------------------------------------
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
