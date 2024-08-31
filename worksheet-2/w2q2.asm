.data
	menuStr: .asciiz "1. Addition\n2. Subtraction\n3. Multiplication\n4. Division\nSelect Operator > "
	inStr1: .asciiz "Enter first operand > "
	inStr2: .asciiz "Enter second operand > "

.text
	li $v0, 4									# print_string syscall
	la $a0, inStr1								# load first_prompt addr into a0
	syscall

	li $v0, 5									# read_int syscall
	syscall
	move $v0, $t1								# store first int in t1

	li $v0, 4									# print_string syscall
	la $a0, inStr1								# load second_prompt addr into a0
	syscall

	li $v0, 5									# read_int syscall
	syscall
	move $v0, $t2								# store second int in t2

	li $v0, 4									# print_string syscall
	la $a0, menuStr								# load menuStr addr into a0
	syscall

	li $v0, 5									# read_int syscall
	syscall
	move $v0, $t0

	div $t0, $t1, $t2
	ADD: add $t0, $t1, $t2
		j exit
	SUB: add $t0, $t1, $t2
		j exit
	MUL: mul $t0, $t1, $t2

	exit:
		li $v0, 10								# exit syscall
		syscall