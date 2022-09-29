# CS 21 LAB 2 -- S1 AY 2022-2023
# Marc Peejay Viernes -- 2022/SEPT/28
# floydwarshall.asm -- Floyd-Warshall algorithm in MIPS

.eqv CONST_ARR1_LEN 16
.eqv CONST_ARR2_LEN 4
.eqv CONST_ELEM_SIZE 1
.eqv INF 0x7fffffff

.eqv TEMP $t0
.eqv P $t1
.eqv ELEM1 $t2
.eqv ELEM2 $t3
.eqv ARR1 $t4
.eqv ARR2 $t5
.eqv I $t6
.eqv K $t7
.eqv LEN $t8
.eqv FOUND $t9

.macro do_syscall(%n)
	li $v0, %n
	syscall
.end_macro

.text
main:
	li LEN, 0
	
outer__init:
	li I, 0
	
outer__cond:
	bge I, CONST_ARR1_LEN, outer__end	# I: 0 - 15
	
outer__body:
	li FOUND, 0
	
	inner__init:
		li K, 0
		
	inner__cond:
		bge K, CONST_ARR2_LEN, inner__end	# K: 0 - 3
	inner__body:
		la P, arr1
		mul TEMP, I, CONST_ELEM_SIZE
		add P, P, TEMP
		lbu ELEM1, 0(P)
		
		la P, arr2
		mul TEMP, K, CONST_ELEM_SIZE
		add P, P, TEMP
		lbu ELEM2, 0(P)
		
		bne ELEM1, ELEM2, inner__incr
		li FOUND, 1
		j inner__end
		
	inner__incr:
		addiu K, K, 1
		j inner__cond
		
	inner__end:
	
	beqz FOUND, outer__end
	addiu LEN, LEN, 1
	
outer__incr:
	addiu I, I, 1
	j outer__cond
	
outer__end:
	move $a0, LEN
	do_syscall(1)
	li $a0, '\n'
	do_syscall(11)
	
program_exit:
	do_syscall(10)

.data
arr1:	.asciiz "bababacabaatest!"
arr2:	.asciiz "abcd"

matrix: .word 0
	.word 3
	.word INF
	.word 5
	.word 2
	.word 0
	.word INF
	.word 4
	.word INF
	.word 1
	.word 0
	.word INF
	.word INF
	.word INF
	.word 2
	.word 0
