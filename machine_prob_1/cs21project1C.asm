# CS 21 LAB 2 -- S1 AY 2022-2023
# Marc Peejay Viernes -- 2022/OCT/24
# cs21project1C.asm -- Peg solitaire solver.


.eqv	nRows 0x00000007		# Number of rows.
.eqv	emptyHole 0x0000002E		# '.' : A hole with no peg.
.eqv	pegHole 0x0000006F		# 'o' : A hole with a peg.
.eqv	woPegFinalHole 0x00000045	# 'E' : Final hole w/o a peg.
.eqv	wPegFinalHole 0x0000004F	# 'O' : Final hole w/ a peg.
.eqv	heapPtr	$t9			# Will serve as the heap pointer and nothing else.
.eqv	heapBasePtr 0x10040000		# Base address for the heap memory.
.eqv	newLine 0x0000000a		# '/n' : New line.


.macro do_syscall(%code)
	addi	$v0, $0, %code
	syscall
.end_macro

.macro exit
	do_syscall(10)
.end_macro

.macro print_int(%intAddr)
	move	$a0, %intAddr		# Prepare the integer value.
	do_syscall(1)			# Print integer syscall.
.end_macro

.macro print_hex(%hexAddr)
	move	$a0, %hexAddr		# Prepare the hexadecimal value.
	do_syscall(34)			# Print hexadecimal syscall.
.end_macro

.macro print_char(%charAddr)
	move	$a0, %charAddr		# Prepare the ASCII value.
	do_syscall(11)			# Print ASCII character syscall.
.end_macro

.macro print_new_line
	addiu	$a0, $0, 0x0000000a	# 10: New line ASCII code (base 10).
	print_char($a0)		
.end_macro

.macro print_str(%dataLabel)
	la	$a0, %dataLabel		# Address of the String.
	do_syscall(4)			# Print String syscall.
.end_macro
	
.macro read_str(%dataLabel, %size %addr)
	la	$a0, %dataLabel	# Loads String buffer address.
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

.macro load_elem_2D(%listAddr, %rowAddr, %colAddr, %addr)
	# Compute for the index (as if it is in a 1D list).
	# Formula: index = (row * 7) + col
	mul	$a0, %rowAddr, 7		# Indices 0 to 6 per row.
	add	$a0, $a0, %colAddr
	
	addu	$a0, %listAddr, $a0
	lbu	%addr, 0($a0)			# Return the loaded elem (store it to register %addr).
.end_macro

.macro store_elem_2D(%listAddr, %rowAddr, %colAddr, %elemAddr)
	# Compute for the index (as if it is in a 1D list).
	# Formula: index = (row * 7) + col
	mul	$a0, %rowAddr, 7		# Indices 0 to 6 per row.
	add	$a0, $a0, %colAddr
	
	addu	$a0, %listAddr, $a0
	sb	%elemAddr, 0($a0)		# Store the elem in %elemAddr to the list %listAddr.
.end_macro


