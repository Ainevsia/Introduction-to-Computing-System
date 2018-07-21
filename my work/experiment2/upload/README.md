# Brief introduction
First of all I must apologize that I have added some features that are not required in the pdf, such as changing the letters into the lowercase regardless of its original form, counting the number of characters that the user types and reprintint the prompt if the user only type a key x0A(Enter), in an attempt to adding to my program more robustness. This makes my code looks extremely longer than others'. But since removing those related codes will take me another one or two hours and they don't influence the essential function, so I decided to keep them, at a cost of the lower possibility of another person to read my code through and understand what I'm actually doing.

The code also looks differently in this README compared with what it looks like in my LC3Edit, which is perfectly aligned and clearly shows the comments parts, the label parts and the instrucion parts. I feel very sorry for that.

# How I writed this program
I follow the common routines to produce a program.
1. First I should print a prompt on the screen asking for the user to type in the room number. I use the instruction `TRAP x22` in the assistant of the pseudo-op `.STRINGZ "Type a room number and press Enter:"`
2. then read in the characters the user type in one by one, forming a room number string. The READ process ends here.
3. Following it is a loop which will examine the list one by one, checking whether there is a room that perfectly fits in the room number that the user has typed.
    - during each loop, the room string in the node of a list that the pointer points to is compared with the string that I created in the READ process.
    - If the two strings are exactly the same, I know I have done the job and I should goto the outprint process.
    - If not, points to the next node in that list and repeat again, until I find or I come to the end of the list.
4. In the output process, output the corresponding string in accordence with the result mentioned above.

# How to use it
As is required in the pdf, after loading the directory.asm into the LC3 Simulator, a file which strictly follows the requirement should also be loaded and only then can my program work properly and give out the right outputs.

# The whole code
```asm
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
```
