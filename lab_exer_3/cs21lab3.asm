# CS 21 LAB 2 -- S1 AY 2022-2023
# Marc Peejay Viernes -- 2022/SEPT/16
# cs21lab3.asm -- Lab 3 Tasks (add, and, or, xor, nor).

.text
main:	#	li	$s0, 0xA146B7F0	# Initialization
	#	li	$s1, 0xFFFFFFEF	# Initialization
	
	add	$t0, $s0, $s1	# $s0 = $t0 = 0xa146b7df
	and	$t1, $s0, $s1	# $s1 = $t1 = 0xa146b7cf
	or	$t2, $s0, $s1	# $s0 = $t2 = 0xa146b7df
	xor	$t3, $s0, $s1	# $s0 = $t3 = 0x00000010
	nor	$t4, $s0, $s1	# 0x5eb94820
	
	li	$v0, 10	# syscall code 10
	syscall		# syscall code 10
	


.data
################ data ################
################ data ################
################ data ################
