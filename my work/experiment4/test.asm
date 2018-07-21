	.ORIG x3000

;initialize the stack pointer
HERE	LEA R6 HERE

;set up the keyboard interrupt vector table entry
	LD R0 ISR
	STI R0 INTVADD

;enable keyboard interrupts
	LD R0 MASK
	STI R0 KBSR

;start of actual user program to print the checkerboard
	AND R5 R5 #0	;PRINT STAR IF R5 = 0
	
S	LEA R0 SSP
	ADD R5 R5 #0
	BRP H
	TRAP x22
	JSR DELAY
	LEA R0 SPS
	ADD R5 R5 #0
	BRP H
	TRAP x22
	JSR DELAY
	BRNZP S

H	LEA R0 HSP
	ADD R5 R5 #0
	BRZ S
	TRAP x22
	JSR DELAY
	LEA R0 SPH
	ADD R5 R5 #0
	BRZ S
	TRAP x22
	JSR DELAY
	BRNZP H

INTVADD	.FILL x0180
ISR	.FILL x2000
MASK	.FILL x4000
KBSR	.FILL xFE00
SSP	.STRINGZ "**    **    **    **    **    **    **    **    \n"
SPS	.STRINGZ "   **    **    **    **    **    **    **    \n"
HSP	.STRINGZ "##    ##    ##    ##    ##    ##    ##    ##    \n"
SPH	.STRINGZ "   ##    ##    ##    ##    ##    ##    ##    \n"

DELAY	ST R1 SAVER1
	LD R1 COUNT
REP	ADD R1 R1 #-1
	BRP REP
	LD R1 SAVER1
	RET
COUNT	.FILL #2500
SAVER1	.BLKW 1

	.END