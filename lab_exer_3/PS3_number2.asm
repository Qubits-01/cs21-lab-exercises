# CS 21 LAB 2 -- S1 AY 2022-2023
# Marc Peejay Viernes -- 2022/SEPT/18
# PS3_number2.asm -- Prob Set 3 | Number 2

.text
main:	li	$t0, 1
	li	$t1, 3
	li	$t2, 9
	li	$t3, 0xC0DEBABE
	li	$t4, 5
	li	$t5, 7
	li	$t6, 4
	li	$t7, 0x00000200

	add	$t0, $t0, $t0
mayuyu:	add	$t0, $t0, $t0
	bne	$t0, $t2, mayuyuyu
	add	$t4, $t4, $t4
	add	$t5, $t5, $t5
	blt	$t3, $t5, mayuyuyuyu
mayuyuyu:	add	$t0, $t0, $t0
		bgt	$t7, $t0, mayuyu
mayuyuyuyu:	add	$t0, $t0, $t0
	
	li	$v0, 10	# syscall code 10
	syscall		# syscall code 10
	
.data
################ data ################
################ data ################
################ data ################
