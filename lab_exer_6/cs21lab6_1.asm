# CS 21 LAB 2 -- S1 AY 2022-2023
# Marc Peejay Viernes -- 2022/OCT/11
# cs21lab6_1.asm -- Shifting and Masking

.macro	do_syscall(%n)
	addi	$v0, $0, %n
	syscall
.end_macro

.macro	exit
	do_syscall(10)
.end_macro

.macro	get_int_input(%var)
	do_syscall(5)
	move	%var, $v0
.end_macro

.macro	print_int(%var)
	move	$a0, %var
	do_syscall(1)
.end_macro

.macro	print_binary(%var)
	move	$a0, %var
	do_syscall(35)
.end_macro

.macro	print_char(%ascii_dec)
	addi	$a0, $0, %ascii_dec
	do_syscall(11)
.end_macro

.macro	print_new_line
	print_char(10)
.end_macro

.text
main:
	get_int_input($s0)	# int n
	move	$t0, $s0	# int temp_n
	li	$t1, -1		# temp_output_1
	
	# Output 1. -------------------------------------------------------------------
	# For loop until int temp_n is negative
	# while doing shift left logical 1 on temp_n per iteration.
	for_0:
		blt	$t0, $0, end_for_0	# temp_n < 0 ? end_for_0
		
		sll	$t0, $t0, 1		# Halve the value of temp_n.
		srl	$t1, $t1, 1		# Update temp_output_1.
		
		j	for_0
	
	end_for_0:
		move	$s1, $t1		# Final output 1.
	
	# For debugging purposes.
	# print_binary($s0)	# int n
	# print_new_line()
	# print_binary($s1)	# Output 1.
	# print_new_line()
	
	# print_int($s0)	# int n
	# print_new_line()
	print_int($s1)		# Output 1.
	print_new_line()
	# Output 1. ===================================================================
	
	# Output 2. -------------------------------------------------------------------
	# Calculate how many 1s will Output 2 have.
	li	$s2, 0x0000000F		# Bit mask to get the 4 right-most bits of int n.
	and	$t2, $s2, $s0		# int o = 'number of 1s' = 0x0000000F AND int_n
	li	$t3, 32
	sub	$t3, $t3, $t2		# int z = 'number of 0s to shift left logical in temp_output'
	
	li	$t4, -1			# temp_output: 0xFFFFFFFF
	sllv	$t4, $t4, $t3		# Insert 0s from the right.
	
	# Include the 4 right-most bits in the final Output 2.
	or	$s2, $t4, $t2		# Final output 2.
	
	# For debugging purposes.
	# print_binary($s0)	# int n
	# print_new_line()
	# print_binary($s2)	# Output 2.
	# print_new_line()
	
	# print_int($s0)	# int n
	# print_new_line()
	print_int($s2)		# Output 2.
	print_new_line()
	# Output 2. ===================================================================
	
	exit()
