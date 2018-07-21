# Brief introduction
My program uses a strategy which is rather the same that is used in the homework 5.33  

R0 is a counter which counts the number of ones in the location x3050.  
R3 is a loop control variant which has an initial value of 15. It changes from 15 to 0 which mean the loop continues 16 times, examinating every different bit of the data in the R1, which has acquired the value in the location x3050.  

```
0101 100 001 000 010	;AND R1 R2 to R4
0000 010 000000001	  ;CB +1
0001 000 000 1 00001	;R0=R0+1
```
These three lines do the work of compare the R1(data) with a 16 binary sezquence which only have one one at a particular position. Then according the result, the counter R0 is added or not added.  

R2 is the register used to compare, which has the original value of x0001. during each loop, the sentence `0001 010 010 000 010	;R2=R2+R2` move the 1 in it one bit left, so in the next loop, it can examinate the following bit.

After 16 loops, every bit of R1 has been examinated so the program will stop.
# How to use it
Load the program into the LC3 Simulator and set the location x3050 to any value you want. Run the program and then you can get the answer in the location x3051.

# The whole code
```
0011 0000 0000 0000 	;start the program at location x3000
0101 000 000 1 00000	;R0=0
0101 011 011 1 00000 	;R3=0
0001 011 011 1 01111 	;R3=15
0010 001 001001100	;LD x3050 to R1 (+76)
0101 010 010 1 00000	;R2=0
0001 010 010 1 00001 	;R2=1
0101 100 001 000 010	;AND R1 R2 to R4
0000 010 000000001	;CB +1
0001 000 000 1 00001	;R0=R0+1
0001 010 010 000 010	;R2=R2+R2
0001 011 011 1 11111	;R3=R3-1
0000 011 111111010	;x300B CB -6
0011 000 001000100	;x300C ST +68
1111 000000100101	;TRAP
```
