.data
	matOneLabel: .asciiz "matrix 1 - \n"
	matTwoLabel: .asciiz "matrix 2 - \n"
	matThreeLabel: .asciiz "matrix 3 - \n"
	rowInputMsg: .asciiz "enter num rows > "
	colInputMsg: .asciiz "enter num cols > "
	x: .asciiz "x"
	arrow: .asciiz " > "
	space: " "
	orderErrorMsg: .asciiz "invalid matrix orders"
	newline: .asciiz "\n"

.text
.globl main
	main:
		li $v0, 4											# print_string syscall
		la $a0, matOneLabel									# load matOneLabel addr into a0
		syscall
		la $a0, rowInputMsg									# load rowInputMsg addr into a0
		syscall

		li $v0, 5											# read_int syscall
		syscall
		move $s1, $v0										# numRowsOne -> s1 = v0

		li $v0, 4											# print_string syscall
		la $a0, colInputMsg									# load colInputMsg addr into a0
		syscall

		li $v0, 5											# read_int syscall
		syscall
		move $s2, $v0										# numColsOne -> s2 = v0

		li $v0, 4											# print_string syscall
		la $a0, matTwoLabel									# load matOneLabel addr into a0
		syscall
		la $a0, rowInputMsg									# load rowInputMsg addr into a0
		syscall

		li $v0, 5											# read_int syscall
		syscall
		move $s4, $v0										# numRowsTwo -> s4 = v0

		li $v0, 4											# print_string syscall
		la $a0, colInputMsg									# load colInputMsg addr into a0
		syscall

		li $v0, 5											# read_int syscall
		syscall
		move $s5, $v0										# numColsTwo -> s5 = v0

		bne $s2, $s4, order_error							# if (numColsOne != numRowsTwo); goto order_error;

		move $a0, $s1										# move numRowsOne into a0
		move $a1, $s2										# move numColsOne into a1
		jal malloc
		move $s0, $v0										# move matOnePtr into s0

		move $a0, $s4										# move numRowsTwo into a0
		move $a1, $s5										# move numColsTwo into a1
		jal malloc
		move $s3, $v0										# move matTwoPtr into s3

		move $a0, $s1										# move numRowsOne into a0
		move $a1, $s5										# move numColsTwo into a1
		jal malloc
		move $s6, $v0										# move matThreePtr into s6

		# matOnePtr -> s0
		# numRowsOne -> s1
		# numColsOne -> s2
		# matTwoPtr -> s3
		# numRowsTwo -> s4
		# numColsTwo -> s5
		# matThreePtr -> s6

		li $v0, 4											# print_string syscall
		la $a0, matOneLabel									# load matOneLabel addr into a0
		syscall
		la $s7, input_element								# load input_element addr into s7
		move $a1, $s0										# move matOnePtr into s0
		move $a2, $s1										# move numRowsOne into s1
		move $a3, $s2										# move numColsOne into s2
		jal iterate
		la $s7, print_element								# load print_element addr into s7
		jal iterate

		li $v0, 4											# print_string syscall
		la $a0, matTwoLabel									# load matTwoLabel addr into a0
		syscall
		la $s7, input_element								# load input_element addr into s7
		move $a1, $s3										# move matTwoPtr into s0
		move $a2, $s4										# move numRowsTwo into s1
		move $a3, $s5										# move numColsTwo into s2
		jal iterate
		la $s7, print_element								# load print_element addr into s7
		jal iterate

		la $s7, multiply_mat								# load multiply_mat addr into s7
		jal iterate

		li $v0, 4											# print_string syscall
		la $a0, matThreeLabel								# load matThreeLabel addr into a0
		syscall

		move $a1, $s6										# move matThreePtr into a1
		move $a2, $s1										# move numRowsOne into a2
		move $a3, $s5										# move numColsTwo into a3
		la $s7, print_element								# load print_element addr into s7
		jal iterate

	exit:
		li $v0, 10											# exit syscall
		syscall

	order_error:
		li $v0, 4											# print_string syscall
		la $a0, orderErrorMsg								# load orderErrorMsg addr into a0
		syscall
		j exit

	malloc:
	# a0 -> numRows
	# a1 -> numCols
		mul $t0, $a0, $a1									# numCols * numRows
		mul $t0, $t0, 4										# amountToAllocate -> t0 = numCols * numRows * 4
		li $v0, 9											# sbrk syscall
		move $a0, $t0										# move amountToAllocate into a0
		syscall
		jr $ra

	iterate:
	# functionAddr -> s7
	# arrPtr -> a1
	# numRows -> a2
	# numCols -> a3
		addi $sp, $sp, -4									# allocate stack memory
		sw $ra, 0($sp)										# store return addr

		li $t0, 0											# i -> t0 = 0

		iterate_outer_loop:
			bge $t0, $a2, end_iterate_outer_loop			# if (i >= numRows); goto end_iterate_outer_loop;
			li $t1, 0										# j -> t1 = 0

			iterate_inner_loop:
				bge $t1, $a3, end_iterate_inner_loop		# if (j >= numCols); goto end_iterate_inner_loop

				# arrPtr -> a1
				# numRows -> a2
				# numCols -> a3
				# i -> t0
				# j -> t1
				jalr $s7									# CALL FUNCTION

				addi $t1, $t1, 1							# j++
				j iterate_inner_loop

			end_iterate_inner_loop:
				addi $t0, $t0, 1							# i++
				li $t1, 0									# j = 0
				j iterate_outer_loop

		end_iterate_outer_loop:
			lw $ra, 0($sp)									# restore return addr
			addi $sp, $sp, 4								# deallocate stack memory
			jr $ra

	input_element:
	# arrPtr -> a1
	# numRows -> a2
	# numCols -> a3
	# i -> t0
	# j -> t1
		mul $t3, $t0, $a3									# i * numCols
		add $t3, $t3, $t1									# i * numCols + j
		mul $t3, $t3, 4										# (i * numCols + j)*4
		add $t3, $a1, $t3									# addr(i,j) = baseAddr + (i * numCols + j)*4

		li $v0, 1											# print_int syscall
		addi $a0, $t0, 1									# move i+1 into a0
		syscall

		li $v0, 4											# print_string syscall
		la $a0, x											# load x addr into a0
		syscall

		li $v0, 1											# print_int syscall
		addi $a0, $t1, 1									# move j+1 into a0
		syscall

		li $v0, 4											# print_string syscall
		la $a0, arrow										# load arrow addr into a0
		syscall

		li $v0, 5											# read_int syscall
		syscall
		sw $v0, 0($t3)										# store v0 into addr(i,j)

		jr $ra

	print_element:
	# arrPtr -> a1
	# numRows -> a2
	# numCols -> a3
	# i -> t0
	# j -> t1
		mul $t3, $t0, $a3									# i * numCols
		add $t3, $t3, $t1									# i * numCols + j
		mul $t3, $t3, 4										# (i * numCols + j)*4
		add $t3, $a1, $t3									# addr(i,j) = baseAddr + (i * numCols + j)*4

		lw $t4, 0($t3)										# c
		lw $t4, 0($t3)										# currElement -> t4 = arr[i,j]
		li $v0, 1											# print_int syscall
		move $a0, $t4										# move currElement to a0
		syscall
		li $v0, 4											# print_string syscall
		la $a0, space										# load space addr into a0
		syscall

		addi $t5, $t1, 1									# t5 = j + 1
		beq $t5, $a3, print_element_sub_newline

		jr $ra

		print_element_sub_newline:
			li $v0, 4										# print_string syscall
			la $a0, newline									# load newline addr into a0
			syscall
			jr $ra

	multiply_mat:
	# matOnePtr -> s0
	# numRowsOne -> s1
	# numColsOne -> s2
	# matTwoPtr -> s3
	# numRowsTwo -> s4
	# numColsTwo -> s5
	# matThreePtr -> s6
	# i -> t0
	# j -> t1
		li $t2, 0											# k -> t2 = 0
		li $t3, 0											# sum -> t3 = 0

		multmat_loop:
			bge $t2, $s4, end_multmat_loop
			# first var -> t5
			mul $t4, $s2, $t0								# i * numColsOne
			add $t4, $t4, $t2								# i * numColsOne + k
			mul $t4, $t4, 4									# (i * numColsOne + k)*4
			add $t4, $s0, $t4								# var1Addr = baseAddrOne + (i * numColsOne + k) * 4
			lw $t5, 0($t4)

			# second var -> t6
			mul $t4, $s5, $t2								# k * numColsTwo
			add $t4, $t4, $t1								# k * numColsTwo + j
			mul $t4, $t4, 4									# (k * numColsTwo + j)*4
			add $t4, $s3, $t4								# var2Addr = baseAddrTwo + (k * numColsTwo + j) * 4

			lw $t6, 0($t4)

			mul $t7, $t5, $t6								# var1 * var2
			add $t3, $t3, $t7								# sum += var1 * var2

			addi $t2, $t2, 1								# k++
			j multmat_loop

    	end_multmat_loop:
    		mul $t4, $t0, $s5								# i * numColsTwo
    		add $t4, $t4, $t1								# i * numColsTwo + j
    		mul $t4, $t4, 4									# (i * numColsTwo + j)*4
    		add $t4, $s6, $t4								# resultAddr = baseAddrThree + (i * numColsTwo + j) * 4

  			sw $t3, 0($t4)
  			jr $ra