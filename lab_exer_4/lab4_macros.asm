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
