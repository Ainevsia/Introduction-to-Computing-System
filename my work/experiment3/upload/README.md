# Brief introduction
First of all I must apologize that the code looks differently in this README compared with what it looks like in my LC3-Edit, which is perfectly aligned and clearly shows the comments parts, the label parts and the instrucion parts. Forgive me because I am too lazy to realign all the stuff in this README, that will certainly drive me crazy and I think that sine I have submitted the `.asm` file together in the ZIP package, I believe you can refer to that file for a better experience while reading my codes.

I know that my solution to this specified problem can't be the easiest or the most simple solution, and I may have used some stupid routines to implement some rather easy functions without my own awareness, so I really thanks the TA who is certainly one of the most patient persons in this world to read my program.

# How I writed this program
I follow the following routines to produce this program.
1. The first thing I thought about is how to display this board. During the process of coding, I put this function into a subroutine called `PBOARD` (print the board). In this subroutine, it calls another two services, ie. another two subroutines: `PROW` (print the row) & `PSTONE` (print the stones).
 - `PROW` prints the sting: "ROW ?: "
 - `PSTONE` prints the sting: "ooo...oo"

 By calling these two subroutines, I can print a line. By printing the whole three lines, I can print the whole board, and that's all about what the PBOARD function does.

2. The next thing that I thought about is how to check whether the input is valid or not. I break this task into two parts:
 - First check the first input character to see whether it is an A, B or C. Or other invalid situations.
 - Then check the second input character to see whether it is smaller than 1 or larger than the current number of stones in the specified row as is declared in the above step.

3. Once the checking task is completed and the input is a valid one, it comes to the next stage. I updae the current board, reprint it onto the screen and finally check whether there is no stones on the board yet.

4. If there is no stone left, then the game is over. If not, shift the player and start another loop.
# How to use it

Load the program into the LC3 Simulator and start it.

Then you can follow the instrucions displayed on the console and enjoy a nice game. It's that easy.

