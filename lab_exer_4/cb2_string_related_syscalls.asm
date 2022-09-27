.text
main:	li $v0, 4 # Print string syscall
	la $a0, msg1 # Loads 0x10010000 (msg1) into $a0
	syscall
	
	li $v0, 8 # Read string syscall
	la $a0, name # Loads string buffer address
	li $a1, 10 # Read at most 9 characters
	syscall
	
	li $v0, 4 # Print string syscall
	la $a0, msg2 # Readies printing of msg1
	syscall
	
	la $a0, name # Readies printing of name
	syscall
	
	li	$v0, 10	# syscall code 10
	syscall		# syscall code 10
	
.data
msg1: .asciiz "Enter a string: "
msg2: .asciiz "You entered: "
name: .space 10
