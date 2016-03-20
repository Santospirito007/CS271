TITLE Program Template     (proj_1_aguilera_joe.asm)

; Author: Joe Aguilera
; Course / Project ID:CS271 Winter 2016 Program 1      Date:1/18/2016
; Description:Write and test a MASM program to perform the following tasks:
;1. Display your name and program title on the output screen.
;2. Display instructions for the user.
;3. Prompt the user to enter two numbers.
;4. Calculate the sum, difference, product, (integer) quotient and remainder of the numbers.
;5. Display a terminating message.

INCLUDE Irvine32.inc


; (insert constant definitions here)

.data
intro		BYTE		"Hi there, my name is Joe Aguilera and the program you are using is a Simple Calculator.",  0
goodBye		BYTE		"Good-bye, and have a nice day!", 0
prompt_1		BYTE		"Please enter a number, ", 0
prompt_2		BYTE		"Please enter another number, " , 0	
instruction_1	BYTE		"You will now recieve a prompt twice to enter a number,", 0
instruction_2	BYTE		"I will return the sum, differnce, product, and integer quotient.", 0
resultOut1	BYTE		"Here are the results from the given two numbers: ",0
sumOut		BYTE		"the sum is, ",0
diffOut		BYTE		"the difference is, ",0
prodOut		BYTE		"the product is, ",0
divisOut		BYTE		"the quotient is, ",0
remaOut		BYTE		"and the remainder is, "
num1Hld		DWORD	?		;the first number holder
num2Hld		DWORD	?		;the second number holder
sumRes		DWORD	?		;The result of the sum of the two numbers
prodRes		DWORD	?		;The result of the products of the two numbers
diffRes		DWORD	?		;The result of the difference of the two numbers
divisRes		DWORD	?		;The result of the quotient of the two numbers
remaRes		DWORD	?		;The remainder


.code
main PROC

;1. introduce the programmer and the program
	mov		edx, OFFSET intro ;print intro
	call		WriteString
	call		CrLf

;2. Display instructions for the user.
	mov		edx, OFFSET instruction_1 ;print instruction line 1
	call		WriteString
	call		CrLf

	mov		edx, OFFSET instruction_2;print instruction line 2
	call		WriteString
	call		CrLf

;3. Prompt the user to enter two numbers.
	mov		edx, OFFSET prompt_1;print prompt 1
	call		WriteString
	call		ReadInt			;grab the value
	mov		num1Hld, eax		; get from eax and store the first number in the holder

	mov		edx, OFFSET prompt_1;print prompt 2
	call		WriteString
	call		ReadInt			;grab the value
	mov		num2Hld, eax		; get from eax and store second number in its holder


;4. Calculate the sum, difference, product, (integer) quotient and remainder of the numbers.
	;sum calculation
	mov		eax, num1Hld
	add		eax, num2Hld		; add seccond number to eax register
	mov		sumRes, eax		;moving the value into the sum holder

	;difference calculation
	mov		eax, num1Hld
	sub		eax, num2Hld		;subtracting the seccond value from the eax register
	mov		diffRes, eax		;storing the value

	;product calculation
	mov		eax, num1Hld
	mov		ebx, num2Hld
	mul		ebx				;multiplying the two registers together
	mov		prodRes, eax		;storing the value

	;(integer) quotient and remainder calculation
	mov		edx, 0			;intilize the third register to catch remaider
	mov		eax, num1Hld
	mov		ebx, num2Hld
	div		ebx
	mov		divisRes, eax
	mov		remaRes, edx
	
;5. Display outs & a terminating message.
	mov		edx, OFFSET resultOut1
	call		WriteString
	call		CrLf

	;sum output
	mov		edx, OFFSET sumOut
	call		WriteString
	call		CrLf

	mov		eax, sumRes
	call		writeDec
	call		CrLf

	;difference output
	mov		edx, OFFSET diffOut
	call		WriteString
	call		CrLf
	mov		eax, diffRes
	call		writeDec
	call		CrLf

	;product output
	mov		edx, OFFSET prodOut
	call		WriteString
	call		CrLf

	mov		eax, prodRes
	call		writeDec
	call		CrLf

	;quotient and remainder output
	mov		edx, OFFSET divisOut
	call		WriteString
	call		CrLf

	mov		eax, divisRes
	call		writeDec
	call		CrLf

	mov		edx, OFFSET remaOut
	call		WriteString
	call		CrLf

	mov		eax, remaRes
	call		writeDec
	call		CrLf

	; say good-Bye

	mov		edx, OFFSET goodBye
	call		WriteString
	call		CrLf


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
