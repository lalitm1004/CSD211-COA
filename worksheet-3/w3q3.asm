.data
	prompt1: .asciiz "enter first integer > "
	prompt2: .asciiz "enter second integer > "
	productMsg: .asciiz "product of two nums is > "
	sumMsg: .asciiz "sum of two nums is > "
	diffMsg: .asciiz "difference of two nums is > "
	newline: .asciiz "\n"

.text
.globl main
	main:
		li $v0, 4							# print_string syscall
		la $a0, prompt1						# load prompt1 addr into a0
		syscall

		li $v0, 5							# read_int syscall
		syscall
		move $t0, $v0						# num1 -> t0 = v0

		li $v0, 4							# print_string syscall
		la $a0, prompt2						# load prompt2 addr into a0
		syscall

		li $v0, 5							# read_int syscall
		syscall
		move $t1, $v0						# num2 -> t1 = v0

		jal funcMUL							# call funcMUL
		li $v0, 4							# print_string syscall
		la $a0, productMsg					# load productMsg addr into a0
		syscall
		li $v0, 1							# print_int syscall
		move $a0, $t3						# move return value into a0
		syscall
		li $v0, 4							# print_string syscall
		la $a0, newline						# load newline addr into a0
		syscall

		jal funcADD							# call funcADD
		li $v0, 4							# print_string syscall
		la $a0, sumMsg						# load sumMsg addr into a0
		syscall
		li $v0, 1							# print_int syscall
		move $a0, $t3						# move return value into a0
		syscall
		li $v0, 4							# print_string syscall
		la $a0, newline						# load newline addr into a0
		syscall

		jal funcSUB							# call funcSUB
		li $v0, 4							# print_string syscall
		la $a0, diffMsg						# load diffMsg addr into a0
		syscall
		li $v0, 1							# print_int syscall
		move $a0, $t3						# move return value into a0
		syscall
		li $v0, 4							# print_string syscall
		la $a0, newline						# load newline addr into a0
		syscall

	exit:
		li $v0, 10							# exit syscall
		syscall

	funcMUL:
		mul $t3, $t0, $t1
		jr $ra

	funcADD:
		add $t3, $t0, $t1
		jr $ra

	funcSUB:
		sub $t3, $t0, $t1
		jr $ra