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

.macro load_elem_2D(%listAddr, %rowAddr, %colAddr, %addr, %rowSize)
	# Compute for the index (as if it is in a 1D list).
	# Formula: index = (row * rowSize) + col
	mul	$t8, %rowAddr, %rowSize		# Indices 0 to (rowSize - 1) per row.
	add	$t8, $t8, %colAddr
	
	addu	$t8, %listAddr, $t8
	lbu	%addr, 0($t8)			# Return the loaded elem (store it to register %addr).
.end_macro

.macro store_elem_2D(%listAddr, %rowAddr, %colAddr, %elemAddr, %rowSize)
	# Compute for the index (as if it is in a 1D list).
	# Formula: index = (row * rowSize) + col
	mul	$t8, %rowAddr, %rowSize		# Indices 0 to (rowSize - 1) per row.
	add	$t8, $t8, %colAddr
	
	addu	$t8, %listAddr, $t8
	sb	%elemAddr, 0($t8)		# Store the elem in %elemAddr to the list %listAddr.
.end_macro

.macro copy_list_2D(%oldListAddr, %newListAddr, %noOfElems)
	move	$a0, %oldListAddr
	move	$a1, %newListAddr
	addi	$a2, $0, %noOfElems

	addi	$t8, $0, 0			# int i = 0;
	for3:
		beq	$t8, $a2, end_for3	# i == size ? goto end_for3
		
		lbu	$t7, 0($a0)
		sb	$t7, 0($a1)
		
		addiu	$a0, $a0, 1		# Increment the %oldListAddr's memory pointer by 1 byte.
		addiu	$a1, $a1, 1		# Increment the %newListAddr's memory pointer by 1 byte.
		
		addi	$t8, $t8, 1		# i++;
		j	for3
	
	end_for3:
.end_macro


# bool solve_peg_solitaire(List<List<String>> boardState);
# Param:
#	boardState: $a0 = %boardStateAddr = '(List<List<String>>) Address of the 2D board state list.'
# Return value:
#	isSolvable: $v0 = (bool) 'Returns true if the peg solitaire is solvable, otherwise return false.'
.macro fn_solve_peg_solitaire(%boardStateAddr)
	move	$a0, %boardStateAddr
	jal	solve_peg_solitaire
.end_macro


.text
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
	
	# INITIALIZE THE METADATA.
	# index 0: noOfPegs = The number of pegs remaining in the board.
	# index 1: tempFinalHoleRow - Row coordinate of the latest moved peg in its final hole.
	# index 2: tempFinalHoleCol - Column coordinate of the latest moved peg in its final hole.
	# List<int> metadata = [0, -1, -1]; // $s1
	malloc(12, $s1)
	sw	$s1, 16($gp)			# Store the list address as a global variable.
	addi	$t0, $0, -1
	sw	$0, 0($s1)			# metadata[0] = 0;
	sw	$t0, 4($s1)			# metadata[1] = -1;
	sw	$t0, 8($s1)			# metadata[2] = -1;
	
	
	# INITIALIZE THE PEG MOVES SOLUTION LIST.
	# This will be a 2-dimensional list.
	# Each row is a list of 4 integer elements. Each integer will occupy 1 byte.
	# Logically, there will be at max. of 7 rows in this list because the max. possible number of pegs
	# in a given board state is only 8. That is, at max. it will take 7 valid peg moves to find the solution.
	# Hence, (7 * 4 = 28) bytes will be needed for the pegMovesSolution list.
	#
	# The index representation of a row: [startRow, startCol, finalRow, finalCol]
	# The startRow and startCol represents the coordinate of the starting position of the moved peg.
	# The finalRow and finalCol represents the coordinate of the destination/final position of the moved peg.
	# This data will be used for displaying the move/s of the peg solitaire solution (if it exist).
	malloc(28, $s2)
	sw	$s2, 20($gp)			# Store the list address as a global variable.

	# INITIALIZE THE BOARD STATE.
	# This will be a 2-dimensional (2D) list.
	# Each row will occupy 7 bytes.
	# Hence, (7 * 7 = 49) bytes will be needed for the boardState (at minimum).
	# Although, I will allocate 52 bytes so that it will still be divisible by 4.
	# This is to preserve memory alignment (by 4). The last 3 bytes will be don't care values. 
	malloc(52, $s0)				# List<List<String>> boardState = []; // $s0
	
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
	
	fn_solve_peg_solitaire($s0)
	move	$s3, $v0			# final isSolvable; // 1 -> true; 0 -> false
	
	addi	$t0, $0, 1
	beq	$s3, $t0, if17			# isSolvable == true : goto if17
	j	else17
	
	if17:
		la	$a0, yesMsg
		do_syscall(4)			# print('YES');
		j	end_if_else17
	
	else17:
		la	$a0, noMsg
		do_syscall(4)			# print('NO');
		j	end_if_else17
	
	end_if_else17:
	
	# FREE USED HEAP MEMORIES.
	free(52)						# free(boardState);
	free(28)						# free(pegMovesSolution);
	free(12)						# free(metadata)
	
	exit()


