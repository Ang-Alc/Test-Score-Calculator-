;CIS11 Final Project; Test Score Calculator
;Professor Nguyen 
;Authors: Anthony Ocampo, Angel Alcazar, Paolo Ramos
;This program will prompt the user for 5 test scores and
;take the given scores and calculate the maximum, minimum, and average
;of the 5 scores, while also assigning a letter grade to each score.

.ORIG x3000 ; Start the program at memory location x3000

LEA  R0, WEL							; Load the address of the string 
PUTS
WEL	.STRINGZ "Please Input 5 Test Scores: (00 - 99)"	; Print the string

LD R0, NEWLINE							; Load the value stored at the label NEWLINE into R0
OUT								; Output the character 

; Jumps to subroutine GRADE_IN to get the value of the grade, then stores into the array.
; then jumps to the LETTER subroutine then the POP
JSR GRADE_IN
LEA R6, GRADES
STR R3, R6, #0
JSR LETTER
JSR POP

LD R0, NEWLINE
OUT

; same thing as the top function, just using different values
JSR GRADE_IN
LEA R6, GRADES
STR R3, R6, #1
JSR LETTER
JSR POP

LD R0, NEWLINE
OUT

; same thing as the top function, just using different values
JSR GRADE_IN
LEA R6, GRADES
STR R3, R6, #2
JSR LETTER
JSR POP

LD R0, NEWLINE
OUT

; same thing as the top function, just using different values
JSR GRADE_IN
LEA R6, GRADES
STR R3, R6, #3
JSR LETTER
JSR POP

LD R0, NEWLINE
OUT

; same thing as the top function, just using different values
JSR GRADE_IN
LEA R6, GRADES
STR R3, R6, #4
JSR LETTER
JSR POP

LD R0, NEWLINE
OUT

; calculates the maximum score that was inputted from the user
CALC_MAX
	LD R1, TEST_NUM
    	LEA R2, GRADES
	LD R4, GRADES
	ST R4, GRADE_MAX
	ADD R2, R2, #1

LOOP1   
	LDR R5, R2, #0  ; gives access to pointer value
   	NOT R4, R4
   	ADD R4, R4, #1
   	ADD R5, R5, R4
   	BRp NEXT
   	LEA R0, MAX
   	PUTS
   	LD R3, GRADE_MAX
	AND R1, R1, #0
   	JSR BREAK
   	LD R0, SPACE
   	OUT

LD R0, NEWLINE
OUT
JSR C_REGISTER

; calculates the minimum score that was inputted from the user
CALC_MIN
	LD R1, TEST_NUM
   	LEA R2, GRADES
    	LD R4, GRADES
	ST R4, GRADE_MIN
   	ADD R2, R2, #1
   	ADD R1, R1, #-1

LOOP2   
	LDR R5, R2, #0  ; gives access to pointer value
	NOT R4, R4
    	ADD R4, R4, #1
	ADD R5, R5, R4
    	BRn NEXT2

    	ADD R2, R2, #1
    	LD R4, GRADES
    	AND R5, R5, #0
    	ADD R1, R1, #-1
    	BRp LOOP2

    	LEA R0, MIN
    	PUTS
    	LD R3, GRADE_MIN
    	AND R1, R1, #0
    	JSR BREAK
    	LD R0, SPACE
    	OUT

JSR C_REGISTER
LD R0, NEWLINE
OUT

; calculates the average score of the 5 test scores
CALC_AVG
    	LD R1, TEST_NUM
    	LEA R2, GRADES

GET_SUM 
	LDR R4, R2, #0
    	ADD R3, R3, R4
    	ADD R2, R2, #1
    	ADD R1, R1, #-1
    	BRp GET_SUM

    	LD R1, TEST_NUM
    	NOT R1, R1
    	ADD R1, R1, #1
    	ADD R4, R3, #0

LOOP3   
	ADD R4, R4, #0
    	BRnz COMP_AVG
    	ADD R6, R6, #1
    	ADD R4, R4, R1
    	BRp LOOP3

AVE_DONE
    	ST R6, SCORE_AVG
    	LEA R0, AVG
    	PUTS
	AND R3, R3, #0
    	AND R1, R1, #0
    	AND R4, R4, #0
    	ADD R3, R3, R6
JSR BREAK

HALT

; global variables
NEWLINE		.FILL xA
SPACE		.FILL X20
D_DECODE	.FILL #-48
S_DECODE	.FILL #48
T_DECODE	.FILL #-30
TEST_NUM	.FILL #5

; memory allocation
GRADE_MAX	.BLKW #1
GRADE_MIN	.BLKW #1
COMP_AVG	.BLKW #1
SCORE_AVG	.BLKW #1

; variables for calculations
NEXT2
	LDR R4, R2, #0
    	ST R4, GRADE_MIN
    	ADD R2, R2, #1
    	ADD R1, R1, #-1
    	BRnzp LOOP2

NEXT
    	LDR R4, R2, #0
    	ST R4, GRADE_MAX
    	ADD R2, R2, #1
    	ADD R1, R1, #-1
    	BRp LOOP1

GRADES  .BLKW #5

