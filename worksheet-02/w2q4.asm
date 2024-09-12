.data
	input: .asciiz "x > "
	output: .asciiz "fact(x) > "

.text
	main:
		li $v0, 4						# print_string syscall
		la $a0, input					# load input addr into a0
		syscall
		li $v0, 5						# read_int syscall
		syscall

		move $a0, $v0					# move input to a0
		jal factorial					# call factorial(n)
		move $t0, $v0					# move result to t0

		li $v0, 4						# print_string syscall
		la $a0, output					# load output addr into a0
		syscall
		li $v0, 1						# print_int syscall
		move $a0, $t0					# move t0 into a0
		syscall

	exit:
		li $v0, 10						# exit syscall
		syscall

	factorial:
		addi $sp, $sp, -8				# allocate space in stack for return address and arguments
		sw $ra, 4($sp)					# store return address
		sw $a0, 0($sp)					# store argument n

		li $v0, 1						# base_case return value
		blt	$a0, 2, end_factorial		# if (n < 2); goto end_factorial

		addi $a0, $a0, -1				# set argument to n - 1
		jal factorial					# recursive call factorial(n-1);

		lw $a0, 0($sp)					# restore original n from stack
		mul $v0, $a0, $v0				# n * factorial(n-1)

	end_factorial:
		lw $ra, 4($sp)					# restore return addr
		addi $sp, $sp, 8				# deallocate stack space
		jr $ra							# return