# bool solve_solitaire_peg(List<List<String>> boardState, List<int> metadata);
# Params:
#	boardState: $a0 = %boardStateAddr = '(List<List<String>>) Address of the 2D board state list.'
#	metadata: $a1 = %metadataAddr	= '(List<int>) Address of the 1D metadata list.'
# Return value:
#	isSolvable: $v0 = (bool) 'Returns true if the peg solitaire is solvable, otherwise return false.'
.macro fn_solve_solitaire_peg(%boardStateAddr, %metadataAddr)
	move	$a0, %boardStateAddr
	move	$a0, %metadataAddr
	jal	solve_solitaire_peg
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
	# The number of peg moves of the solution.
	sb	$0, 5($gp)			# int nPegMoves = 0;
	
	addi	$t0, $0 -1
	# Offset is 8 to maintain memory alignment (by 4).
	sw	$t0, 8($gp)			# int finalHoleRow = -1;
	sw	$t0, 12($gp)			# int finalHoleCol = -1;
	
	# INITIALIZE THE HEAP POINTER.
	# $t9 will be the heapPtr in order to effectively
	# manage the allocation and deallocation of the heap memory.
	addiu	heapPtr, $0, heapBasePtr	# int heapPtr = 0x10040000;		

	# INITIALIZE THE BOARD STATE.
	# This will be a 2-dimensional (2D) list.
	# Each row will occupy 7 bytes.
	# Hence, (7 * 7 = 49) bytes will be needed for the boardState (at minimum).
	# Although, I will allocate 52 bytes so that it will still be divisible by 4.
	# This is to preserve memory alignment (by 4). The last 3 bytes will be don't care values. 
	malloc(52, $s0)				# List<List<String>> boardState = []; // $s0
	
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
	
	# INITIALIZE THE PEG MOVES SOLUTION LIST.
	# This will be a 2-dimensional list.
	# Each row is a list of 4 integer elements. Each integer will occupy 4 bytes (i.e., 1 word).
	# Logically, there will be at max. of 7 rows in this list because the max. possible number of pegs
	# in a given board state is only 8. That is, at max. it will take 7 valid peg moves to find the solution.
	# Hence, (7 * (4 * 4) = 112) bytes will be needed for the pegMovesSolution list.
	#
	# The index representation of a row: [startRow, startCol, finalRow, finalCol]
	# The startRow and startCol represents the coordinate of the starting position of the moved peg.
	# The finalRow and finalCol represents the coordinate of the destination/final position of the moved peg.
	# This data will be used for displaying the move/s of the peg solitaire solution (if it exist).
	malloc(112, $s2)
	
	# FETCH AND DECODE THE RAW INPUTS. -----------------------------------------------------------------------------------
	addi	$t0, $0, 0			# int r = 0;
	lbu	$t1, 0($gp)			# nRows = 7;
	move	$t5, $s0			# Memory pointer to the chars of boardState.
	
	# Loop through all the rows.
	for0:
		beq	$t0, $t1, end_for0	# r == nRows ? goto end_for0
		
		# 7 bytes + new line + null terminator = 9 bytes
		read_str(rowInputBuffer, 9, $t2)	# final String tempRow = input(); // $t2
		addi	$t3, $0, 0			# int c = 0;
		
		# Loop through all the characters in the row.
		for1:
			beq	$t3, $t1, end_for1	# c == nCols ? got end_for1
			lbu	$t4, 0($t2)		# final String currentChar = tempRow[c]; // $t4
			
			print_char($t4)
			print_new_line()
			
			# UPDATE THE NUMBER OF PEGS.
			lbu	$t6, 2($gp)		# pegHole = 'o';
			beq	$t4, $t6, if0		# currentChar == pegHole ? goto if0
			lbu	$t6, 4($gp)		# wPegFinalHole = 'O';
			beq	$t4, $t6, if0		# currentChar == wPegFinalHole ? goto if0
			j	end_if0
			
			if0:
				lw	$t6, 0($s1)	# metadata[0]; // noOfPegs
				addi	$t6, $t6, 1	# noOfPegs++;
				sw	$t6, 0($s1)	# Store it right back.
				
				# GET THE COORDINATE OF THE FIRST PEG.
				lw	$t6, 4($s1)	# metadata[1]; // tempFinalHoleRow
				bltz	$t6, if1	# tempFinalHoleRow < 0 ? goto if1
				j	end_if1
				
				if1:
					sw	$t0, 4($s1)	# metadata[1] = r; // tempFinalHoleRow = r
					sw	$t3, 8($s1)	# metadata[2] = c; // tempFinalHoleCol = c
				
				end_if1:
				
			end_if0:
			
			# DETERMINE THE COORDINATE OF THE DESTINATION/FINAL HOLE.
			lw	$t6, 8($gp)		# finalHoleRow;
			bltz	$t6, if2		# finalHoleRow < 0 ? goto if2
			j	end_if2
			
			if2:
				# DETERMINE IF IT IS A FINAL HOLE W/ A PEG.
				lbu	$t6, 4($gp)		# wPegFinalHole = 'O';
				beq	$t4, $t6, if3		# currentChar == 'O' ? goto if3
				j	end_if3
				
				if3:
					# Tranform 'O' to 'o'
					lbu	$t4, 2($gp)	# currentChar = 'o';
					sw	$t0, 8($gp)	# finalHoleRow = r;
					sw	$t3, 12($gp)	# finalHoleCol = c;
					j	end_if2		# continue;
				
				end_if3:
				
				# DETERMINE IF IT IS A FINAL HOLE W/O A PEG.
				lbu	$t6, 3($gp)		# woPegFinalHole = 'E';
				beq	$t4, $t6, if4		# currentChar == 'E' ? goto if4
				j	end_if4
				
				if4:
					# Tranform 'E' to '.'
					lbu	$t4, 1($gp)	# emptyHole = '.';
					sw	$t0, 8($gp)	# finalHoleRow = r;
					sw	$t3, 12($gp)	# finalHoleCol = c;
				
				end_if4:
			
			end_if2:
			
			sb	$t4, 0($t5)		# Store the currentChar to the boardState.
			
			addiu	$t2, $t2, 1		# Increment the rowInputBuffer's memory pointer by 1 byte.
			addiu	$t5, $t5, 1		# Increment the boardState's memory pointer by 1 byte.
			addi	$t3, $t3, 1		# c++;
			j	for1
		
		end_for1:
		
		addi	$t0, $t0, 1		# r++;
		j	for0
	
	end_for0:
		
	# FETCH AND DECODE THE RAW INPUTS. ===================================================================================
	
	print_new_line()
	
	addi	$t0, $0, 0			# int i = 0;
	addi	$t1, $0, 49			# int size = 49; // 7 * 7 = 49 chars
	move	$t2, $s0			# Memory pointer to the chars of boardState.

	print_new_line()
	
	for2:
		beq	$t0, $t1, end_for2	# i == 49 ? goto end_for2
		
		lbu	$t3, 0($t2)		# currentChar
		
		# print_char($t3)
		# print_new_line()
		print_char($t3)
		print_new_line()
		
		addiu	$t2, $t2, 1		# currentChar++
		addi	$t0, $t0, 1		# i++;
		j	for2
	
	end_for2:
	
	print_new_line()

	lw	$t0, 0($s1)
	print_int($t0)				# noOfPegs;
	print_new_line()
	
	lw	$t0, 4($s1)
	print_int($t0)				# tempFinalHoleRow;
	print_new_line()
	
	lw	$t0, 8($s1)
	print_int($t0)				# tempFinalHoleCol;
	print_new_line()
	
	lw	$t0, 8($gp)
	print_int($t0)				# finalHoleRow;
	print_new_line()
	
	lw	$t0, 12($gp)
	print_int($t0)				# finalHoleCol;
	print_new_line()
	print_new_line()
	
	
	# Access list elements using this notation: myList[r][c];
	addi	$t0, $0, 0			# int r = 0;
	lbu	$t1, 0($gp)			# size = 7;
	
	t_for1:
		beq	$t0, $t1, t_end_for1	# r == size ? goto t_end_for1
		
		addi	$t2, $0, 0		# int c = 0;
		t_for2:
			beq	$t2, $t1, t_end_for2	# c == size ? goto t_end_for2
			
			load_elem_2D($s0, $t0, $t2, $t3)
			print_char($t3)
			
			addi	$t2, $t2, 1		# c++;
			j	t_for2
		
		t_end_for2:
		
		print_new_line()
		
		addi	$t0, $t0, 1		# r++;
		j	t_for1
	
	t_end_for1:
	
	print_new_line()
	
	addi	$t4, $0, 69
	addi	$t0, $0, 0			# int r = 0;
	lbu	$t1, 0($gp)			# size = 7;
	
	t_for3:
		beq	$t0, $t1, t_end_for3
		
		addi	$t2, $0, 0		# int c = 0;
		t_for4:
			beq	$t2, $t1, t_end_for4
			
			store_elem_2D($s0, $t0, $t2, $t4)
			load_elem_2D($s0, $t0, $t2, $t3)
			print_char($t3)
			
			addi	$t2, $t2, 1		# c++;
			j	t_for4
		
		t_end_for4:
		
		print_new_line()
		
		addi	$t0, $t0, 1		# r++;
		j	t_for3
	
	t_end_for3:
	
	print_new_line()
	
	
	exit()


solve_solitaire_peg:
	# INITIALIZE STACK.
	subiu	$sp, $sp, 32
	sw	$s0, 28($sp)
	sw	$s1, 24($sp)
	sw	$s2, 20($sp)
	sw	$s3, 16($sp)
	sw	$s4, 12($sp)
	sw	$s5, 8($sp)
	sw	$s6, 4($sp)
	sw	$s7, 0($sp)

	# BASE CASES.
	# Case 1: There are no pegs to be moved.
	
	


return_solve_solitaire_peg:
	# DECOMPOSE STACK.
	lw	$s0, 28($sp)
	lw	$s1, 24($sp)
	lw	$s2, 20($sp)
	lw	$s3, 16($sp)
	lw	$s4, 12($sp)
	lw	$s5, 8($sp)
	lw	$s6, 4($sp)
	lw	$s7, 0($sp)
	addiu	$sp, $sp, 32
	jr	$ra



	
.data
	# Allocate 9 bytes in each row becuse of the (new line + null terminator).
	rowInputBuffer:	.space 9
	
	

