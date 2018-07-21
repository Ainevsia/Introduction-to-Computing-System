# Brief introduction
This is a program that will continue printing the `** checkerboard` or the `## checkerboard` until it is interrupted by someone sitting behind the compter hitting a key on the keyboard and changes the pattern of its checkerboard.

# Thoughts
This experiment is not well-illustrated and didn't gave any example input or output as the 3 experiments before and there is some points still seemed obscure to me, so I want to clearify my current understanding of this experiment and make sure the TA who is reading my program will understand what I am doing right away.

As far as I am concerned, once there is an interruption, the interrupt service routine will output the first character that the person types 10 times and the user program should immediately change its pattern of the checkerboard. In my conception, once the first character is typed, the interrupt service routine will stay waiting for the next character and no matter what the next character is, went back to the user program.

And during my debugging, I found that the program can also be interrupted while executing the `TRAP x22` instruction, so the process of the printing of the whole line might haven't complete when interrupted. In the case I mentioned above, my program will print the whole line that was interrupted and then change its checkerboard pattern.

I also got confused that when storing data into the DDR, it seems that I don't need to set the DSR[15] to 0. If I do so, all the things that I put into the DDR will be put to the screen twice. I cannot figure out why now.
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
```asm

```
