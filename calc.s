; A program to compute the sum, difference, and absolute difference of two signed 
; 32-bit numbers.
; Modified code also determines the larger value out of two numbers.

;------Assembler Directives----------------

THUMB						; uses Thumb instructions
		
; Data Variables
AREA    DATA, 	ALIGN=2 	; places objects in data memory (RAM)
EXPORT  SUM	[DATA,SIZE=4]	; export public variable "SUM" for use elsewhere
EXPORT  DIFF 	[DATA,SIZE=4]	; export public variable "DIFF" for use elsewhere
EXPORT  ABS 	[DATA,SIZE=4]	; export public variable "ABS" for use elsewhere
EXPORT	LARGER 	[DATA,SIZE=4]	; export public variable "LARGER" for use elsewhere
SUM	SPACE	4   		; allocates 4 uninitialized bytes in RAM for SUM
DIFF	SPACE	4		; allocates 4 uninitialized bytes in RAM for DIFF
ABS	SPACE	4		; allocates 4 uninitialized bytes in RAM for ABS
LARGER	SPACE	4		; allocates 4 uninitialized bytes in RAM for LARGER

; Code
AREA    |.text|, CODE, READONLY, ALIGN=2	; code in flash ROM
EXPORT  Start			; export public function "start" for use elsewhere
NUM1   	DCD  	-1		; 32-bit constant data NUM1 = -1
NUM2	DCD	2		; 32-bit constant data NUM2 = 2

; -------End of Assembler Directives----------


GET_SUM							; subroutine GET_SUM
		ADD R0, R1, R2				; R0=R1+R2
		LDR R3, =SUM				; R3=&SUM, R3 points to SUM
		STR R0, [R3]				; store the sum of NUM1 and NUM2 to SUM (content of R3)
		BX	LR				; subroutine return
GET_DIFF						; subroutine GET_DIFF
		SUBS R0, R1, R2				; R0=R1-R2
		LDR R3, =DIFF				; R3=&DIFF, R3 points to DIFF
		STR R0, [R3]				; store the difference of NUM1 and NUM2 to DIFF
		BMI	GET_ABS				; check condition code, if N=1 (i.e. the difference is negative), 
							; branch to GET_ABS to calculate the absolute difference
STR_ABS							; label STR_ABS, store the absolute difference (ignore if N=0)
		LDR R3, =ABS				; R3=&ABS, R3 points to ABS
		STR R0, [R3]				; store the absolute difference to ABS
		BX	LR				; subroutine return
GET_ABS							; label GET_ABS, calculate the absolute difference if the difference is negative
		RSB	R0, R0, #0			; R0=0-R0; reverse subtract without carry
		B	STR_ABS				; branch to STR_ABS to store the result
GET_LARGER						; subroutine GET_LARGER
		CMP R1, R2				; checks status flags for  NUM1 - NUM2
		MOVGE R0, R1				; if NUM1>=NUM2, copy NUM1 to R0 (when [N==V])
		MOVLT R0, R2				; if NUM1<NUM2, copy NUM2 to R0 (when Z or [N != V])
		LDR R3, =LARGER				; R3=&LARGER, R3 points to LARGER
		STR R0, [R3]				; store value in R0 to the content of R3 (LARGER)
		BX LR					; branches to address given by LR and switches instruction set (ARM/Thumb)
		
		
		

Start	LDR R1, NUM1					; R1=NUM1
		LDR R2,	NUM2				; R2=NUM2
		BL	GET_SUM
		BL	GET_DIFF
		BL	GET_LARGER

		ALIGN                       		; make sure the end of this section is aligned
		END                         		; end of file
