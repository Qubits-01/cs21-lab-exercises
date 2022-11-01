main:
	and	$t0, $t1, $t2
	xor	$t3, $t1, $t2
	addi	$t0, $t0, 0x8FFF

li $v0, 10
syscall

.data
data1: .asciiz "ABCDE"
data2: .asciiz "DECBA" # this is a hidden value
