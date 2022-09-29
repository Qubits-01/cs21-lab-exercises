# CS 21 LAB 2 -- S1 AY 2022-2023
# Marc Peejay Viernes -- 2022/SEPT/28
# floydwarshall.asm -- Floyd-Warshall algorithm in MIPS

.eqv	N	4	# Number of nodes.
.eqv	INF	0x7fffffff
.eqv	no_of_rows	4
.eqv	no_of_columns	4
.eqv	ctr_a	$t0
.eqv	ctr_b	$t1
.eqv	ctr_c	$t2
.eqv	temp_address	$t3
.eqv	temp_elem	$t4
.eqv	offset	$t7
.eqv	min	$s4
.eqv	sum	$s5

.macro do_syscall(%n)
	addi	$v0, $0, %n
	syscall
.end_macro

.macro print_str(%label)
	la	$a0, %label
	do_syscall(4)
.end_macro

.macro print_char(%ascii_dec)
	addi	$a0, $0, %ascii_dec
	do_syscall(11)
.end_macro

.macro print_new_line
	print_char(10)
.end_macro

.macro print_space
	print_char(32)
.end_macro

.macro print_elem(%elem)
	move	$a0, %elem
	do_syscall(1)
	print_new_line()
.end_macro

.macro exit
	do_syscall(10)
.end_macro

.macro print_matrix
	la	temp_address, matrix
	
	# Too tired to do for-loop :(
	lw	temp_elem, 0(temp_address)
	print_elem(temp_elem)
	lw	temp_elem, 4(temp_address)
	print_elem(temp_elem)
	lw	temp_elem, 8(temp_address)
	print_elem(temp_elem)
	lw	temp_elem, 12(temp_address)
	print_elem(temp_elem)
	lw	temp_elem, 16(temp_address)
	print_elem(temp_elem)
	lw	temp_elem, 20(temp_address)
	print_elem(temp_elem)
	lw	temp_elem, 24(temp_address)
	print_elem(temp_elem)
	lw	temp_elem, 28(temp_address)
	print_elem(temp_elem)
	lw	temp_elem, 32(temp_address)
	print_elem(temp_elem)
	lw	temp_elem, 36(temp_address)
	print_elem(temp_elem)
	lw	temp_elem, 40(temp_address)
	print_elem(temp_elem)
	lw	temp_elem, 44(temp_address)
	print_elem(temp_elem)
	lw	temp_elem, 48(temp_address)
	print_elem(temp_elem)
	lw	temp_elem, 52(temp_address)
	print_elem(temp_elem)
	lw	temp_elem, 56(temp_address)
	print_elem(temp_elem)
	lw	temp_elem, 60(temp_address)
	print_elem(temp_elem)
	
	print_new_line()
.end_macro

.macro	get_elem(%r, %c, %elem)
	addi	$s0, $0, 16	# Row byte count
	addi	$s1, $0, 4	# Column byte count.
	
	# offset = (r * 16) + (c * 4)
	mult	%r, $s0
	mflo	$t5
	mult	%c, $s1
	mflo	$t6
	add	offset, $t5, $t6
	
	la	temp_address, matrix	# Get the base address of matrix.
	addu	temp_address, temp_address, offset	# Addjust the address w/ the offset.
	lw	%elem, 0(temp_address)
.end_macro

.macro	store_elem(%r, %c, %elem)
	addi	$s0, $0, 16	# Row byte count
	addi	$s1, $0, 4	# Column byte count.
	
	# offset = (r * 16) + (c * 4)
	mult	%r, $s0
	mflo	$t5
	mult	%c, $s1
	mflo	$t6
	add	offset, $t5, $t6
	
	la	temp_address, matrix	# Get the base address of matrix.
	addu	temp_address, temp_address, offset	# Addjust the address w/ the offset.
	sw	%elem, 0(temp_address)
.end_macro

.macro custom_add(%a, %b, %sum)
		li	$t5, INF	# Initialize INF value
		
		# If one of the operands is INF, then the sum is
		# automatically INF.
		beq	%a, $t5, else
		beq	%b, $t5, else
		
		add	%sum, %a, %b
		j	end
		
	else:
		move	%sum, $t5
		
	end:
.end_macro

.macro	get_min(%a, %b, %min)
		ble	%a, %b, else
		move	%min, %b
		j	end
				
	else:
		move	%min, %a
	end:
.end_macro

.text
main:
	# Before-state of the matrix.
	print_matrix()
	
	# Start of for-loop 0 -------------------------------------------------
	addi	ctr_a, $0, 0
	
	for_0:
		bge	ctr_a, N, end_0	# ctr_a: 0 to 3
		
		# Start of for-loop 1 -------------------------------------------------
		addi	ctr_b, $0, 0
		
		for_1:
			bge	ctr_b, N, end_1	# ctr_b: 0 to 3
			
			# Start of for-loop 2 -------------------------------------------------
			addi	ctr_c, $0, 0
			
			for_2:
				bge	ctr_c, N, end_2	# ctr_c: 0 to 3
				
				# ctr_a => K
				# ctr_b => I
				# ctr_c => J
				
				# MATRIX[I][K] + MATRIX[K][J]	
				get_elem(ctr_b, ctr_a, temp_elem)
				add	$t8, $0, temp_elem	# MATRIX[I][K]
				get_elem(ctr_a, ctr_c, temp_elem)
				add	$t9, $0, temp_elem	# MATRIX[K][J]
				
				# Add the two operands.
				custom_add($t8, $t9, sum)
				
				# MATRIX[I][J]
				get_elem(ctr_b, ctr_c, temp_elem)
				add	$s2, $0, temp_elem	# MATRIX[I][J]
				
				# Get the minimum between the two.
				get_min(sum, $s2, min)
				
				# Store the min.
				store_elem(ctr_b, ctr_c, min)	# MATRIX[I][J]
				
				addi	ctr_c, ctr_c, 1	# ctr_c++
				j	for_2
			
			end_2:
			# End of for-loop 2 ===================================================
			
			addi	ctr_b, ctr_b, 1	# ctr_b++
			j	for_1
		
		end_1:
		# End of for-loop 1 ===================================================
		
		addi	ctr_a, ctr_a, 1	# ctr_a++
		j	for_0
	
	end_0:
	# End of for-loop 0 ===================================================
	
	# After-state of the matrix.
	print_matrix()
	
	exit()

.data
matrix: .word 0
	.word 3
	.word INF
	.word 5
	.word 2
	.word 0
	.word INF
	.word 4
	.word INF
	.word 1
	.word 0
	.word INF
	.word INF
	.word INF
	.word 2
	.word 0
