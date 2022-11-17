# CS 21 LAB 2 -- S1 AY 2022-2023
# Marc Peejay Viernes -- 2022/OCT/20
# binary_tree.asm -- MIPS implementation of a binary tree.


.eqv	NEG_INF	0x80000000		# Negative infinity: minimum negative 32-bit signed integer.
.eqv	NULL	0x00000000		# NULL pointer value.
.eqv	NODE_SIZE	0x0000000C	# Number of bytes neede for the Node structure.
.eqv	DATA_OFFSET	0x00000000	# Memory address offset for accessing the data.
.eqv	LEFT_OFFSET	0x00000004	# Memory address offset for accessing the left node.
.eqv	RIGHT_OFFSET	0x00000008	# Memory address offset for accessing the right node.

.eqv	t_a	$t0
.eqv	t_b	$t1
.eqv	t_c	$t2
.eqv	t_d	$t3
.eqv	t_e	$t4
.eqv	t_f	$t5
.eqv	t_g	$t6
.eqv	t_h	$t7
.eqv	t_i	$t8
.eqv	t_j	$t9


.macro do_syscall(%code)
	addi	$v0, $0, %code
	syscall
.end_macro

.macro exit
	do_syscall(10)
.end_macro

.macro print_int(%int_addr)
	move	$a0, %int_addr
	do_syscall(1)
.end_macro

.macro print_char(%ascii_dec)
	addi	$a0, $0, %ascii_dec
	do_syscall(11)
.end_macro

.macro print_new_line
	print_char(10)
.end_macro


# Param: $a0 = %size = '(int) Number of byte/s to allocate.'
# Return value: $v0 = '(Node *) Address of the starting byte of the allocated memory (heap).'
.macro fn_malloc(%size)
	li	$a0, %size
	jal	malloc
.end_macro

# Param: $a0 = %data = '(int) The data value of the node.'
# Return value: $v0 = '(Node *) Address of the starting byte of the allocated memory (heap) for the node.'
.macro fn_new_node(%data)
	li	$a0, %data
	jal	new_node
.end_macro

# Params:
#         $a0 = %parent = '(Node *) Address of the parent node.'
#         $a1 = %left = '(Node *) Address of the left node that will be attached to the parent node.'
#         $a2 = %right = '(Node *) Address of the right node that will be attached to the parent node.'
# Return value: (void) None.
.macro fn_link(%parent_addr, %left_addr, %right_addr)
	move	$a0, %parent_addr
	move	$a1, %left_addr
	move	$a2, %right_addr
	jal	link
.end_macro

# Param: $a0 = %root_addr = '(Node *) Address of the root node of the binary tree.'
# Return value:	$v0 = '(int) Depth of the binary tree.'
.macro	fn_depth(%root_addr)
	move	$a0, %root_addr
	jal	depth
.end_macro

# Params:
#         $a0 = %root_addr = '(Node *) Address of the root node of the binary tree.'
#         $a1 = %level_addr = '(int) Address of the level integer value.
# Return value: $v0 = '(int) Maximum data value among the even level/s.'
.macro	fn_even_level_max(%root_addr, %level_addr)
	move	$a0, %root_addr
	move	$a1, %level_addr
	jal	even_level_max
.end_macro


main :
	# TODO: Test case/s.
	
	fn_new_node(5)		# Node *a = new_node(5);
	move	t_a, $v0
	fn_new_node(10)		# Node *b = new_node(10);
	move	t_b, $v0
	fn_new_node(17)		# Node *c = new_node(17);
	move	t_c, $v0
	fn_new_node(1)		# Node *d = new_node(1);
	move	t_d, $v0
	fn_new_node(0)		# Node *e = new_node(0);
	move	t_e, $v0
	fn_new_node(10)		# Node *f = new_node(10);
	move	t_f, $v0
	fn_new_node(12)		# Node *g = new_node(12);
	move	t_g, $v0
	fn_new_node(1)		# Node *h = new_node(1);
	move	t_h, $v0
	fn_new_node(2)		# Node *i = new_node(2);
	move	t_i, $v0
	fn_new_node(15)		# Node *j = new_node(15);
	move	t_j, $v0
	
	addi	$s0, $0, NULL
	fn_link(t_a, t_b, t_c)	# link(a, b, c);
	fn_link(t_b, t_d, t_e)	# link(b, d, e);
	fn_link(t_c, t_f, t_g)	# link(c, f, g);
	fn_link(t_d, $s0, $s0)	# link(d, NULL, NULL);
	fn_link(t_e, $s0, $s0)	# link(e, NULL, NULL);
	fn_link(t_f, t_h, t_i)	# link(f, h, i);
	fn_link(t_g, t_j, $s0)	# link(g, j, NULL);
	fn_link(t_h, $s0, $s0)	# link(h, NULL, NULL);
	fn_link(t_i, $s0, $s0)	# link(i, NULL, NULL);
	fn_link(t_j, $s0, $s0)	# link(j, NULL, NULL);
	
	fn_depth(t_a)		# int height = depth(a);
	move	$s0, $v0
	print_int($s0)
	print_new_line()
	
	li	$s2, 0
	fn_even_level_max(t_a, $s2)	# even_level_max(a, 0);
	move	$s1, $v0
	print_int($s1)
	print_new_line()
	
	exit()


new_node:
	# Initialize.
	subu	$sp, $sp, 12
	sw	$ra, 8($sp)
	sw	$s0, 4($sp)
	sw	$s1, 0($sp)
	
	move	$s0, $a0		# int data;
	
	fn_malloc(NODE_SIZE)		# Node *ret = malloc(sizeof(Node));
	sw	$s0, DATA_OFFSET($v0)	# ret->data = data;
	li	$s1, NULL
	sw	$s1, LEFT_OFFSET($v0)	# ret->left = NULL:
	sw	$s1, RIGHT_OFFSET($v0)	# ret->right = NULL:
	
	# Dispose.
	lw	$ra, 8($sp)
	lw	$s0, 4($sp)
	lw	$s1, 0($sp)
	addu	$sp, $sp, 12
	jr	$ra


