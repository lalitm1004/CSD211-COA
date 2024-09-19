.data
	rowInputMsg: .asciiz "enter num rows > "
	colInputMsg: .asciiz "enter num cols > "
	x: .asciiz "x"
	arrow: .asciiz " > "
	space: .asciiz " "

.text
.globl main
	main:
		li $v0, 4											# print_string syscall
		la $a0, rowInputMsg									# load rowInputMsg addr into a0
		syscall

		li $v0, 5											# read_int syscall
		syscall
		move $s1, $v0										# numRows -> s1 = v0

		li $v0, 4											# print_string syscall
		la $a0, colInputMsg									# load colInputMsg addr into a0
		syscall

		li $v0, 5											# read_int syscall
		syscall
		move $s2, $v0										# numCols -> s2 = v0

		jal malloc											# allocate memory for arr
		la $a1, takeIntInput								# load takeIntInput addr into a0
		jal iterate
		#la $a1, printElement								# load printElement addr into a0
		#jal iterate
		la $a1, doubleElement
		jal iterate
		la $a1, printElement
		jal iterate


	exit:
		li $v0, 10											# exit syscall
		syscall

	malloc:
		mul $t0, $s1, $s2									# numCols * numRows
		mul $t0, $t0, 4										# amountToAllocate -> t0 = numCols * numRows * 4
		li $v0, 9											# sbrk syscall
		move $a0, $t0										# move amountToAllocate to a0
		syscall
		move $s0, $v0										# arrPtr -> s0 = v0
		jr $ra

	iterate:
	# functionAddr -> a1
	# arrPtr -> s0
	# numRows -> s1
	# numCols -> s2
		addi $sp, $sp, -4									# allocate stack memory
		sw $ra, 0($sp)										# store return addr

		li $t0, 0											# i -> t0 = 0
		iterate_outer_loop:
			bge $t0, $s1, end_iterate_outer_loop				# if (i >= numRows); end_iterate_outer_loop;
			li $t1, 0											# j -> t1 = 0

			iterate_inner_loop:
				bge $t1, $s2, end_iterate_inner_loop			# if (j >= numCols); end_iterate_inner_loop;

				# arrPtr -> s0
				# numRows -> s1
				# numCols -> s2
				# i -> t0
				# j -> t1
				jalr $a1										# CALL FUNCTION

				addi $t1, $t1, 1								# j++
				j iterate_inner_loop

			end_iterate_inner_loop:
				addi $t0, $t0, 1								# i++
				li $t1, 0										# j -> t1 = 0
				j iterate_outer_loop

		end_iterate_outer_loop:
			lw $ra, 0($sp)										# restore return addr
			addi $sp, $sp, 4									# deallocate stack memory
			jr $ra

	takeIntInput:
		# arrPtr -> s0
		# numRows -> s1
		# numCols -> s2
		# i -> t0
		# j -> t1
		mul $t3, $t0, $s2										# i * numCols
		add $t3, $t3, $t1										# i * numCols + j
		mul $t3, $t3, 4											# (i * numCols + j)*4
		add $t3, $t3, $s0										# addr(i,j) = baseAddr + (i * numCols + j)*4

		li $v0, 1												# print_int syscall
		addi $a0, $t0, 1										# move i+1 into a0
		syscall

		li $v0, 4												# print_string syscall
		la $a0, x												# load x addr into a0
		syscall

		li $v0, 1												# print_int syscall
		addi $a0, $t1, 1										# move j+1 into a0
		syscall

		li $v0, 4												# print_string syscall
		la $a0, arrow											# load arrow addr into a0
		syscall

		li $v0, 5												# read_int input
		syscall
		sw $v0, 0($t3)											# store v0 into addr(i,j)

		jr $ra

	printElement:
		
		# arrPtr -> s0
		# numRows -> s1
		# numCols -> s2
		# i -> t0
		# j -> t1
		mul $t3, $t0, $s2										# i * numCols
		add $t3, $t3, $t1										# i * numCols + j
		mul $t3, $t3, 4											# (i * numCols + j)*4
		add $t3, $t3, $s0										# addr(i,j) = baseAddr + (i * numCols + j)*4

		lw $t4, 0($t3)											# currElement -> t4 = arr[i,j]
		li $v0, 1												# print_int syscall
		move $a0, $t4											# move currElement into a0
		syscall

		li $v0, 4												# print_string syscall
		la $a0, space 											# load space addr into a0
		syscall

		jr $ra

	doubleElement:
		# arrPtr -> s0
		# numRows -> s1
		# numCols -> s2
		# i -> t0
		# j -> t1
		mul $t3, $t0, $s2										# i * numCols
		add $t3, $t3, $t1										# i * numCols + j
		mul $t3, $t3, 4											# (i * numCols + j)*4
		add $t3, $t3, $s0										# addr(i,j) = baseAddr + (i * numCols + j)*4

		lw $t4, 0($t3)											# currElement -> t4 = arr[i,j]
		mul $t4, $t4, 2											# double currElement
		sw $t4, 0($t3)											# store doubledElement into arr[i,j]

		jr $ra
