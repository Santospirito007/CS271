TITLE Program Template     (proj_3_aguilera_joe.asm)

; Author: Joe Aguilera
; Course / Project ID: Project 3  CS271 Winter 2016	Date: 2/7/2016
; Description:Write and test a MASM program to perform the following tasks:
;1. Display the program title and programmer’s name.
;2. Get the user’s name, and greet the user.
;3. Display instructions for the user.
;4. Repeatedly prompt the user to enter a number. Validate the user input to be in [-100, -1] (inclusive).
;Count and accumulate the valid user numbers until a non-negative number is entered. (The nonnegative
;number is discarded.)
;5. Calculate the (rounded integer) average of the negative numbers.

INCLUDE Irvine32.inc

LOWERLIMIT		=		 -100
UPPERLIMIT		=		 -1

.data

welcome					BYTE		"Welcome to the Integer Accumulator by Joe Aguilera", 0
instructions_1				BYTE		"Please enter numbers between [-100, -1].", 0
instructions_2				BYTE		"Then, enter a non-negative number to see the real power of the program!", 0
instructions_3				BYTE		" Enter a number: ", 0
userNameInstructions		BYTE		"What's your name?", 0
greeting				     BYTE		"Hi, ", 0
goodbye					BYTE		"Good-bye, ", 0
number					DWORD	?
userName					BYTE		21 DUP(0)
count					DWORD	1
accumulator				DWORD	0
totalIs					BYTE		"The total is:                  ", 0
quantNumbersEntered 		BYTE		"Amount of numbers accumulated:  ", 0
roundedAve_prompt			BYTE		"The Rounded Average is:        ", 0
roundedAve				DWORD	0
remainder				     DWORD	?
floating_point_point		BYTE		".",0
floating_point_prompt		BYTE		"As a floating point number:    ", 0
neg1k					DWORD	-1000	; used to make floating point
onek					     DWORD	1000		;used to make floating point
subtractor				DWORD	?
floating_point				DWORD	?
ec_prompt_1				BYTE		"EC: Display as floating point value.", 0
ec_prompt_2				BYTE		"EC: Lines are numbered during user input.", 0

.code
 main PROC
	; Programmer name and title of assignment
  	call		CrLf
  	mov		edx, OFFSET welcome
  	call		WriteString
  	call		CrLf

	;extra credit prompts
  	mov		edx, OFFSET ec_prompt_1
  	call		WriteString
  	call		CrLf
  	mov		edx, OFFSET ec_prompt_2
  	call		WriteString
  	call		CrLf

	; get user name
  	mov		edx, OFFSET userNameInstructions
	call		WriteString
	call		CrLf
	mov		edx, OFFSET userName
	mov		ecx, 32
	call		ReadString

	;greet user
  	mov		edx, OFFSET greeting
  	call		WriteString
  	mov		edx, OFFSET userName
  	call		WriteString
  	call		CrLF


	;instructions
  	mov		edx, OFFSET instructions_1
  	call	WriteString
  	call	CrLf
  	mov		edx, OFFSET instructions_2
  	call	WriteString
  	call	CrLf
  	mov		ecx, 0
	; loop to allow user to continue
	numberLoop:	;read user number
			mov		eax, count
			call	WriteDec
			add		eax, 1
			mov		count, eax
			mov	  edx, OFFSET instructions_3
			call	WriteString
			call  ReadInt
			mov   number, eax
			cmp		eax,LOWERLIMIT
			jb		accumulate;
			cmp		eax, UPPERLIMIT
			jg		accumulate
			add		eax, accumulator
			mov		accumulator, eax
			loop	numberLoop
	
	; do the accumulation
	accumulate:
			; test if they entered any valid numbers, if not jump to Goodbye
			mov		eax, count
			sub		eax, 2
			jz		sayGoodbye
			mov		eax, accumulator
			call	CrLF

			; accumulated total
			mov		edx, OFFSET  totalIs
			call	WriteString
			mov		eax, accumulator
			call	WriteInt
			call	CrLF

			; total numbers accumulated
			mov		edx, OFFSET quantNumbersEntered
			call	WriteString
			mov		eax, count
			sub		eax, 2
			call	WriteDec
			call	CrLf

			; integer rounded average
			mov		edx, OFFSET roundedAve_prompt
			call	WriteString
			mov		eax, 0
			mov		eax, accumulator
			cdq
			mov		ebx, count
			sub		ebx, 2
			idiv	ebx
			mov		roundedAve, eax
			call	WriteInt
			call	CrLf

			; integer average
			mov		remainder, edx
			mov		edx, OFFSET floating_point_prompt
			call	WriteString
			call	WriteInt
			mov		edx, OFFSET floating_point_point
			call	WriteString

			;floating point creation
			mov		eax, remainder
			mul		neg1k
			mov		remainder, eax ; eax now holds remainder * -1000
			mov		eax, count
			sub		eax, 2		   
			mul		onek
			mov		subtractor, eax

			fld		remainder
			fdiv	subtractor
			fimul	onek
			frndint
			fist	floating_point
			mov		eax, floating_point
			call	WriteDec
			call	CrLf

	; say goodbye
	sayGoodbye:
			call	CrLf
			mov		edx, OFFSET goodbye
			call	WriteString
			mov		edx, OFFSET userName
			call	WriteString
			mov		edx, OFFSET floating_point_point
			call	WriteString
			call	CrLf
			call	CrLf
exit	; exit to operating system
main ENDP
END main
