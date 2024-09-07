.data
	inputPrompt: .asciiz	"enter number > "
	shiftPrompt: .asciiz	"enter shift amount > "
	leftShift: .asciiz	" << "
	equal: .asciiz " = "

.text
	main:
		li $v0, 4							# print_string syscall
		la $a0, inputPrompt					# load inputPrompt addr into a0
		syscall

		li $v0, 5							# read_int syscall
		syscall
		move $a1, $v0						# num -> a1 = v0

		li $v0, 4							# print_string syscall
		la $a0, shiftPrompt					# load shiftPrompt addr into a0
		syscall

		li $v0, 5
		syscall
		move $a2, $v0						# shiftAmount -> a2 = v0

		sllv $v1, $a1, $a2					# result -> v1 = num << shiftPrompt

		li $v0, 1							# print_int syscall
		move $a0, $a1						# move a1 into a0
		syscall

		li $v0, 4							# print_string syscall
		la $a0, leftShift					# load leftShift addr into a0
		syscall

		li $v0, 1							# print_int syscall
		move $a0, $a2						# move a2 into a0
		syscall

		li $v0, 4							# print_string syscall
		la $a0, equal						# load equal addr into a0
		syscall

		li $v0, 1							# print_int syscall
		move $a0, $v1						# move v1 into a0
		syscall

	exit:
		li $v0, 10							# exit syscall
		syscall