solve_peg_solitaire:
	# INITIALIZE STACK.
	subiu	$sp, $sp, 24
	sw	$ra, 20($sp)
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$s4, 0($sp)
	
	# Get the metadata list (global variable).
	lw	$t0, 16($gp)			# List<int> metadata;

	# BASE CASES. ---------------------------------------------------------------------------------------------
	# CASE 1: There are no pegs to be moved.
	lw	$t2, 0($t0)			# int noOfPegs = metadata[0];
	beqz	$t2, if5			# noOfPegs == 0 ? goto if5
	j	end_if5
	
	if5:
		addi	$v0, $0, 0		# return 0; // false
		j	return_solve_peg_solitaire
	
	end_if5:
	
	# CASE 2: There is only 1 peg remaining. 
	lw	$s1, 4($t0)					# final int tempFinalHoleRow = metadata[1];
	lw	$s2, 8($t0)					# final int tempFinalHoleCol = metadata[2];
	
	addi	$t3, $0, 1					# constant value 1.
	beq	$t2, $t3, if6					# noOfPegs == 1 ? goto if6
	j	end_if6
	
	if6:
		addi	$v0, $0, 1			# return 1; // true
		j	return_solve_peg_solitaire
		
	end_if6:
	# BASE CASES. =============================================================================================
	
	# Perform deep copy on the boardState 2D list to produce
	# newBoardState 2D list.
	malloc(52, $s0)				# List<List<String>> newBoardState; // $s0
	copy_list_2D($a0, $s0, 49)		# newBoardState = copyList2D(boardState); // $s0
	
	# TRAVERSE EACH ELEMENTS OF THE BOARD.
	addi	$s3, $0, 0			# int r = 0;
	lbu	$t1, 0($gp)			# const int noOfRows = 7; noOfRows = noOfCols = 7
	
	for2:
		beq	$s3, $t1, end_for2		# r == 7 ? goto end_for2
		addi	$s4, $0, 0			# int c = 0;
		for3:
			beq	$s4, $t1, end_for3	# c == 7 ? goto end_for3
			
			# CHECK IF THE CURRENT ELEMENT IS A PEG.
			load_elem_2D($s0, $s3, $s4, $t2, 7)	# String boardState[r][c]; // $t2
			lbu	$t3, 2($gp)			# const String pegHole = 'o';
			beq	$t2, $t3, if8			# boardState[r][c] == 'o' ? goto if8
			j	end_if8
			
			if8:
				# Check if there is an adjacent peg relative to the current peg.
        			# While doing this, check also if the hole destination is available.
        			# The order of peg-checking: North, East, South, and then West.
        			
				# CHECK NORTH. ---------------------------------------------------------------------------------------------
				addi	$t2, $0, 1			# Constant value 1.
				bgt	$s3, $t2, if_and9_0		# r > 1 ? goto if_and9_0
				j	end_if9
				
				if_and9_0:
				subi	$t2, $s3, 1			# r - 1
				load_elem_2D($s0, $t2, $s4, $t3, 7)	# boardState[r - 1][c]; // $t3
				lbu	$t4, 2($gp)			# pegHole = 'o';
				beq	$t3, $t4, if_and9_1		# boardState[r - 1][c] == 'o' ? goto if_and9_1
				j	end_if9
				
				if_and9_1:
				subi	$t2, $s3, 2			# r - 2
				load_elem_2D($s0, $t2, $s4, $t3, 7)	# boardState[r - 2][c]; // $t3
				lbu	$t4, 1($gp)			# emptyHole = '.';
				beq	$t3, $t4, if9			# boardState[r - 2][c] == '.' ? goto if9
				j	end_if9
				
				
				if9:
					# UPDATE THE BOARD STATE.
					# Make the coordinate of the jumping peg empty.
					lbu	$t3, 1($gp)			# emptyHole = '.';
					store_elem_2D($s0, $s3, $s4, $t3, 7)	# newBoardState[r][c] = '.';
					
					# Delete the peg in the jumped-over hole.
					subi	$t4, $s3, 1			# r - 1
					store_elem_2D($s0, $t4, $s4, $t3, 7)	# newBoardState[r - 1][c] = '.';
					
					# Put the peg on the new coordinate.
					subi	$t4, $s3, 2			# r - 2
					lbu	$t3, 2($gp)			# pegHole = 'o';
					store_elem_2D($s0, $t4, $s4, $t3, 7)	# newBoardState[r - 2][c] = 'o';
					
					# UPDATE THE METATADA (noOfPegs, tempFinalHoleRow, tempFinalHoleCol).
					# Decrement noOfPegs by 1.
					# metadata[0] = metadata[0] - 1;
					lw	$t3, 0($t0)			# noOfPegs = metadata[0];
					subi	$t3, $t3, 1			# noOfPegs--;
					sw	$t3, 0($t0)
					
					# Determine the new tempFinalHole coordinate.
					subi	$t3, $s3, 2			# r - 2;
					sw	$t3, 4($t0)			# metadata[1] = r - 2;
					sw	$s4, 8($t0)			# metadata[2] = c;
					
					# RECUR: CALL THIS FUNCTION AGAIN USING THE NEW BOARD STATE
					# (AND IMPLICITY, THE NEW METADATA).
					fn_solve_peg_solitaire($s0)
					
					# 1 is true, 0 is false.
					bgtz  	$v0, if10			# isSolvable == true ? goto if10
					j	else10
					
					if10:
						# ADD THE MOVE DETAILS TO THE PEG MOVES SOLUTION LIST.
						lbu	$t2, 5($gp)		# int nPegMoves;
						sll	$t3, $t2, 2		# nPegMoves = nPegMoves * 4; // Memory address offset.
						lw	$t4, 20($gp)		# List<List<int>> pegMovesSolution;
						
						# Right-adjacent position pointer to the most recent
						# element in the pegMovesSolution list.
						addu	$t3, $t3, $t4
						
						sb	$s3, 0($t3)		# r (startRow)
						sb	$s4, 1($t3)		# c (startCol)
						subi	$t4, $s3, 2		# r - 2
						sb	$t4, 2($t3)		# r - 2 (finalRow)
						sb	$s4, 3($t3)		# c (finalCol)
						
						# Update the pegMovesSolution list size.
						addi	$t2, $t2, 1		# nPegMoves++;
						sb	$t2, 5($gp)
						
						addi	$v0, $0, 1		# return 1; // true
						j	return_prep_solve_peg_solitaire
						
					else10:
						# IF NOT SOLVABLE, THEN REVERT BACK THE BOARD STATE TO ITS PREVIOUS VALUE.
						# Put back the jumping peg to its original coordinate.
						lbu	$t2, 2($gp)			# pegHole = 'o';
						store_elem_2D($s0, $s3, $s4, $t2, 7)	# newBoardState[r][c] = 'o';
						
						# Put back the jumped over peg.
						subi	$t3, $s3, 1			# r - 1
						store_elem_2D($s0, $t3, $s4, $t2, 7)	# newBoardState[r - 1][c] = 'o';
						
						# Remove the should the peg on the final/landing coordinate.
						subi	$t3, $s3, 2			# r - 2
						lbu	$t2, 1($gp)			# pegHole = 'o';
						store_elem_2D($s0, $t3, $s4, $t2, 7)	# newBoardState[r - 2][c] = '.';
					
						# IF NOT SOLVABLE, THEN REVERT BACK THE METADATA TO ITS PREVIOUS VALUE.
						# metadata[0] = metadata[0] + 1;
						lw	$t2, 0($t0)		# noOfPegs = metadata[0];
						addi	$t2, $t2, 1		# noOfPegs++;
						sw	$t2, 0($t0)
						
						sw	$s1, 4($t0)		# metadata[1] = oldTempFinalHoleRow;
						sw	$s2, 8($t0)		# metadata[2] = oldTempFinalHoleColumn;
						
					end_if10:
					
				end_if9:
				# CHECK NORTH. =============================================================================================
				
				# CHECK EAST. ----------------------------------------------------------------------------------------------
				addi	$t2, $0, 5			# Constant value 5.
				blt	$s4, $t2, if_and11_0		# c < 5 ? goto if_and11_0
				j	end_if11
				
				if_and11_0:
				addi	$t2, $s4, 1			# c + 1
				load_elem_2D($s0, $s3, $t2, $t3, 7)	# boardState[r][c + 1]; // $t3
				lbu	$t4, 2($gp)			# pegHole = 'o';
				beq	$t3, $t4, if_and11_1		# boardState[r][c + 1] == 'o' ? goto if_and11_1
				j	end_if11
				
				if_and11_1:
				addi	$t2, $s4, 2			# c + 2
				load_elem_2D($s0, $s3, $t2, $t3, 7)	# boardState[r][c + 2]; // $t3
				lbu	$t4, 1($gp)			# emptyHole = '.';
				beq	$t3, $t4, if11			# boardState[r][c + 2] == '.' ? goto if11
				j	end_if11
				
				
				if11:
					# UPDATE THE BOARD STATE.
					# Make the coordinate of the jumping peg empty.
					lbu	$t3, 1($gp)			# emptyHole = '.';
					store_elem_2D($s0, $s3, $s4, $t3, 7)	# newBoardState[r][c] = '.';
					
					# Delete the peg in the jumped-over hole.
					addi	$t4, $s4, 1			# c + 1
					store_elem_2D($s0, $s3, $t4, $t3, 7)	# newBoardState[r][c + 1] = '.';
					
					# Put the peg on the new coordinate.
					addi	$t4, $s4, 2			# c + 2
					lbu	$t3, 2($gp)			# pegHole = 'o';
					store_elem_2D($s0, $s3, $t4, $t3, 7)	# newBoardState[r][c + 2] = 'o';
					
					# UPDATE THE METATADA (noOfPegs, tempFinalHoleRow, tempFinalHoleCol).
					# Decrement noOfPegs by 1.
					# metadata[0] = metadata[0] - 1;
					lw	$t3, 0($t0)			# noOfPegs = metadata[0];
					subi	$t3, $t3, 1			# noOfPegs--;
					sw	$t3, 0($t0)
					
					# Determine the new tempFinalHole coordinate.
					sw	$s3, 4($t0)			# metadata[1] = r;
					addi	$t3, $s4, 2			# c + 2
					sw	$t3, 8($t0)			# metadata[2] = c + 2;
					
					# RECUR: CALL THIS FUNCTION AGAIN USING THE NEW BOARD STATE
					# (AND IMPLICITY, THE NEW METADATA).
					fn_solve_peg_solitaire($s0)
					
					# 1 is true, 0 is false.
					bgtz  	$v0, if12			# isSolvable == true ? goto if12
					j	else12
					
					if12:
						# ADD THE MOVE DETAILS TO THE PEG MOVES SOLUTION LIST.
						lbu	$t2, 5($gp)		# int nPegMoves;
						sll	$t3, $t2, 2		# nPegMoves = nPegMoves * 2; // Memory address offset.
						lw	$t4, 20($gp)		# List<List<int>> pegMovesSolution;
						
						# Right-adjacent position pointer to the most recent
						# element in the pegMovesSolution list.
						addu	$t3, $t3, $t4
						
						sb	$s3, 0($t3)		# r (startRow)
						sb	$s4, 1($t3)		# c (startCol)
						sb	$s3, 2($t3)		# r (finalRow)
						addi	$t4, $s4, 2		# c + 2
						sb	$t4, 3($t3)		# c + 2 (finalCol)
						
						# Update the pegMovesSolution list size.
						addi	$t2, $t2, 1		# nPegMoves++;
						sb	$t2, 5($gp)
						
						addi	$v0, $0, 1		# return 1; // true
						j	return_prep_solve_peg_solitaire
						
					else12:
						# IF NOT SOLVABLE, THEN REVERT BACK THE BOARD STATE TO ITS PREVIOUS VALUE.
						# Put back the jumping peg to its original coordinate.
						lbu	$t2, 2($gp)			# pegHole = 'o';
						store_elem_2D($s0, $s3, $s4, $t2, 7)	# newBoardState[r][c] = 'o';
						
						# Put back the jumped over peg.
						addi	$t3, $s4, 1			# c + 1
						store_elem_2D($s0, $s3, $t3, $t2, 7)	# newBoardState[r][c + 1] = 'o';
						
						# Remove the should the peg on the final/landing coordinate.
						addi	$t3, $s4, 2			# c + 2
						lbu	$t2, 1($gp)			# pegHole = 'o';
						store_elem_2D($s0, $s3, $t3, $t2, 7)	# newBoardState[r][c + 2] = '.';
					
						# IF NOT SOLVABLE, THEN REVERT BACK THE METADATA TO ITS PREVIOUS VALUE.
						# metadata[0] = metadata[0] + 1;
						lw	$t2, 0($t0)		# noOfPegs = metadata[0];
						addi	$t2, $t2, 1		# noOfPegs++;
						sw	$t2, 0($t0)
						
						sw	$s1, 4($t0)		# metadata[1] = oldTempFinalHoleRow;
						sw	$s2, 8($t0)		# metadata[2] = oldTempFinalHoleColumn;
						
					end_if12:
					
				end_if11:
				# CHECK EAST. ==============================================================================================
				
				# CHECK SOUTH. ---------------------------------------------------------------------------------------------
				addi	$t2, $0, 5			# Constant value 5.
				blt	$s3, $t2, if_and13_0		# r < 5 ? goto if_and13_0
				j	end_if13
				
				if_and13_0:
				addi	$t2, $s3, 1			# r + 1
				load_elem_2D($s0, $t2, $s4, $t3, 7)	# boardState[r + 1][c]; // $t3
				lbu	$t4, 2($gp)			# pegHole = 'o';
				beq	$t3, $t4, if_and13_1		# boardState[r + 1][c] == 'o' ? goto if_and13_1
				j	end_if13
				
				if_and13_1:
				addi	$t2, $s3, 2			# r + 2
				load_elem_2D($s0, $t2, $s4, $t3, 7)	# boardState[r + 2][c]; // $t3
				lbu	$t4, 1($gp)			# emptyHole = '.';
				beq	$t3, $t4, if13			# boardState[r + 2][c] == '.' ? goto if13
				j	end_if13
				
				
				if13:
					# UPDATE THE BOARD STATE.
					# Make the coordinate of the jumping peg empty.
					lbu	$t3, 1($gp)			# emptyHole = '.';
					store_elem_2D($s0, $s3, $s4, $t3, 7)	# newBoardState[r][c] = '.';
					
					# Delete the peg in the jumped-over hole.
					addi	$t4, $s3, 1			# r + 1
					store_elem_2D($s0, $t4, $s4, $t3, 7)	# newBoardState[r + 1][c] = '.';
					
					# Put the peg on the new coordinate.
					addi	$t4, $s3, 2			# r + 2
					lbu	$t3, 2($gp)			# pegHole = 'o';
					store_elem_2D($s0, $t4, $s4, $t3, 7)	# newBoardState[r + 2][c] = 'o';
					
					# UPDATE THE METATADA (noOfPegs, tempFinalHoleRow, tempFinalHoleCol).
					# Decrement noOfPegs by 1.
					# metadata[0] = metadata[0] - 1;
					lw	$t3, 0($t0)			# noOfPegs = metadata[0];
					subi	$t3, $t3, 1			# noOfPegs--;
					sw	$t3, 0($t0)
					
					# Determine the new tempFinalHole coordinate.
					addi	$t3, $s3, 2			# r + 2
					sw	$t3, 4($t0)			# metadata[1] = r + 2;
					sw	$s4, 8($t0)			# metadata[2] = c;
					
					# RECUR: CALL THIS FUNCTION AGAIN USING THE NEW BOARD STATE
					# (AND IMPLICITY, THE NEW METADATA).
					fn_solve_peg_solitaire($s0)
					
					# 1 is true, 0 is false.
					bgtz  	$v0, if14			# isSolvable == true ? goto if14
					j	else14
					
					if14:
						# ADD THE MOVE DETAILS TO THE PEG MOVES SOLUTION LIST.
						lbu	$t2, 5($gp)		# int nPegMoves;
						sll	$t3, $t2, 2		# nPegMoves = nPegMoves * 4; // Memory address offset.
						lw	$t4, 20($gp)		# List<List<int>> pegMovesSolution;
						
						# Right-adjacent position pointer to the most recent
						# element in the pegMovesSolution list.
						addu	$t3, $t3, $t4
						
						sb	$s3, 0($t3)		# r (startRow)
						sb	$s4, 1($t3)		# c (startCol)
						addi	$t4, $s3, 2		# r + 2
						sb	$t4, 2($t3)		# r + 2 (finalRow)
						sb	$s4, 3($t3)		# c (finalCol)
						
						# Update the pegMovesSolution list size.
						addi	$t2, $t2, 1		# nPegMoves++;
						sb	$t2, 5($gp)
						
						addi	$v0, $0, 1		# return 1; // true
						j	return_prep_solve_peg_solitaire
						
					else14:
						# IF NOT SOLVABLE, THEN REVERT BACK THE BOARD STATE TO ITS PREVIOUS VALUE.
						# Put back the jumping peg to its original coordinate.
						lbu	$t2, 2($gp)			# pegHole = 'o';
						store_elem_2D($s0, $s3, $s4, $t2, 7)	# newBoardState[r][c] = 'o';
						
						# Put back the jumped over peg.
						addi	$t3, $s3, 1			# r + 1
						store_elem_2D($s0, $t3, $s4, $t2, 7)	# newBoardState[r + 1][c] = 'o';
						
						# Remove the should the peg on the final/landing coordinate.
						addi	$t3, $s3, 2			# r + 2
						lbu	$t2, 1($gp)			# pegHole = 'o';
						store_elem_2D($s0, $t3, $s4, $t2, 7)	# newBoardState[r + 2][c] = '.';
					
						# IF NOT SOLVABLE, THEN REVERT BACK THE METADATA TO ITS PREVIOUS VALUE.
						# metadata[0] = metadata[0] + 1;
						lw	$t2, 0($t0)		# noOfPegs = metadata[0];
						addi	$t2, $t2, 1		# noOfPegs++;
						sw	$t2, 0($t0)
						
						sw	$s1, 4($t0)		# metadata[1] = oldTempFinalHoleRow;
						sw	$s2, 8($t0)		# metadata[2] = oldTempFinalHoleColumn;
						
					end_if14:
					
				end_if13:
				# CHECK SOUTH. =============================================================================================
				
				# CHECK WEST. ----------------------------------------------------------------------------------------------
				addi	$t2, $0, 1			# Constant value 1.
				bgt	$s4, $t2, if_and15_0		# c > 1 ? goto if_and15_0
				j	end_if15
				
				if_and15_0:
				subi	$t2, $s4, 1			# c - 1
				load_elem_2D($s0, $s3, $t2, $t3, 7)	# boardState[r][c - 1]; // $t3
				lbu	$t4, 2($gp)			# pegHole = 'o';
				beq	$t3, $t4, if_and15_1		# boardState[r + 1][c] == 'o' ? goto if_and15_1
				j	end_if15
				
				if_and15_1:
				subi	$t2, $s4, 2			# c - 2
				load_elem_2D($s0, $s3, $t2, $t3, 7)	# boardState[r][c - 2]; // $t3
				lbu	$t4, 1($gp)			# emptyHole = '.';
				beq	$t3, $t4, if15			# boardState[r + 2][c] == '.' ? goto if15
				j	end_if15
				
				
				if15:
					# UPDATE THE BOARD STATE.
					# Make the coordinate of the jumping peg empty.
					lbu	$t3, 1($gp)			# emptyHole = '.';
					store_elem_2D($s0, $s3, $s4, $t3, 7)	# newBoardState[r][c] = '.';
					
					# Delete the peg in the jumped-over hole.
					subi	$t4, $s4, 1			# c - 1
					store_elem_2D($s0, $s3, $t4, $t3, 7)	# newBoardState[r][c - 1]= '.';
					
					# Put the peg on the new coordinate.
					subi	$t4, $s4, 2			# c - 2
					lbu	$t3, 2($gp)			# pegHole = 'o';
					store_elem_2D($s0, $s3, $t4, $t3, 7)	# newBoardState[r][c - 2] = 'o';
					
					# UPDATE THE METATADA (noOfPegs, tempFinalHoleRow, tempFinalHoleCol).
					# Decrement noOfPegs by 1.
					# metadata[0] = metadata[0] - 1;
					lw	$t3, 0($t0)			# noOfPegs = metadata[0];
					subi	$t3, $t3, 1			# noOfPegs--;
					sw	$t3, 0($t0)
					
					# Determine the new tempFinalHole coordinate.
					sw	$s3, 4($t0)			# metadata[1] = r;
					subi	$t3, $s4, 2			# c - 2
					sw	$t3, 8($t0)			# metadata[2] = c - 2;
					
					# RECUR: CALL THIS FUNCTION AGAIN USING THE NEW BOARD STATE
					# (AND IMPLICITY, THE NEW METADATA).
					fn_solve_peg_solitaire($s0)
					
					# 1 is true, 0 is false.
					bgtz  	$v0, if16			# isSolvable == true ? goto if16
					j	else16
					
					if16:
						# ADD THE MOVE DETAILS TO THE PEG MOVES SOLUTION LIST.
						lbu	$t2, 5($gp)		# int nPegMoves;
						sll	$t3, $t2, 2		# nPegMoves = nPegMoves * 4; // Memory address offset.
						lw	$t4, 20($gp)		# List<List<int>> pegMovesSolution;
						
						# Right-adjacent position pointer to the most recent
						# element in the pegMovesSolution list.
						addu	$t3, $t3, $t4
						
						sb	$s3, 0($t3)		# r (startRow)
						sb	$s4, 1($t3)		# c (startCol)
						sb	$s3, 2($t3)		# r (finalRow)
						subi	$t4, $s4, 2		# c - 2
						sb	$t4, 3($t3)		# c - 2 (finalCol)
						
						# Update the pegMovesSolution list size.
						addi	$t2, $t2, 1		# nPegMoves++;
						sb	$t2, 5($gp)
						
						addi	$v0, $0, 1		# return 1; // true
						j	return_prep_solve_peg_solitaire
						
					else16:
						# IF NOT SOLVABLE, THEN REVERT BACK THE BOARD STATE TO ITS PREVIOUS VALUE.
						# Put back the jumping peg to its original coordinate.
						lbu	$t2, 2($gp)			# pegHole = 'o';
						store_elem_2D($s0, $s3, $s4, $t2, 7)	# newBoardState[r][c] = 'o';
						
						# Put back the jumped over peg.
						subi	$t3, $s4, 1			# c - 1
						store_elem_2D($s0, $s3, $t3, $t2, 7)	# newBoardState[r][c - 1] = 'o';
						
						# Remove the should the peg on the final/landing coordinate.
						subi	$t3, $s4, 2			# c - 2
						lbu	$t2, 1($gp)			# pegHole = 'o';
						store_elem_2D($s0, $s3, $t3, $t2, 7)	# newBoardState[r][c - 2] = '.';
					
						# IF NOT SOLVABLE, THEN REVERT BACK THE METADATA TO ITS PREVIOUS VALUE.
						# metadata[0] = metadata[0] + 1;
						lw	$t2, 0($t0)		# noOfPegs = metadata[0];
						addi	$t2, $t2, 1		# noOfPegs++;
						sw	$t2, 0($t0)
						
						sw	$s1, 4($t0)		# metadata[1] = oldTempFinalHoleRow;
						sw	$s2, 8($t0)		# metadata[2] = oldTempFinalHoleColumn;
						
					end_if16:
					
				end_if15:
				# CHECK WEST. ==============================================================================================
				
			end_if8:
			
			addi	$s4, $s4, 1		# c++;
			j	for3
			
		end_for3:
		
		addi	$s3, $s3, 1		# r++;
		j	for2
		
	end_for2:
	
	# RETURN FALSE IF NO SOLUTION WAS FOUND FOR THIS BOARD STATE.
	addi	$v0, $0, 0			# return 0;
	
return_prep_solve_peg_solitaire:
	# Deallocate the memory that the boardState 2D list
	# used in this function stack.
	free(52)

return_solve_peg_solitaire:
	# DECOMPOSE STACK.
	lw	$ra, 20($sp)
	lw	$s0, 16($sp)
	lw	$s1, 12($sp)
	lw	$s2, 8($sp)
	lw	$s3, 4($sp)
	lw	$s4, 0($sp)
	addiu	$sp, $sp, 24
	jr	$ra


.data
	# Allocate 9 bytes in each row becuse of the (new line + null terminator).
	rowInputBuffer:	.space 9
	yesMsg: 	.asciiz "YES"
	noMsg:		.asciiz "NO"
	rightArrow:	.asciiz "->"
	comma:		.asciiz ","
	