# The whole code
```asm
.ORIG x3000
;Initialization R0 R1 R2 R3 R4
AND R0 R0 #0	;R0 used for I/O and other parameters
AND R1 R1 #0	;R1 used for contain the stone number in row A, available to all subroutines
AND R2 R2 #0	;R2 used for contain the stone number in row B, available to all subroutines
AND R3 R3 #0	;R3 used for contain the stone number in row C, available to all subroutines
AND R4 R4 #0	;R4 0-PLAYER1 1-PLAYER2
ADD R4 R4 #1	;befor entering the program, set current player to player 2
ADD R1 R1 #3	;row A - 3 stones
ADD R2 R2 #5	;row B - 5 stones
ADD R3 R3 #8	;row C - 8 stones

;CWIN test whether the game is ended or not
CWIN	AND R0 R0 #0
ADD R0 R0 R1
ADD R0 R0 R2
ADD R0 R0 R3
BRZ WIN
;if not win, print board and shift player
JSR PBOARD
ADD R4 R4 #0
BRP TOP1
ADD R4 R4 #1
BRNZP PROMPER
TOP1	AND R4 R4 #0

;print the prompt
PROMPER	ADD R4 R4 #0
BRP P2ROUND
LEA R0 PLAYER1
BRNZP INPUT
P2ROUND	LEA R0 PLAYER2

;input
INPUT	TRAP x22
TRAP x20
TRAP x21
AND R5 R5 #0
ADD R5 R5 R0	;R5 stores the row number
TRAP x20
TRAP x21
AND R6 R6 #0
ADD R6 R6 R0	;R6 stores the number of stones
LD R0 NL	;R5 and R6 are the parameters passed into the CHECK routine
TRAP x21

;Call the check routine to check whether the input is valid or not
JSR CHECK
ADD R0 R0 #0
BRN MIVALID
;if the input is valid, DO THE MINUS operation in order to update the board
LD R0 NL
TRAP x21
LD R0 NA
ADD R0 R0 R5
BRZ SETA
ADD R0 R0 #-1
BRZ SETB
BRP SETC
SETA	ADD R1 R1 R6
BRNZP CWIN
SETB	ADD R2 R2 R6
BRNZP CWIN
SETC	ADD R3 R3 R6
BRNZP CWIN

;if not valid
MIVALID	LEA R0 SIVALID
TRAP x22
LD R0 NL
TRAP x21
BRNZP PROMPER

;the end of the program
WIN	LEA R0 WIN1
ADD R4 R4 #0
BRP END
LEA R0 WIN2
END	TRAP x22
TRAP x25

;CONSTANTS
ROW	.STRINGZ "ROW "
PLAYER1	.STRINGZ "Player 1, choose a row and number of rocks: "
PLAYER2	.STRINGZ "Player 2, choose a row and number of rocks: "
SIVALID	.STRINGZ "Invalid move. Try again."
WIN1	.STRINGZ "Player 1 Wins."
WIN2	.STRINGZ "Player 2 Wins."
NA	.FILL xFFBF
NC	.FILL xFFBD
NZERO	.FILL xFFD0
A	.FILL x41
B	.FILL x42
C	.FILL x43
COLON	.FILL x3A
SPACE	.FILL x20
STONE	.FILL x6F
NL	.FILL x0A
CHECK4	.BLKW 1
CHECK5	.BLKW 1
PBOARD0	.BLKW 1
PBOARD7	.BLKW 1
P1ROW0	.BLKW 1
P1ROW7	.BLKW 1
PSTONE0	.BLKW 1
PSTONE4	.BLKW 1
PSTONE7	.BLKW 1

;CHECK VALID OR NOT : RECEIVE R5 R6 NOT CHANGE RETURN R0 SAVE-R4
;first check the row and then check the stones
;IF RET POSITIVE ITS VALID AND ITS THE NUMBER OF REMAING STONES
;IF RET NEG - INVALID
CHECK	ST R4 CHECK4
ST R5 CHECK5
LD R0 NA
LD R4 NZERO	;CHANGE ASCII TO INTEGER
ADD R6 R6 R4
BRNZ INVALID
NOT R6 R6
ADD R6 R6 #1	;CHANGE INTEGER TO NEGATIVE
ADD R5 R5 R0
BRZ CSTONEA
ADD R5 R5 #-1
BRZ CSTONEB
ADD R5 R5 #-1
BRZ CSTONEC
BRNZP INVALID
CSTONEA	ADD R0 R1 R6
BRNZP CHOUT
CSTONEB	ADD R0 R2 R6
BRNZP CHOUT
CSTONEC	ADD R0 R3 R6
BRNZP CHOUT
INVALID	AND R0 R0 #0
ADD R0 R0 #-1
CHOUT	LD R4 CHECK4	;CANNOT CHECK THE CC
LD R5 CHECK5
RET

;PRINT THE CURRENT BOARD R0 R7 DO NOT CHANGE R1 R2 R3
PBOARD	ST R0 PBOARD0
ST R7 PBOARD7
;PRINT ROW A
LD R0 A
JSR PROW
AND R0 R0 #0
ADD R0 R0 R1
JSR PSTONE
;PRINT ROW B
LD R0 B
JSR PROW
AND R0 R0 #0
ADD R0 R0 R2
JSR PSTONE
;PRINT ROW C
LD R0 C
JSR PROW
AND R0 R0 #0
ADD R0 R0 R3
JSR PSTONE
;LD
LD R0 PBOARD0
LD R7 PBOARD7
RET

;PRINT ROW: RECEIVE R0-CHARACTER R7
;this function prints the sting: "ROW ?: "
PROW	ST R0 P1ROW0
ST R7 P1ROW7
LEA R0 ROW
TRAP x22
;THE x22 PUTS A SPACE TO THE END NOPE THAT'S I PUT IT THERE
;	LD R0 SPACE
;	TRAP x21
LD R0 P1ROW0
TRAP x21
LD R0 COLON
TRAP x21
LD R0 SPACE
TRAP x21
LD R0 P1ROW0
LD R7 P1ROW7
RET

;PRINT STHONE RECEIVE R0-NUMBER OF STHONES R4 R7
;this function prints the sting: "ooo...oo"
PSTONE	ST R0 PSTONE0
ST R4 PSTONE4
ST R7 PSTONE7
AND R4 R4 #0
ADD R4 R4 R0
LD R0 STONE
ADD R4 R4 #0
PO	BRZ POOUT
TRAP x21
ADD R4 R4 #-1
BRNZP PO
POOUT	LD R0 NL
TRAP x21
LD R0 PSTONE0
LD R4 PSTONE4
LD R7 PSTONE7
RET
.END
```
