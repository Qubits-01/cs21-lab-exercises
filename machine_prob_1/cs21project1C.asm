# CS 21 LAB 2 -- S1 AY 2022-2023
# Marc Peejay Viernes -- 2022/OCT/24
# cs21project1C.asm -- Peg solitaire solver.


.eqv	nRows 0x00000007		# Number of rows.
.eqv	nCols 0x00000007		# Number of columns.
.eqv	emptyHole 0x0000002E		# '.' : A hole with no peg.
.eqv	pegHole 0x0000006F		# 'o' : A hole with a peg.
.eqv	woPegFinalHole 0x00000045	# 'E' : Final hole w/o a peg.
.eqv	wPegFinalHole 0x0000004F	# 'O' : Final hole w/ a peg.
.eqv	heapPtr	$t9			# Will serve as the heap pointer and nothing else.
.eqv	heapBasePtr 0x10040000		# Base address for the heap memory.
.eqv	innerListTerminator 0x000000FE	# -2 : Inner list terminator for the 2D list.
.eqv	outerListTerminator 0x000000FD	# -3 : Outer list terminator for the 2D list.
.eqv	newLine 0x0000000a		# '/n' : New line.


.macro do_syscall(%code)
	addi	$v0, $0, %code
	syscall
.end_macro

.macro exit
	do_syscall(10)
.end_macro

.macro print_int(%int_addr)
	move	$a0, %int_addr		# Prepare the integer value.
	do_syscall(1)			# Print integer syscall.
.end_macro

.macro print_hex(%hex_addr)
	move	$a0, %hex_addr		# Prepare the hexadecimal value.
	do_syscall(34)			# Print hexadecimal syscall.
.end_macro

.macro print_char(%char_addr)
	move	$a0, %char_addr		# Prepare the ASCII value.
	do_syscall(11)			# Print ASCII character syscall.
.end_macro

.macro print_new_line
	addiu	$a0, $0, 0x0000000a	# 10: New line ASCII code (base 10).
	print_char($a0)		
.end_macro

.macro print_str(%data_label)
	la	$a0, %data_label	# Address of the String.
	do_syscall(4)			# Print String syscall.
.end_macro
	
.macro read_str(%data_label, %size %addr)
	la	$a0, %data_label	# Loads String buffer address.
	addi	$a1, $0, %size		# Read at most (%size - 1) characters.
	move	%addr, $a0		# Returns the address of the String.
	do_syscall(8)			# Read String syscall.
.end_macro

.macro malloc(%size, %addr)
	move	%addr, heapPtr			# Return the address of the allocated heap memory.
	addiu	heapPtr, heapPtr, %size		# Update the heapPtr.
.end_macro

.macro free(%size)
	subiu	heapPtr, heapPtr, %size		# Update the heapPtr.
.end_macro


main:
	# INITIALIZE THE GLOBAL VARIABLES.
	addi	$t0, $0, nRows			# The same with nCols (i.e., nRows = nCols = 7).
	sb	$t0, 0($gp)			# const int nRows = 7;
	addiu	$t0, $0, emptyHole
	sb	$t0, 1($gp)			# const String emptyHole = '.';
	addiu	$t0, $0, pegHole
	sb	$t0, 2($gp)			# const String pegHole = 'o';
	addiu	$t0, $0, woPegFinalHole
	sb	$t0, 3($gp)			# const String woPegFinalHole = 'E';
	addiu	$t0, $0, wPegFinalHole
	sb	$t0, 4($gp)			# const String wPegFinalHole = 'O';
	addi	$t0, $0, 0			# The number of peg moves of the solution.
	sb	$t0, 5($gp)			# int nPegMoves = 0;
	
	# INITIALIZE THE HEAP POINTER.
	# $t9 will be the heapPtr in order to effectively
	# manage the allocation and deallocation of the heap memory.
	addiu	heapPtr, $0, heapBasePtr	# int heapPtr = 0x10040000;		

	# INITIALIZE THE BOARD STATE.
	# This will be a 2-dimensional (2D) list.
	# Each row will occupy 8 bytes (i.e., 7 bytes plus 1 byte for the innerListTerminator).
	# The outer list will also have an outerListTerminator.
	# Hence, ((8 * 7) + 1 = 57) bytes will be needed for the boardState (at minimum).
	# Although, I will allocate 60 bytes so that it will still be divisible by 4.
	# This is to preserve memory alignment. The last 3 bytes will be don't care values. 
	malloc(60, $s0)				# List<List<String>> boardState = []; // $s0
	
	# INITIALIZE THE METADATA.
	# index 0: noOfPegs = The number of pegs remaining in the board.
	# index 1: tempFinalHoleRow - Row coordinate of the latest moved peg in its final hole.
	# index 2: tempFinalHoleCol - Column coordinate of the latest moved peg in its final hole.
	# List<int> metadata = [0, -1, -1]; // $s1
	malloc(12, $s1)
	addi	$t0, $0, -1
	sw	$0, 0($s1)			# metadata[0] = 0;
	sw	$t0, 4($s1)			# metadata[1] = -1;
	sw	$t0, 8($s1)			# metadata[2] = -1;
	
	# FETCH AND DECODE THE RAW INPUTS.
	addi	$t0, $0, 0			# int i = 0;
	lbu	$t1, 0($gp)			# nRows = 7;
	move	$t5, $s0			# Memory pointer to the chars of boardState.
	
	for0:
		beq	$t0, $t1, end_for0	# i == nRows ? goto end_for0
		
		# 7 bytes + new line + null terminator = 9 bytes
		read_str(rowInputBuffer, 9, $t2)	# final String tempRow = input(); // $t2
		addiu	$t3, $0, newLine		# const String newLine = '\n'; // $t3
		
		for1:
			lbu	$t4, 0($t2)		# final String currentChar = tempRow[j]; // $t4
			beq	$t4, $t3, end_for1	# currentChar == newLine ? goto end_for1
			
			print_char($t4)
			print_new_line()
			
			sb	$t4, 0($t5)		# Store the currentChar to the boardState.
			addiu	$t5, $t5, 1		# Increment the boardState's memory pointer by 1 byte.
			
			addiu	$t2, $t2, 1		# Increment the rowInputBuffer's memory pointer by 1 byte.
			j	for1
		
		end_for1:
			# Add the innerListTerminator.
			addi	$t2, $0, innerListTerminator
			sb	$t2, 0($t5)
			
			addiu	$t5, $t5, 1		# Increment the memory pointer by 1 byte.
		
		addi	$t0, $t0, 1		# i++;
		j	for0
	
	end_for0:
		# Add the outerListTerminator.
		addi	$t0, $0, outerListTerminator
		sb	$t0, 0($t5)
	
	print_new_line()
	
	addi	$t0, $0, 0			# int i = 0;
	addi	$t1, $0, outerListTerminator	# -3
	move	$t2, $s0			# Memory pointer to the chars of boardState.

	print_new_line()
	
	for2:
		lbu	$t3, 0($t2)		# currentChar
		beq	$t3, $t1, end_for2	# currentChar == -3 ? goto end_for2
		
		# print_char($t3)
		# print_new_line()
		print_hex($t3)
		print_new_line()
		
		addiu	$t2, $t2, 1		# currentChar++
		j	for2
	
	end_for2:

	
	
	
	exit()
	


.data
	# Allocate 9 bytes in each row becuse of the (new line + null terminator).
	rowInputBuffer:	.space 9
	
	

