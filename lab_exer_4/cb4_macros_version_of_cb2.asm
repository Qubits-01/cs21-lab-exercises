.include "cb3_macros_in_macros.asm"

.text
main:
	print_str(msg1)
	read_str(name, 10)
	print_str(msg2)
	print_str(name)
	exit()

.data
	allocate_str(msg1, "Enter a string: ")
	allocate_str(msg2, "You entered: ")
	allocate_bytes(name, 10)
