TITLE Programming Assignment #5    (Proj_5_aguilera_joe.asm)

; Author:	Joe Aguilera
; Course / Project ID: Project 5  CS271 Winter 2016	Date: 2/24/2016
; Description:
; Write and test a MASM program to perform the following tasks:

;1. Introduce the program.
;2. Get a user request in the range [min = 10 .. max = 200].
;3. Generate request random integers in the range [lo = 100 .. hi = 999], storing them in consecutive elements of an array.
;4. Display the list of integers before sorting, 10 numbers per line.
;5. Sort the list in descending order (i.e., largest first).
;6. Calculate and display the median value, rounded to the nearest integer. 
;7. Display the sorted list, 10 numbers per line.


INCLUDE Irvine32.inc

MIN				=		 10
MAX				=		 200
LO				=		 100
HI				=		 999
MAX_SIZE			=		 200

.data

welcome					BYTE		"Welcome to Sorting Random Generated Ints by Joe Aguilera.", 0
instructions_1				BYTE		"Please enter a number between [10, 200] to see all ",0
instructions_2				BYTE		"of the numbers before and after they're sorted.", 0
instructions_3				BYTE		"It will display the median value and show the sorted list in descending order", 0
instructions_4				BYTE		"Please enter a number between 10 and 200.", 0
belowError				BYTE		"The number you entered was invalid. Error Code: Too Small. ", 0
aboveError				BYTE		"The number you entered was invalid. Error Code: Too Big. ", 0
medianString				BYTE		"The median is: ",0
spaces					BYTE		"   ", 0
goodbye					BYTE		"Good-Bye, and come back soon!", 0
beforeSort				BYTE		"The array before being sorting: ", 0
afterSort					BYTE		"The array after being sorting: ", 0
number					DWORD	?
request					DWORD	?
requestTemp			     DWORD	?
list						DWORD	MAX_SIZE DUP(?)

.code
 main PROC
	call introduction
	push OFFSET request
	call getData
	call Randomize			; seed for generating random numbers
	push OFFSET list
	push request
	call fillArray
	mov  edx, OFFSET beforeSort
	call WriteString
	call CrLf
	push OFFSET list
	push request
	call displayList
	push OFFSET list
	push request
	call sortList
	call CrLf
	push OFFSET list
	push request
	call displayMedian
	call CrLf
	mov  edx, OFFSET afterSort
	call WriteString
	call CrLf
	push OFFSET list
	push request
	call displayList
	call farewell
	exit
main ENDP
; ******************************************************************************************************
; INTRODUCTION PROCEDURE:
; Description :		Procedure to give the user instructions and an introduction to the program.
; Receives:			welcome, instructions_1, and instructions_2 are global variables
; Returns:		     nothing
; Preconditions:		welcome, instructions_1, instructions_2, and instructions_3 must be set to strings
; Registers Changed:	edx
; ******************************************************************************************************
introduction PROC
	; Programmer name and title of assignment
	call	 CrLf
	mov		 edx, OFFSET welcome
	call	 WriteString
	call	 CrLf
	; assignment instructions
	mov		edx, OFFSET instructions_1
	call	WriteString
	mov		edx, OFFSET instructions_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instructions_3
	call	WriteString
	call	CrLf
	ret
introduction ENDP
; ******************************************************************************************************
; GETDATA PROCEDURE:
; Description :		Procedure to get and validate an integer between 10 and 200 from the user.
; Receives:			instructions_3 is global variable. Receives OFFSET of request variable. MAX and MIN global constants.
; Returns:			puts user's request integer into the varible.
; Preconditions:		instructions_4 must be set to strings. Request must be declared as a DWORD
; Registers Changed:	edx, eax,
; ******************************************************************************************************

getData PROC

	; loop to allow user to continue entering numbers until they enter a valid number.
		push ebp
		mov	 ebp, esp
		mov	 ebx, [ebp + 8] ; get address of request into ebx 


	userNumberLoop:
					mov		edx, OFFSET instructions_4
					call	WriteString
					call	CrLf
					call    ReadInt
					mov     [ebx], eax		; save the user's request into var request
					cmp		eax, MIN
					jb		errorBelow
					cmp		eax, MAX
					jg		errorAbove
					jmp		continue
	;validation

	errorBelow:
					mov		edx, OFFSET belowError
					call	WriteString
					call	CrLf
					jmp		userNumberLoop
	errorAbove:
					mov		edx, OFFSET aboveError
					call	WriteString
					call	CrLf
					jmp		userNumberLoop
	continue:
			pop ebp
	ret 4 ; clean up the stack. we only have 1 extra DWORD to get rid of.
getData ENDP

; ******************************************************************************************************
; FILLARRAY PROCEDURE:
; Description :		Fill an array with randomly generated numbers
; Receives:			list: @array and request: number of array elements
; Returns:			nothing
; Preconditions:		request must be set to an integer between 10 and 200
; Registers Changed:	eax, ecx, esi
; ******************************************************************************************************

