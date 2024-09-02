.data
	operatorPrompt: .asciiz "enter operation:\n1. addition\n2.subtraction\n3.multiplication\n4.division\n"
	num1Prompt: .asciiz "enter num 1 > "
	num2Prompt: .asciiz "enter num 2 > "
	result: .asciiz "output > "
	newline: .asciiz "\n"
	zeroError: .asciiz "num2 cannot be zero"

.text
	main:
		li $v0, 4										# print_string syscall
		la $a0, operatorPrompt							# load operatorPrompt addr into a0
		syscall

		li $v0, 5										# read_int syscall
		syscall
		move $a1, $v0									# operator -> t0

		li $v0, 4										# print_string syscall
		la $a0, num1Prompt								# load num1Prompt addr into a0
		syscall

		li $v0, 5										# read_int syscall
		syscall
		move $a2, $v0									# num1 -> a1

		li $v0, 4										# print_string syscall
		la $a0, num2Prompt								# load num2Prompt addr into a0
		syscall

		li $v0, 5										# read_int syscall
		syscall
		move $a3, $v0									# num2 -> a2

		beq $a1, 1, addition
		beq $a1, 2, subtraction
		beq $a1, 3, multiplication
		beq $a1, 4, division

	addition:
		add $t0, $a2, $a3								# result -> t0 = num1 + num2
		j print_result

	subtraction:
		sub $t0, $a2, $a3								# result -> t0 = num1 - num2
		j print_result

	multiplication:
		mul	$t0, $a2, $a3								# result -> t0 = num1 * num2
		j print_result

	division:
		beq $a3, $zero, division_zero_error			# check for zero error
		div	$a2, $a3
		mflo $t0										# result -> t0 = Math.floor(num1 / num2)
		j print_result

	division_zero_error:
		li $v0, 4										# print_string syscall
		la $a0, zeroError								# load zeroError addr into a0
		syscall
		j exit											# jump to exit

	print_result:
		li $v0, 4										# print_string syscall
		la $a0, result									# load result addr into a0
		syscall

		li $v0, 1										# print_int syscall
		move $a0, $t0									# a0 = result
		syscall

	exit:
		li $v0, 10										# exit syscall
		syscall