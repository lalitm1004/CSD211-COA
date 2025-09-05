.data
	arr: .word 20, 19 5, 3, 12
	result: .word

.text
.globl main

main:
	la $t0, arr		# load arr addr
	lw $t1, 0($t0)		# load first element
	lw $t2, 4($t0)		# load second element
	
	add $t3, $t1, $t2	# store sum in $t3
	
	sw $t3, result		# store result
	
	li $v0, 1		# print_int syscall
	move $a0, $t3		# move result
	syscall

exit: 
	li $v0, 10		# exit syscall
	syscall