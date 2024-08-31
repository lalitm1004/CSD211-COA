.data
	n: .word 30
	fibonacci_msg: .asciiz "Fibonacci sequence upto "
	arrow: .asciiz " > \n"
	space: .asciiz " "

.text
	lw $s0, n							# load n into s0

	printFibonacci:
		# print message
		li $v0, 4							# print_string syscall
		la $a0, fibonacci_msg				# load fibonacci_msg addr into a0
		syscall
		li $v0, 1							# print_int syscall
		lw $a0, n							# load n into a0
		syscall
		li $v0, 4							# print_string syscall
		la $a0, arrow						# load arrow addr into a0
		syscall

		# initialize variables
		li $t0, 0							# t0 -> first  = 0
		li $t1, 1							# t1 -> second = 1
		li $t2, 0							# t2 -> next = 0
		li $t3, 0							# t3 -> i = 0

	loop:
		bge $t3, $s0, exit					# if (i >= n); goto loop_end
		ble $t3, 1, print_i					# if (i <= 1); goto print_i
		add $t2, $t0, $t1					# next = first + second
		move $t0, $t1						# first = second
		move $t1, $t2						# second = next
		j print_next

	print_i:
		move $t2, $t3						# next = i

	print_next:
		li $v0, 1							# print_int syscall
		move $a0, $t2						# move t3 to a0
		syscall

		li $v0, 4							# print_string syscall
		la $a0, space						# load space addr into a0
		syscall

	increment_i:
		addi $t3, $t3, 1					# i++
		j loop

	exit:
		li $v0, 10							# exit syscall
		syscall