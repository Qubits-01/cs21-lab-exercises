# CS 21 LAB 2 -- S1 AY 2022-2023
# Marc Peejay Viernes -- 2022/OCT/05
# cs21le6b.asm -- Derangements using recursion.

.eqv	ONE $t0
.eqv	TWO $t1

.macro do_syscall(%n)
	addi	$v0, $0, %n
	syscall
.end_macro

.macro exit
	do_syscall(10)
.end_macro

.macro calc_no_of_derangements(%n)
	move	$v0, $0		# Reset the return value holder to 0.
	move	$a0, %n
	jal	derangements
.end_macro

.text
main:
	addi	ONE, $0, 1	# Initialize constant 1 value.
	addi	TWO, $0, 2	# Initialize conatant 2 value.

	# Get input string length n.
	do_syscall(5)
	move	$a0, $v0
	
	calc_no_of_derangements($a0)
	
	# Print the number of derangements.
	move	$a0, $v0
	do_syscall(1)
	
	exit()	

# Function: Calculate the number of derangements. ---------------------------
# Param: int n : $a0
# Return Value: int f : $v0
derangements:
	# Initialize.
	subu	$sp, $sp, 12
	sw	$ra, 8($sp)
	sw	$s0, 4($sp)
	sw	$s1, 0($sp)
	
	# Base cases. -------------------------------------------------------
	beqz	$a0, case_zero_or_one		# CASE: n == 0 ? return 0
	beq	$a0, ONE, case_zero_or_one	# CASE: n == 1 ? return 0
	j	try_two				# n != 0 && n != 1 ? skip case_zero_or_one
	
	case_zero_or_one:			# return 0
		move	$v0, $0			# f = 0
		j	return_derangements
	
	try_two:
		beq	$a0, TWO, case_two	# CASE: n == 2 ? return 1
		j	recursive_step		# n != 2 ? skip case_two
		
		case_two:			# return 1
			move	$v0, ONE	# f = 1
			j	return_derangements
	
	# Base cases. =======================================================
	
	recursive_step:
		subi	$s0, $a0, 1		# (n - 1)
		
		calc_no_of_derangements($s0)	# calc_no_of_derangements(n - 1)
		move	$s1, $v0
		
		subi	$t2, $s0, 1		# (n - 1) - 1 = (n - 2)
		calc_no_of_derangements($t2)	# calc_no_of_derangements(n - 2)
		
		# calc_no_of_derangements(n - 1) + calc_no_of_derangements(n - 2)
		add	$t3, $s1, $v0
		
		# return (n - 1) * (calc_no_of_derangements(n - 1) + calc_no_of_derangements(n - 2))
		mul	$v0, $s0, $t3
		
		j	return_derangements
	
return_derangements:
	# Dispose.
	lw	$ra, 8($sp)
	lw	$s0, 4($sp)
	lw	$s1, 0($sp)
	addu	$sp, $sp, 12
	jr	$ra
	
# Function: Calculate n factorial. ==========================================
