# CS 21 LAB 2 -- S1 AY 2022-2023
# Marc Peejay Viernes -- 2022/SEPT/28
# triangles.asm -- Triangles C code to translate to MIPS.

.eqv	n	$s0
.eqv	ONE	$s1
.eqv	asterisk	$t0
.eqv	triangle	$t1
.eqv	ast	$t2
.eqv	spaces	$t3
.eqv	temp_bool	$t4

# .include "lab4_macros.asm"
.macro do_syscall(%n)
 	addi	$v0, $0, %n
 	syscall
.end_macro

.macro exit
	do_syscall(10)
.end_macro

.macro print_char(%ascii_dec)
	addi	$a0, $0, %ascii_dec
	do_syscall(11)
.end_macro

.macro print_asterisk
	print_char(42)
.end_macro

.macro print_space
	print_char(32)
.end_macro
	
.macro print_new_line
	print_char(10)
.end_macro

.text
main:	
	addi	ONE, $0, 1	# Constant value 1.
	
	# Get integer input.
	do_syscall(5)
	move	n, $v0
	
# Start of for-loop 0 -------------------------------------------------
	addi	asterisk, $0, 1	# Counter variable.
	
for_0:	
	# For the conditional: asterisk <= n.
	slt	temp_bool, n, asterisk	
	beq	temp_bool, ONE, done_0
	
	# Start of for-loop 1 -------------------------------------------------
		addi	triangle, $0, 1	# Counter variable.
		
	for_1:	
		# For the conditional: triangle <= n.
		slt	temp_bool, n, triangle
		beq	temp_bool, ONE, done_1
		
		# Left spaces.
		# Start of for-loop 2.1 -------------------------------------------------
			addi	spaces, $0, 0	# Counter variable.
			
			# (n - asterisk) / 2
			sub	$t5, n, asterisk	# (n - asterisk)
			srl	$t5, $t5, 1	# (...) / 2
		
		for_2p1:
			# For the conditional: spaces < (n - asterisk) / 2.
			beq	spaces, $t5, done_2p1
			
			print_space()
			
			addi	spaces, spaces, 1	# spaces++
			j	for_2p1
		
		done_2p1:
		# End of for-loop 2.1 ===================================================
		
		# Asterisks.
		# Start of for-loop 2.2 -------------------------------------------------
			addi	ast, $0, 0	# Counter variable.
		
		for_2p2:
			# For the conditional: ast < asterisk.
			beq	ast, asterisk, done_2p2
			
			print_asterisk()
			
			addi	ast, ast, 1	# ast++
			j for_2p2
		
		done_2p2:
		# End of for-loop 2.2 ===================================================
		
		# Start of if =================================================
			# For the conditional: triangle < n.
			slt	temp_bool, triangle, n
			beq	temp_bool, 0, else
			
			# Right spaces
			# Start of for-loop 2.2 -------------------------------------------------
				addi	spaces, $0, 0	# Counter variable.
			
			for_2p3:
				# For the conditiona: spaces < (n - asterisk) / 2.
				slt	temp_bool, spaces, $t5
				beq	temp_bool, 0, done_2p3
				
				print_space()
				
				addi	spaces, spaces, 1	# spaces++
				j for_2p3
				
			done_2p3:
			# End of for-loop 2.2 ===================================================
			
			# Gap between triangles.
			print_space()
			
			j finally
			
		else:
		finally:
		# End of if ===================================================
			
		addi	triangle, triangle, 1	# triangle++
		j	for_1
	
	done_1:
	# End of for-loop 1 ===================================================
	
	print_new_line()
	
	addi	asterisk, asterisk, 2	# asterisk += 2
	j	for_0

done_0:
# End of for-loop 0 ===================================================

	exit()

.data
################ data ################
################ data ################
################ data ################
