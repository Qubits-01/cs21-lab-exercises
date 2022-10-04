.text
main:
	li $s0, 1
	li $s1, 1
	jal fxn # call function
	add $a0, $s0, $s1 # a0 = s0 + s1
	li $v0, 1 # print s0 + s1
	syscall # print s0 + 1
	
	li $v0, 10
	syscall
	
fxn:
	######preamble######
	subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $s0, 24($sp)
	sw $s1, 20($sp)
	######preamble######
	
	li $s0, 2
	li $s1, 2
	add $a0, $s0, $s1 # a0 = s0 + s1
	li $v0, 1 # print s0 + s1
	syscall
	
	######end######
	lw $ra, 28($sp)
	lw $s0, 24($sp)
	lw $s1, 20($sp)
	addu $sp, $sp, 32
	######end######
	
	jr $ra