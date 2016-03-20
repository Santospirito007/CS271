
TITLE Program Template     (template.asm)

; Author: Joe Aguilera
; Course / Project ID: Project 2  CS271 Winter 2016	Date: 1/22/2016
; Description: Write a program to calculate Fibonacci numbers.
;Display the program title and programmer’s name. Then get the user’s name, and greet the user.
;Prompt the user to enter the number of Fibonacci terms to be displayed. Advise the user to enter an integer
;in the range [1 .. 46].
;Get and validate the user input (n).
;Calculate and display all of the Fibonacci numbers up to and including the nth term. The results should be
;displayed 5 terms per line with at least 5 spaces between terms.
;Display a parting message that includes the user’s name, and terminate the program.

INCLUDE Irvine32.inc

;fib max value

FIBMAX = 47	; the 47th Fibonacci number is too big for DWORD data TYPE. NEED TO MAKE SURE NUMBER IS LESS THAN THIS

.data

hello	BYTE		"Welcome to the fibonacci program! ", 0
devName	BYTE		"Programed by Joe Aguilera", 0
prompt1	BYTE		"What is your name? ",0
userName	BYTE		33 DUP(0)		;users  name holder
greetUser	BYTE		"Nice to meet you, ", 0
instruct1	BYTE		"Please enter the number of Fibonacci terms after 1, 1 you'd like to have displayed.",0
rule		BYTE		"The number can be no bigger than 46, ", 0
error1	BYTE		"I am sorry, that number doesn't follow the rule of a max of 46.",0
goodBye	BYTE		"Good-bye Thank you for your time!", 0
spacer	BYTE		"     ",0
fibNum	DWORD	?		;max fib num holder from user	
counter	DWORD	1		;loop counter

.code
main PROC

;Greeting & Introduce programmer
	mov		edx, OFFSET hello
	call		WriteString
	call		CrLf

	mov		edx, OFFSET devName
	call		WriteString
	call		CrLf

;Get user name
	mov		edx, OFFSET prompt1
	call		WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call		ReadString

;greet the user by their name
	mov		edx, OFFSET greetuser
	call		WriteString

	mov		edx, OFFSET userName
	call		WriteString
	call		CrLf

;give user inrstruction and rule
input:
	mov		edx, OFFSET instruct1
	call		WriteString
	call		CrLf

	mov		edx, OFFSET rule
	call		WriteString

;get the max fib number they want
	call		ReadInt
	mov		fibNum, eax

;validate fib number
decide:
    mov     eax, fibNum
    cmp     eax, FIBMAX		;check that input is < 47
    jge     greater			;opps it was greater move to greater section
    jl      initial			;go to intial if fibNum<FIBMAX
greater:
    mov		edx, OFFSET error1
    call		WriteString
    call		CrLf
    jmp		input	;will go back to jump section if it was too big

;this is the section it goes to if the number was less than FIBMAX
initial:
	mov		eax, 1			; initial setup from the instructions
	mov		ebx, 1			; initial setup from the instructions
	mov		edx, ebx			; initilizing the next number to go into ebx

	; explaination of loop: Eax +EBX -> reuslt in EAX then take what was EDX into EBX then make EDX the same value as EAX that way 
	; they add in the correct order

	mov		ecx, fibNum		; get number of Fib the user wants for the loop

;loop calculating and printing Fibonacci sequence
L1:       
	add		eax, ebx		;adding the 2 numbers together
	call		WriteDec		;print out Fibonacci number 
	mov		ebx, edx

	mov		edx, OFFSET spacer		; prints the spacer between the numbers that's requiered
	call		WriteString

	mov		edx, eax		;move the future value to be added back into edx to overwrite the string

	;decide2:
	
	;cmp     counter, 6		;check that counter is < 5
	;jge     step2			;it hit 5
	;jl      L1			;nope still less than 5 keep going


;step2:
	;mov		counter, 0
	call		CrLf
loop		L1			;subtract 1 from ecx, if ecx !=0, goes to L1. reach 0 terminates loop


; say good bye
	mov		edx, OFFSET goodBye
	call		WriteString
	call		CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
