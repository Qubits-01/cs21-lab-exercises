.text
main:	li $a0, 65 # Initialize $a0 with 65

	li $v0, 1 # Print $a0 as a 32-bit two’s complement integer
	syscall
	
	# New line
	li $a0, 10
	li $v0, 11
	syscall
	li $a0, 65
	
	li $v0, 11 # Print $a0 as an ASCII character
	syscall
	
	# New line
	li $a0, 10
	li $v0, 11
	syscall
	li $a0, 65
	
	li $v0, 34 # Print $a0 as a 32-bit hexadecimal value
	syscall
	
	# New line
	li $a0, 10
	li $v0, 11
	syscall
	li $a0, 65
	
	li $v0, 35 # Print $a0 as a 32-bit binary value
	syscall
	
	# New line
	li $a0, 10
	li $v0, 11
	syscall
	li $a0, 65
	
	li $v0, 10
	syscall
	
	li	$v0, 10	# syscall code 10
	syscall		# syscall code 10
	
.data
################ data ################
################ data ################
################ data ################
