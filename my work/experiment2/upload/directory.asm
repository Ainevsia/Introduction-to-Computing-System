	.ORIG x3000
AGAIN	LEA R0 PROMPT	;output the prompt
	TRAP x22
	LEA R4 INPUT	;R4 tests whether the user prints more than 10 characters
	AND R5 R5 #0
READ	TRAP x20
	TRAP x21	;echo
	ADD R5 R5 #1
	STR R0 R4 #0
	ADD R4 R4 #1
	ADD R0 R0 #-10
	BRNP READ
	ADD R4 R4 #-1
	STR R0 R4 #0
	ADD R5 R5 #-1
	BRZ AGAIN	;when there is no input(only <Enter>), print the prompt again for input
	ADD R5 R5 #-9
	BRP ERROR	;when there is more than 10 characters, the program output a warning and end

	LD R1 HEAD
LOOP	LDR R1 R1 #0
	BRZ NFOUND
	ADD R2 R1 #1	;R2 points to ROOM NUMBER
	ADD R3 R1 #2	;R3 points to NAME
	LDR R0 R2 #0
	;
	LEA R4 INPUT
	LDR R2 R2 #0
COMPARE	LDR R5 R2 #0
	LDR R6 R4 #0
	LD R7 L
	ADD R7 R7 R5
	BRN STEP1
	LD R7 U
	ADD R7 R7 R5
	BRP STEP1
	LD R7 UTL
	ADD R5 R5 R7

;step 1 and 2 are designed to change the capital letters into lower-case letters
STEP1	LD R7 L
	ADD R7 R7 R6
	BRN STEP2
	LD R7 U
	ADD R7 R7 R6
	BRP STEP2
	LD R7 UTL
	ADD R6 R6 R7
STEP2	NOT R7 R6
	ADD R7 R7 #1
	ADD R7 R5 R7
	BRNP LOOP
	LDR R6 R4 #0
	BRZ FOUND
	ADD R2 R2 #1
	ADD R4 R4 #1
	BRNZP COMPARE
	BRNZP LOOP

;the following 3 blocks are specified for result outputs
ERROR	LEA R0 MORE
	TRAP x22
	TRAP x25
FOUND	LDR R0 R3 #0
	TRAP x22
	TRAP x25
NFOUND	LEA R0 NOENTRY
	TRAP x22
	TRAP x25

;the following lines are for program preparations
PROMPT	.STRINGZ "Type a room number and press Enter:"
NOENTRY	.STRINGZ "No Entry"
MORE	.STRINGZ "You have entered more than 10 characters!"
LF	.FILL x0A	;the ASCII code for <Enter>
HEAD	.FILL x3300	;the address of the first pointer
UTL	.FILL x20	;change capital letters into lower-case letters
L	.FILL x-41	;to test whether it is a captial letter
U	.FILL x-5A	;to test whether it is a lower-case letter
INPUT	.BLKW #11	;counter for input characters
	.END