.data
	var0: .word 1
	var1: .word 2										# values to be swapped
	space: .asciiz " "
	newline: .asciiz "\n"

.text
	main:
		lw $s0, var0									# load var0 into s0
		lw $s1, var1									# load var1 into s1

		jal print_values								# print before swapping
		jal print_newline								# print newline
		jal swap_registers								# swap registers
		jal print_values								# print after swapping

	exit:
		li $v0, 10										# exit syscall
		syscall


	print_values:
		li $v0, 1										# print_int syscall
		move $a0, $s0									# move s0 into a0
		syscall

		li $v0, 4										# print_string syscall
		la $a0, space									# load space addr into a0
		syscall

		li $v0, 1										# print_int syscall
		move $a0, $s1									# move s1 into a0
		syscall

		jr $ra											# return from subroutine

	print_newline:
		li $v0, 4										# print_string syscall
		la $a0, newline									# load newline addr into a0
		syscall

		jr $ra											# return from subroutine

	swap_registers:
		xor $s0, $s0, $s1								# var0 = var0 ^ var1
		xor $s1, $s0, $s1								# var1 = var0 ^ var1 (original var0)
		xor $s0, $s0, $s1								# var0 = var0 ^ var1 (original var1)

		jr $ra											# return from subroutine