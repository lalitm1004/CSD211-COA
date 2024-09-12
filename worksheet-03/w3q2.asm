.data
	rowInput: .asciiz "enter num rows > "
	pOneMarker: .asciiz "i) -\n"
	pTwoMarker: .asciiz "ii) -\n"
	space: .asciiz " "
	star: .asciiz "*"
	newline: .asciiz "\n"

.text
.globl main
	main:
		li $v0, 4										# print_string syscall
		la $a0, rowInput								# load rowInput addr into a0
		syscall

		li $v0, 5										# read_int syscall
		syscall
		move $t0, $v0									# numRows -> t0 = v0

	patternOne:
		li $v0, 4										# print_string syscall
		la $a0, pOneMarker								# load pOneMarker addr into a0
		syscall

		li $t1, 1										# i -> t1 = 1

		pOne_outer_loop:
			bgt $t1, $t0, patternTwo					# if (i > numRows); goto patternTwo

			li $t2, 1									# j -> t2 = 1

			pOne_inner_loop:
				bgt $t2, $t1, pOne_break_inner 			# if (j > i); print_newline

				jal print_star
				addi $t2, $t2, 1						# j++
				j pOne_inner_loop

			pOne_break_inner:
				jal print_newline
				addi $t1, $t1, 1						# i++
				j pOne_outer_loop

	patternTwo:
		li $v0, 4										# print_string syscall
		la $a0, pTwoMarker								# load pTwoMarker addr into a0
		syscall

		li $t1, 1										# i -> t1 = 1

		pTwo_outer_loop:
			bgt $t1, $t0, exit							# if (i > numRows); exit

			li $t2, 1									# j -> t2 = 1
			li $t3, 1									# k -> t3 = i

			subi $t4, $t1, 1							# upperJ -> t4 = i - 1

			sub $t5, $t0, $t1							# t5 = numRows - i
			li $t6, 2									# store 2 in t0
			mul $t5, $t5, $t6							# t5 = 2 * t5
			addi $t5, $t5, 1							# upperK -> t5 = 2 * (numRows - i) + 1

			pTwo_inner_loop_one:
				bgt $t2, $t4, pTwo_inner_loop_two		# if (j > upperJ); print_stars

				jal print_space
				addi $t2, $t2, 1						# j++
				j pTwo_inner_loop_one

			pTwo_inner_loop_two:
				bgt $t3, $t5, pTwo_break_inner_two		# if (k > upperK); print_newline

				jal print_star
				addi $t3, $t3, 1						# k++
				j pTwo_inner_loop_two

			pTwo_break_inner_two:
				jal print_newline
				addi $t1, $t1, 1						# i++
				j pTwo_outer_loop

	exit:
		li $v0, 10										# exit syscall
		syscall

	print_space:
		li $v0, 4										# print_string syscall
		la $a0, space									# load space addr into a0
		syscall
		jr $ra											# return

	print_star:
		li $v0, 4										# print_string syscall
		la $a0, star									# load star addr into a0
		syscall
		jr $ra											# return

	print_newline:
		li $v0, 4										# print_string syscall
		la $a0, newline									# load newline addr into a0
		syscall
		jr $ra											# return