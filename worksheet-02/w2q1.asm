.data
	zero: .asciiz "Zero"
	positive: .asciiz "Positive"
	negative: .asciiz "Negative"

.text
	li $v0, 5					# read_int syscall
	syscall
	move $t0, $v0				# move user input to t0

	li $v0, 4					# print_string syscall

	bgt $t0, $zero, greater		# if (t0 > 0); goto greater
	beq $t0, $zero, equal		# if (t0 == 0); goto greater

	la $a0, negative
	j exit

	greater:
		la $a0, positive
		j exit

	equal:
		la $a0, zero

	exit:
		syscall					# print result
		li $v0, 10				# exit_syscall
		syscall