; display max, min, and avg
MIN	.STRINGZ "Minimum:  "
MAX	.STRINGZ "Maximum: "
AVG	.STRINGZ "Average: "

; allows for the inputted numbers to be taken in as a grade (0-99) without errors
GRADE_IN
	ST R7, LOC1
	JSR C_REGISTER
        LD R4, D_DECODE

        GETC
        JSR VALID
        OUT

        ADD R1, R0, #0
        ADD R1, R1, R4
        ADD R2, R2, #10

MULTIPLY    
	ADD R3, R3, R1
        ADD R2, R2, #-1
        BRp MULTIPLY
        GETC
        JSR VALID
        OUT
        ADD R0, R0, R4
        ADD R3, R3, R0
        LD R0, SPACE
        OUT
        LD R7, LOC1
        RET

; used to break the double digit number into 2 in order to print correctly
BREAK
	ST R7, LOC1
    	LD R5, S_DECODE

    ADD R4, R3, #0

DIVIDE  
	ADD R1, R1, #1
    	ADD R4, R4, #-10
    	BRp DIVIDE
    	ADD R1, R1 #-1
    	ADD R4, R4, #10
    	ADD R6, R4, #-10
    	BRnp POS

NEG
	ADD R1, R1, #1
    	ADD R4, R4, #-10

POS
	ST R1, Q
    	ST R4, R
    	LD R0, Q
    	ADD R0, R0, R5
    	OUT
    	LD R0, R
    	ADD R0, R0, R5
    	OUT
    	LD R7, LOC1
    	RET

R	.FILL X3201
Q	.FILL X3202

; takes a number from R0 and stores it into a stack
PUSH_ST 
	ST R7, LOC2
        JSR C_REGISTER
        LD R6, POINTER
        ADD R6, R6, #0
        BRnz ERROR_ST
        ADD R6, R6, #-1
        STR R0, R6, #0
        ST R6, POINTER
        LD R7, LOC2
RET

POINTER	.FILL X4000

; removes number from a stack then stores it in R0
POP 
	LD R6, POINTER
    	ST R1, LOC5
    	LD R1, BASE
    	ADD R1, R1, R6
    	BRzp ERROR_ST
    	LD R1, LOC5
    	LDR R0, R6, #0
    	ST R7, LOC4
    	OUT
    	LD R0, SPACE
    	OUT
    	ADD R6, R6, #1
    	ST R6, POINTER
    	LD R7, LOC4
RET

ERROR_ST    
	LEA R0, ERROR
        PUTS
        HALT

BASE	.FILL xC000
ERROR	.STRINGZ "Halting program due to overflow…"

; takes the two digit numerical score and translates it into a letter grade
LETTER
	AND R2, R2, #0

A_LETGR 
	LD R0, A_INT
        LD R1, A_LET
        ADD R2, R3, R0
        BRzp GRADE_STR

B_LETGR 
	AND R2, R2, #0
        LD R0, B_INT
        LD R1, B_LET
        ADD R2, R3, R0
        BRzp GRADE_STR

C_LETGR 
	AND R2, R2, #0
        LD R0, C_INT
        LD R1, C_LET
        ADD R2, R3, R0
        BRzp GRADE_STR

D_LETGR 
	AND R2, R2, #0
        LD R0, D_INT
        LD R1, D_LET
        ADD R2, R3, R0
        BRzp GRADE_STR

F_LETGR 
	AND R2, R2, #0
        LD R0, F_INT
        LD R1, F_LET
        ADD R2, R3, R0
        BRNZP GRADE_STR
RET

GRADE_STR  
	ST R7, LOC1
        AND R0, R0, #0
        ADD R0, R1, #0
        JSR PUSH_ST
        LD R7, LOC1
RET
; sets the numerical range for each letter grade
A_INT	.FILL #-90
A_LET	.FILL X41

B_INT	.FILL #-80
B_LET	.FILL X42

C_INT  	.FILL #-70
C_LET  	.FILL X43

D_INT  	.FILL #-60
D_LET  	.FILL X44

F_INT  	.FILL #-50
F_LET  	.FILL X46

; register clear
C_REGISTER 
	AND R1, R1, #0
        AND R2, R2, #0
        AND R3, R3, #0
        AND R4, R4, #0
        AND R5, R5, #0
	AND R6, R6, #0
RET

; validates data input from user, if invalid then program comes to a halt
VALID 
	ST R1, LOC5
        ST R2, LOC4
        ST R3, LOC3
        LD R1, MIN_DATA
        ADD R2, R0, R1
        BRN FAIL
        LD R1, MAX_DATA
        ADD R3, R0, R1
        BRP FAIL
        LD R1, LOC5
        LD R2, LOC4
        LD R3, LOC3
RET

FAIL    
	LEA R0, STR_FAIL
        PUTS
        LD R0, NEWLINE2
        OUT
        HALT

STR_FAIL	.STRINGZ "Entry is invalid. Halting…"
MIN_DATA	.FILL #-48
MAX_DATA	.FILL #-57
NEWLINE2	.FILL XA

; global variables
LOC1	.FILL X3101
LOC2 	.FILL X3102
LOC3 	.FILL X3103
LOC4 	.FILL X3104
LOC5 	.FILL X3105

; ends program
.END
