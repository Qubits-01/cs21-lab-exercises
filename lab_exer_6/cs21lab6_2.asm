# CS 21 LAB 2 -- S1 AY 2022-2023
# Marc Peejay Viernes -- 2022/OCT/12
# cs21lab6_2.asm -- IEEE-754 Addition

.eqv	float_a $s0
.eqv	float_b	$s1
.eqv	float_c $s2		# Sum of float a and float b.
.eqv	sign_c $s3		# Sign bit of the sum.
.eqv	expo_a $t1
.eqv	expo_b $t2
.eqv	manti_a $t3
.eqv	manti_b $t4
.eqv	manti_c $t5
.eqv	bm_manti 0x007FFFFF	# Bit mask for getting the mantissa.
.eqv	bm_xtra_1 0x00800000	# Bit mask for including the implicit 1.
.eqv	bm_expo 0x7F800000	# Bit mask for getting the exponent.
.eqv	bm_bit_23 0xFF800000	# Bit mask for setting the correct value for bit 23 (for leftmost 1).

.macro	do_syscall(%n)
	addi	$v0, $0, %n
	syscall
.end_macro

.macro	exit
	do_syscall(10)
.end_macro

.macro	print_binary(%var)
	move	$a0, %var
	do_syscall(35)
.end_macro

.macro	print_hexadecimal(%var)
	move	$a0, %var
	do_syscall(34)
.end_macro

.macro	print_float(%var)
	mov.s	$f12, %var
	do_syscall(2)
.end_macro

.macro	print_string(%label)
	la	$a0, %label
	do_syscall(4)
.end_macro

.macro	print_char(%ascii_dec)
	addi	$a0, $0, %ascii_dec
	do_syscall(11)
.end_macro

.macro	print_new_line
	print_char(10)
.end_macro

