# CS 21 LAB 2 -- S1 AY 2022-2023
# Marc Peejay Viernes -- 2022/OCT/04
# cs21le5a.asm -- Factorial using recursion.

.macro do_syscall(%n)
	addi	$v0, $0, %n
	syscall
.end_macro

.macro exit
	do_syscall(10)
.end_macro

.macro f_multiply(%a, %b)
	addi	$v0, $0, 0
	move	$a0, %a
	move	$a1, %b
	jal	multiply
.end_macro

.macro f_factorial(%n)
	addi	$v0, $0, 1
	move	$a0, %n
	jal	factorial
.end_macro

.text
main:
	# Get input integer n.
	do_syscall(5)
	move	$a0, $v0
	
	f_factorial($a0)
	
	# Print the factorial value.
	move	$a0, $v0
	do_syscall(1)
	
	exit()	

# Function: Calculate n factorial. ------------------------------------------
# Param: int n : $a0
# Return Value: int f : $v0
factorial:
	# Initialize.
	subu	$sp, $sp, 8
	sw	$ra, 4($sp)
	sw	$s0, 0($sp)
	
	# Base case.
	beqz	$a0, return_factorial	# n == 0 ? return 1
	
	move	$s0, $a0
	
	# factorial(n - 1)
	subi	$a0, $a0, 1
	f_factorial($a0)
	move	$t1, $v0
	
	# return n * factorial(n - 1)
	f_multiply($s0, $t1)
	j	return_factorial
	
recurse_factorial:
	jal	factorial
	
return_factorial:
	# Dispose.
	lw	$ra, 4($sp)
	lw	$s0, 0($sp)
	addu	$sp, $sp, 8
	jr	$ra
	
# Function: Calculate n factorial. ==========================================

# Function: Multiply two integers without using mul. ------------------------
# Params: int a, int b : $a0, $a1
# Return Value: int f : $v0
multiply:
	# Initialize.
	subu	$sp, $sp, 4
	sw	$ra, 0($sp)
	
	# Base case.
	beqz	$a1, return_multiply	# b == 0 ? return 0
	
	add	$v0, $a0, $v0	# f += a
	
	bltz	$a1, if_negative_int_b
	subi	$a1, $a1, 1
	j	recurse_multiply

if_negative_int_b:
	addi	$a1, $a1, 1
	bnez	$a1, recurse_multiply
	sub	$v0, $0, $v0	# Put back the negative sign.

recurse_multiply:
	jal	multiply
	
return_multiply:
	# Dispose.
	lw	$ra, 0($sp)
	addu	$sp, $sp, 4
	jr	$ra
	
# Function: Multiply two integers without using mul. ========================
