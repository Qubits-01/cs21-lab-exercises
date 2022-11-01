main:
la $s0, data1
la $s1, data2

lb $t1, 0($s0)
lb $t2, 0($s1)
sub $t3, $t2, $t1
add $s2, $s0, $t3
lb $a0, 0($s2)
li $v0, 11
syscall

lb $t1, 1($s0)
lb $t2, 1($s1)
sub $t3, $t2, $t1
add $s2, $s0, $t3
lb $a0, 0($s2)
li $v0, 11
syscall

lb $t1, 2($s0)
lb $t2, 2($s1)
sub $t3, $t1, $t2
add $s2, $s0, $t3
lb $a0, 0($s2)
li $v0, 11
syscall

lb $t1, 3($s0)
lb $t2, 3($s1)
sub $t3, $t1, $t2
add $s2, $s0, $t3
lb $a0, 0($s2)
li $v0, 11
syscall

lb $t1, 4($s0)
lb $t2, 4($s1)
sub $t3, $t1, $t2
add $s2, $s0, $t3
lb $a0, 0($s2)
li $v0, 11
syscall

li $v0, 10
syscall

.data
data1: .asciiz "ABCDE"
data2: .asciiz "DECBA" # this is a hidden value