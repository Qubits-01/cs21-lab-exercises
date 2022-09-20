# CS 21 LAB 2 -- S1 AY 2022-2023
# Marc Peejay Viernes -- 2022/SEPT/18
# PS2.asm -- Prob Set 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       

.text
main:	li	$t0, 1
	li	$t1, 1
	li	$t2, 0x00000044
	li	$t3, 0
	li	$t4, 4
	li	$t5, 2
	li	$t6, 4
	li	$t7, 1

	add	$t0, $t0, $t0
mayuyu:	addi	$t0, $t0, 1
	add	$t4, $t4, $t7
	or	$t5, $t5, $t5
	slt	$t1, $t0, $t2
	bne	$t1, $t3, mayuyu
	add	$t0, $t0, $t0
	
	li	$v0, 10	# syscall code 10
	syscall		# syscall code 10
	
.data
################ data ################
################ data ################
################ data ################