link:
	# Initialize.
	subu	$sp, $sp, 4
	sw	$ra, 0($sp)
	
	sw	$a1, LEFT_OFFSET($a0)	# parent->left = left;
	sw	$a2, RIGHT_OFFSET($a0)	# parent->right = right;
	
	# Dispose.
	lw	$ra, 0($sp)
	addu	$sp, $sp, 4
	jr	$ra


depth:
	# Initialize.
	subu	$sp, $sp, 20
	sw	$ra, 16($sp)
	sw	$s0, 12($sp)
	sw	$s1, 8($sp)
	sw	$s2, 4($sp)
	sw	$s3, 0($sp)
	
	move	$s0, $a0				# Node *root;
	
	# Base case.
	li	$s3, NULL
	beq	$s0, $s3, base_case_root_is_null	# root == NULL ? goto base_case_root_is_null
	j	root_is_not_null
	
	base_case_root_is_null:
		addi	$v0, $0, -1			# return -1;
		j	return_depth
	
	root_is_not_null:
	lw	$s3, LEFT_OFFSET($s0)		# root->left;
	fn_depth($s3)				# depth(root->left);
	move	$s1, $v0			# int left = depth(root->left);
	
	lw	$s3, RIGHT_OFFSET($s0)		# root->right;
	fn_depth($s3)				# depth(root->right);
	move	$s2, $v0			# int right = depth(root->right);
	
	# return 1 + (left > right ? left : right);
	bgt	$s1, $s2, left_gt_right		# left > right ? goto left_gt_right
	j	not_left_gt_right
	
	left_gt_right:
		addi	$v0, $s1, 1		# return 1 + left;
		j	return_depth
	
	not_left_gt_right:
		addi	$v0, $s2, 1		# return 1 + right;
		j	return_depth

return_depth:
	# Dispose.
	lw	$ra, 16($sp)
	lw	$s0, 12($sp)
	lw	$s1, 8($sp)
	lw	$s2, 4($sp)
	lw	$s3, 0($sp)
	addu	$sp, $sp, 20
	jr	$ra


even_level_max:
	# Initialize.
	subu	$sp, $sp, 36
	sw	$ra, 32($sp)
	sw	$s0, 28($sp)
	sw	$s1, 24($sp)
	sw	$s2, 20($sp)
	sw	$s3, 16($sp)
	sw	$s4, 12($sp)
	sw	$s5, 8($sp)
	sw	$s6, 4($sp)
	sw	$s7, 0($sp)
	
	move	$s0, $a0		# Node *root;
	move	$s1, $a1		# int level;
	
	# Base case.
	li	$s7, NULL
	beq	$s0, $s7, base_case_root_is_null_1	# root == NULL ? goto base_case_root_is_null_1
	j	not_root_is_null_1
	
	base_case_root_is_null_1:
		li	$v0, NEG_INF			# return 0x80000000;
		j	return_even_level_max
	
	not_root_is_null_1:
	lw	$s2, LEFT_OFFSET($s0)			# root->left;
	addi	$s3, $s1, 1				# level + 1;
	fn_even_level_max($s2, $s3)			# even_level_max(root->left, level + 1);
	move	$s4, $v0				# int left = even_level_max(root->left, level + 1);
	
	lw	$s5, RIGHT_OFFSET($s0)			# root->right;
	fn_even_level_max($s5, $s3)			# even_level_max(root->right, level + 1);
	move	$s6, $v0				# int right = even_level_max(root->right, level + 1);
	
	bgt	$s4, $s6, left_gt_right_1		# left > right ? goto left_gt_right_1
	j	not_left_gt_right_1
	
	# int greater = (left > right) ? left : right;
	left_gt_right_1:
		move	$s7, $s4			# int greater = left;
		j	skip_0
		
	not_left_gt_right_1:
		move	$s7, $s6			# int greater = right;
	
	skip_0:
	# level % 2 == 0
	li	$a0, 2
	div	$s1, $a0
	mfhi	$a0					# Remainder.
	
	beqz	$a0, rem_is_zero			# (level % 2) == 0 ? goto rem_is_zero
	j	not_rem_is_zero
	
	rem_is_zero:
		lw	$a0, DATA_OFFSET($s0)		# root->data;
		bgt	$s7, $a0, greater_gt_rdata	# greater > root->data ? goto greater_gt_rdata
		j	not_greater_gt_rdata
		
		greater_gt_rdata:
			move	$v0, $s7		# return greater;
			j	skip_1
		
		not_greater_gt_rdata:
			move	$v0, $a0		# return root->data;
		
		skip_1:
		j	return_even_level_max
		
	not_rem_is_zero:
		move	$v0, $s7			# return greater;
	
return_even_level_max:
	# Dispose.
	lw	$ra, 32($sp)
	lw	$s0, 28($sp)
	lw	$s1, 24($sp)
	lw	$s2, 20($sp)
	lw	$s3, 16($sp)
	lw	$s4, 12($sp)
	lw	$s5, 8($sp)
	lw	$s6, 4($sp)
	lw	$s7, 0($sp)
	addu	$sp, $sp, 36
	jr	$ra

	
malloc:
	# Initialize.
	subu	$sp, $sp, 4
	sw	$ra, 0($sp)
	
	do_syscall(9)
	
	# Dispose.
	lw	$ra, 0($sp)
	addu	$sp, $sp, 4
	jr	$ra
	
