.data
	arr: .word 5, 9, 2, 10, 89, -10, 280, 1, 3, 100
	size: .word 10
	outputMsg: .asciiz "max num > "

.text
.globl main
	main:
		la $a0, arr								# load arr addr into a0
		lw $a1, size							# load arr size into a1

		jal find_max							# call find_max procedure
		jal print_max							# call print_max procedure

	exit:
		li $v0, 10								# exit syscall
		syscall

	find_max:
		# arr ptr -> a0
		# arr size -> a1
		lw $t0, 0($a0)							# currMax -> t0 = arr[0]
		li $t1, 0								# currLen -> t1 = 1

		loop:
			beq $t1, $a1, end_loop				# if (currLen >= arrLen); goto end_loop;
			lw $t2, 0($a0)						# load  currElement
			bgt $t2, $t0, update_max			# if (currElement > currMax); goto update_max;
			addi $a0, $a0, 4					# move pointer by 4 bytes
			addi $t1, $t1, 1					# increment currLen
			j loop

			update_max:
				move $t0, $t2					# currMax = currElement
				j loop

		end_loop:
			move $v1, $t0						# move currMax into v1
			jr $ra

	print_max:
		li $v0, 4								# print_string syscall
		la $a0, outputMsg						# load outputMsg addr into a0
		syscall

		li $v0, 1								# print_int syscall
		move $a0, $v1							# move currMax into a0
		syscall

		jr $ra