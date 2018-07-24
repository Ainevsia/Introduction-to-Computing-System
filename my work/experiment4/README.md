# Brief introduction
This is a program that will continue printing the `** checkerboard` or the `## checkerboard` until it is interrupted by someone sitting behind the compter hitting a key on the keyboard and changes the pattern of its checkerboard.

# Thoughts
This experiment is not well-illustrated and didn't gave any example input or output as the 3 experiments before and there is some points still seemed obscure to me, so I want to clearify my current understanding of this experiment and make sure the TA who is reading my program will understand what I am doing right away.

As far as I am concerned, once there is an interruption, the interrupt service routine will output the first character that the person types 10 times and the user program should immediately change its pattern of the checkerboard. In my conception, once the first character is typed, the interrupt service routine will stay waiting for the next character and no matter what the next character is, went back to the user program.

And during my debugging, I found that the program can also be interrupted while executing the `TRAP x22` instruction, so the process of the printing of the whole line might haven't complete when interrupted. In the case I mentioned above, my program will print the whole line that was interrupted and then change its checkerboard pattern. The following example is a vivid demonstration of what I have just said.

![ERROR when loading the picture, please see error.png](/error.png)

I also got confused that when storing data into the DDR, it seems that I don't need to set the DSR[15] to 0. If I do so, all the things that I put into the DDR will be put to the screen twice. I just cannot figure out why now and I was really puzzled by that.

![ERROR when loading the picture, please see DDR-draw.png](/DDR-draw.png)

If I do not comment those two blocks, which attempts to change the bit[15] of the DSR from 1 to 0, meaning that after I put a character into the DDR for the display device to print on the screen, the deivce is busy now, the program will end up in a mess.

# How I writed this program
I follow the following routines to produce this program.
1. I started with the user program. First of all, I want to output the basic patterns of the checkerboard. I created 4 string structure, each ending with a `\n`, representing four different lines.
2. Initializing the stack pointer, setting up the keyboard interrupt vector table entry and enableing keyboard interrupts are easy tasks, but to make sure that as soon as the program is interrupted, my program can change the pattern is the most difficult task in the user program.  
I adopted the strategy that ecah time that I am doing to do an output instruction, I will check the register representing the mode the program is in. The interrupt service routine will change that mode at the end of it.
3. The main boby of my user program is two loops, each loop can complete the task of printing two lines of the same pattern.
4. Then I started to get down to the interrupt service routine itself. In the interrupt service routine, I just wrote some polling following the format of the codes in the textbook.

# How to use it

First load the interrupt service routine and then load the user program.

Then it can execute correctly.

# The whole code
> interrupt_service_routine.asm

```asm
.ORIG x2000
ST R0 SAVER0
ST R1 SAVER1
ST R2 SAVER2
ST R3 SAVER3
ST R4 SAVER4
ST R5 SAVER5
AND R5 R5 #0
ADD R5 R5 #10
LD R4 MASK	;R4 MASK CHAR
;the code
LDI R0 KBDR	;R0 CHAR
LDI R1 KBSR	;R1 CONTENT IN KBSR
AND R1 R1 R4
STI R1 KBSR
ENTER	LDI R1 KBSR
BRZP ENTER
AND R1 R1 R4
STI R1 KBSR
LOOP	LDI R2 DSR	;R2 CONTENT IN DSR
BRZP LOOP
STI R0 DDR
;	AND R2 R2 R4
;	STI R2 DSR
ADD R5 R5 #-1
BRP LOOP

LD R0 LF
LOOPL	LDI R2 DSR
BRZP LOOPL
STI R0 DDR
;	AND R2 R2 R4
;	STI R2 DSR

LD R0 SAVER0
LD R1 SAVER1
LD R2 SAVER2
LD R3 SAVER3
LD R4 SAVER4
LD R5 SAVER5
ADD R5 R5 #0
BRZ TOH
AND R5 R5 #0
BRNZP EXIT
TOH	ADD R5 R5 #1
EXIT	RTI

;buffer space as required
LF	.FILL x0A
KBSR	.FILL xFE00
KBDR	.FILL xFE02
DSR	.FILL xFE04
DDR	.FILL xFE06
MASK	.FILL x7FFF
SAVER0	.BLKW 1
SAVER1	.BLKW 1
SAVER2	.BLKW 1
SAVER3	.BLKW 1
SAVER4	.BLKW 1
SAVER5	.BLKW 1
.END
```

> user_program.asm

```asm
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
```