.text
main:
	# Get the value of  float a and float b.
	la	$t0, f_a
	lw	float_a, 0($t0)
	la	$t0, f_b
	lw	float_b, 0($t0)
	
	# Step 1. EXTRACT THE COMPONENTS.
	# Get the exponent.
	li	$t0, bm_expo
	and	expo_a, float_a, $t0
	srl	expo_a, expo_a, 23	# Exponent of a (w/ bias)
	and	expo_b, float_b, $t0
	srl	expo_b, expo_b, 23	# Exponent of b (w/ bias)
	
	# Get the mantissa.
	li	$t0, bm_manti
	and	manti_a, float_a, $t0	# Mantissa of a w/o the implicit 1.
	and	manti_b, float_b, $t0	# Mantissa of b w/o the implicit 1.
	
	li	$t0, bm_xtra_1
	or	manti_a, manti_a, $t0	# Include the implicit 1 to the mantissa of a.
	or	manti_b, manti_b, $t0	# Include the implicit 1 to the mantissa of b.
	
	# Step 2. ADJUST THE EXPONENTS.
	beq	expo_a, expo_b, convert_mantissa
	blt	expo_a, expo_b, lower_exponent_a
	lower_exponent_b:
		sub	$t0, expo_a, expo_b	# Difference in exponent value.
		add	expo_b, expo_b, $t0	# Adjust expo_b.
		srlv	manti_b, manti_b, $t0	# Adjust manti_b.
	
		j	convert_mantissa
	
	lower_exponent_a:
		sub	$t0, expo_b, expo_a	# Difference in exponent value.
		add	expo_a, expo_a, $t0	# Adjust expo_a.
		srlv	manti_a, manti_a, $t0	# Adjust manti_a.
	
	# Step 3. CONVERT THE MANTISA TO 2C (IF NEEDED).
	convert_mantissa:
		bltzal	float_a, a_to_2c	# float_a < 0 ? goto a_to_2c
		bltzal	float_b, b_to_2c	# float_b < 0 ? goto b_to_2c
		
		j	add_mantissas
		
	a_to_2c:
		not	manti_a, manti_a	# Invert manti_a.
		addi	manti_a, manti_a, 1	# Add 1 to manti_a.
		
		jr	$ra
	
	b_to_2c:
		not	manti_b, manti_b	# Invert manti_b.
		addi	manti_b, manti_b, 1	# Add 1 to manti_b.
		
		jr	$ra
	
	# Step 4. ADD THE MANTISSAS.
	add_mantissas:
		add	manti_c, manti_a, manti_b	# manti_c = manti_a + manti_b
		
	# Step 5. CONVERT BACK TO SIGNED MAGNITUDE (IF NEEDED).
	addi	sign_c, $0, 0				# Set sign_c to 0 (positive; default).
	bgez	manti_c, adjust_bit_23_and_exponent
	
	not	manti_c, manti_c			# Invert manti_c
	addi	manti_c, manti_c, 1			# Add 1 to manti_c.
	addi	sign_c, $0, 1				# Set sign_c to 1 (negative).
	
	
	# Step 6. ADJUST THE BIT 23 AND THE EXPONENT.
	adjust_bit_23_and_exponent:
		addi	$t6, $t6, 1			# Constant value 1.
		
	for_0:
		# Determine if bit 23 is already 1.
		li	$t0, bm_bit_23
		and	$t0, manti_c, $t0		# Get bits [31:23].
		srl	$t0, $t0, 23			# Relocate to bit positions [22:0].
		beq	$t0, $t6, end_for_0		# 'bit 23' == 1 ? goto end_for_0
		
		if_0:
			blez	$t0, then_0_1		# 'bits [31:23]' <= 0 ? goto then_0_1 (shift left)
			
		# Shift manti_c to the right.
		then_0_0:
			srl	manti_c, manti_c, 1	# Adjust manti_c.
			addi	expo_a, expo_a, 1	# Adjust expo_a (w/ bias; this can be the final exponent).
			
			j	end_if_0
		
		# Shift manti_c to the left.
		then_0_1:				
			sll	manti_c, manti_c, 1	# Adjust manti_c.
			subi	expo_a, expo_a, 1	# Adjust expo_a (w/ bias; this can be the final exponent).
		
		end_if_0:
		
		j	for_0
		
	end_for_0:
	
	li	$t0, bm_manti
	and	manti_c, manti_c, $t0		# Get only the first 23 bits of manti_c.
	
	# Step 7. COMBINE THE COMPONENTS.
	# Put the sign bit.
	sll	$t0, sign_c, 31			# Relocate it to the leftmost part.
	or	float_c, float_c, $t0		# Put it to float_c.
	
	# Put the exponent (w/ bias).
	sll	$t0, expo_a, 23			# Relocate the exponent to bits [30:23].
	or	float_c, float_c, $t0		# Put it to float_c.
	
	# Put the mantissa.
	or	float_c, float_c, manti_c
	
	# Store the sum to address 0x10010008.
	la	$t0, f_c
	sw	float_c, 0($t0)
	
	# Print out the float sum (using a manual algorithm).
	print_string(manual_msg)
	print_new_line()
	mtc1	float_c, $f1		# Move float_c to a floating point register.
	print_float($f1)		# Print float_c in IEEE-754 form.
	print_new_line()
	print_hexadecimal(float_c)	# Print float_c in hexadecimal form.
	print_new_line()
	print_binary(float_c)		# Print float_c in binary form.
	print_new_line()
	print_new_line()
	
	# Print out the float sum (using MIPS' built-in float operations).
	print_string(built_in_msg)
	print_new_line()
	lwc1	$f2, f_a		# Get float_a.
	lwc1	$f3, f_b		# Get float_b.
	add.s	$f4, $f2, $f3		# Get the sum: float_c = float_a + float_b
	print_float($f4)		# Print float_c in IEEE-754 form.
	print_new_line()
	mfc1	$t0, $f4		# Prep: move float_c to a "normal" register first.
	print_hexadecimal($t0)		# Print float_c in hexadecimal form.
	print_new_line()
	print_binary($t0)		# Print float_c in binary form.
	print_new_line()
	
	exit()

.data:
f_a:	.float -5.75
f_b:	.float -6.3125
f_c:	.float 0	# Default value.
manual_msg:	.asciiz "Manual algorithm"
built_in_msg:	.asciiz "Built-in"