fillArray PROC
	push ebp
	mov  ebp, esp
	mov  esi, [ebp + 12]		; @list
	mov	 ecx, [ebp + 8]		; loop control based on request

	fillArrLoop:
		mov		eax, HI
		sub		eax, LO
		inc		eax
		call		RandomRange
		add		eax, LO
		mov		[esi], eax	; put random number in array
		add		esi, 4		; next element
		loop		fillArrLoop

	pop  ebp
	ret  8
fillArray ENDP

; ******************************************************************************************************
; DISPLAYLIST PROCEDURE:
; Description :		Prints out values in list MIN numbers per row
; Receives:			list: @array and request: number of array elements
; Returns:			nothing
; Preconditions:		request must be set to an integer between 10 and 200
; Registers Changed:	eax, ecx, ebx, edx
; ******************************************************************************************************

displayList PROC
	push ebp
	mov  ebp, esp
	mov	 ebx, 0				; counting to 10 for ouput
	mov  esi, [ebp + 12]		; @list
	mov	 ecx, [ebp + 8]		; loop control based on request
	displayLoop:
		mov		eax, [esi]	; get current element
		call	WriteDec
		mov		edx, OFFSET spaces
		call	WriteString
		inc		ebx
		cmp		ebx, MIN
		jl		skipCarry
		call	CrLf
		mov		ebx,0
		skipCarry:
		add		esi, 4		; next element
		loop	displayLoop
	endDisplayLoop:
		pop		ebp
		ret		8
displayList ENDP

; ******************************************************************************************************
; SORTLIST PROCEDURE:
; Description :		Prints out values in list
; Receives:			list: @array and request: number of array elements
; Returns:			nothing
; Preconditions:		request must be set to an integer between 10 and 200
; Registers Changed:	eax, ecx, ebx, edx
; ******************************************************************************************************

sortList PROC
	push ebp
	mov  ebp, esp
	mov  esi, [ebp + 12]				; @list
	mov	 ecx, [ebp + 8]				; loop control based on request
	dec	 ecx
	outerLoop:
		mov		eax, [esi]			; get current element
		mov		edx, esi
		push	ecx						; save outer loop counter
		innerLoop:
			mov		ebx, [esi+4]
			mov		eax, [edx]
			cmp		eax, ebx
			jge		skipSwitch
			add		esi, 4
			push	esi
			push	edx
			push	ecx
			call	exchange
			sub		esi, 4
			skipSwitch:
			add		esi,4

			loop	innerLoop
			skippit:
		pop		ecx 			; restore outer loop counter
		mov		esi, edx		; reset esi

		add		esi, 4				; next element
		loop	outerLoop
	endDisplayLoop:
		pop		ebp
		ret		8
sortList ENDP

; ******************************************************************************************************
; exchange PROCEDURE:
; Description :		Prints out values in list
; Receives:			list: @array and request: number of array elements
; Returns:			nothing
; Preconditions:		request must be set to an integer between 10 and 200
; Registers Changed:	eax, ebx, ecx, edx
; ******************************************************************************************************

exchange PROC
	push	ebp
	mov		ebp, esp
	pushad

	mov		eax, [ebp + 16]				; address of second number
	mov		ebx, [ebp + 12]				; address of first number
	mov		edx, eax
	sub		edx, ebx					; edx should now have the difference between the first and second number

	; somehow we got to switch these two up.
	mov		esi, ebx
	mov		ecx, [ebx]
	mov		eax, [eax]
	mov		[esi], eax  ; put eax in array
	add		esi, edx
	mov		[esi], ecx

	popad
	pop		ebp
	ret		12
exchange ENDP

; ******************************************************************************************************
; DISPLAYMEDIAN PROCEDURE:
; Description :		Fill an array with random numbers
; Receives:			list: @array and request: number of array elements
; Returns:			nothing
; Preconditions:		request must be set to an integer between 10 and 200
; Registers Changed:	eax, ebx, ecx, edx,
; ******************************************************************************************************

displayMedian PROC
	push ebp
	mov  ebp, esp
	mov  esi, [ebp + 12]  ; @list
	mov	 eax, [ebp + 8]
	mov  edx, 0
	mov	 ebx, 2
	div	 ebx
	mov	 ecx, eax


	medianLoop:
		add		esi, 4
		loop	medianLoop

	; check for zero
	cmp		edx, 0
	jnz     itsOdd
	; its even
	mov		eax, [esi-4]
	add		eax, [esi]
	mov		edx, 0
	mov		ebx, 2
	div		ebx
	mov		edx, OFFSET medianString
	call	WriteString
	call	WriteDec
	call	CrLf
	jmp		endDisplayMedian

	itsOdd:
	mov		eax, [esi]
	mov		edx, OFFSET medianString
	call	WriteString
	call	WriteDec
	call	CrLf

	endDisplayMedian:

	pop  ebp
	ret  8
displayMedian ENDP


; ******************************************************************************************************
; FAREWELL PROCEDURE:
; Description :		Procedure to say goodbye to the user.
; Receives:		     goodbye is global variables.
; Returns:			nothing
; Preconditions:		goodbye must be set to strings.
; Registers Changed: edx,
; ******************************************************************************************************

farewell PROC
	; say goodbye

	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf
	call	CrLf
	exit
farewell ENDP
END main