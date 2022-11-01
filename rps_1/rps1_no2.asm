main:
	move $ra, $sp
	lw	$s1, 0($at)

test1:
	addi	$0, $0, 5

li $v0, 10
syscall

.data
data1: .asciiz "ABCDE"
data2: .asciiz "DECBA" # this is a hidden value
