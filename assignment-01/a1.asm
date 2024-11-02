.data
	gameArr: .space 64
	buffer: .space 1024
	bufferLen: .word 1024

	inputFile: .asciiz "a1_input.txt"
	comma: .asciiz ", "
	newline: .asciiz "\n"

	inputPrompt: .asciiz "enter option (0 for exit, 1 for performing move left) > "
	inputError: .asciiz "invalid option"
	finalState: .asciiz "no more merges possible, exiting."

.text
.globl main
	main:
		jal read_file
		j game

	exit:
		li $v0, 10											# exit syscall
		syscall

	game:
		input_loop:
			jal print_gameArr
			li $v0, 4										# print_string syscall
			la $a0, inputPrompt
			syscall

			li $v0, 5										# read_int syscall
			syscall
			move $s0, $v0									# s0 -> userInput

			bgt $s0, 1, input_error
			bltz $s0, input_error							# if (userInput < 0 || userInput > 1); goto input_error;
			beqz $s0, exit

			jal slide_left
			jal merge_left
			beqz $v0, final_state							# if (numMerges == 0); goto final_state
			jal slide_left

			j input_loop

		input_error:
			li $v0, 4										# print_string syscall
			la $a0, inputError
			syscall

			j input_loop

		final_state:
			jal print_gameArr
			li $v0, 4										# print_string syscall
			la $a0, finalState								# load finalState addr into a0
			syscall

			j exit

	merge_left:
		# merge tiles to the left if they are the same
		# args:
		#		None
		# return:
		#		numMergers -> v0
		la $s0, gameArr										# load gameArr addr into s0
		li $t0, 0											# i -> t0
		li $v0, 0											# numMerge -> v0
		loop_ml_outer:
			bge $t0, 4, end_loop_ml_outer					# if (i >= 4); goto end_loop_ml_outer

			li $t1, 0										# j -> t1
			mul $s1, $t0, 16
			add $s1, $s0, $s1								# addr(arr[i][0]) = gameArr + i * 16

			loop_ml_inner:
				bge $t1, 4, end_loop_ml_inner				# if (j >= 4); goto end_loop_ml_inner

				mul $t2, $t1, 4
				add $t2, $s1, $t2							# addr(arr[i][j]) = addr(arr[i][0]) + j * 4
				lw $t3, 0($t2)								# gameArr[i][j] -> t3
				addi $t4, $t2, 4							# add(arr[i][j + 1]) = addr(arr[i][j]) + 4
				lw $t5, 0($t4)								# gameArr[i][j + 1] -> t5

				seq $t6, $t3, $zero
				sne $t7, $t3, $t5
				or $t6, $t6, $t7
				bnez $t6, ml_b1								# if (t3 == 0 || t3 != t5); goto ml_b1

				mul $t3, $t3, 2
				sw $t3, 0($t2)								# arr[i][j] *= 2
				sw $zero, 0($t4)							# arr[i][j + 1] = 0
				addi $v0, $v0, 1							# numMerges++

				ml_b1:
					addi $t1, $t1, 1						# j++
					j loop_ml_inner

			end_loop_ml_inner:
				addi $t0, $t0, 1							# i++
				j loop_ml_outer

		end_loop_ml_outer:
			jr $ra


	slide_left:
		# slide all tiles to the left without merging
		# args:
		#		None
		# return:
		# 		None
		la $s0, gameArr											# load gameArr addr into s0
		li $t0, 0												# i -> t0
		loop_sl_outer:
			bge $t0, 4, end_loop_sl_outer						# if (i >= 4); goto end_loop_sl_outer
			li $t1, 0											# j -> t1
			li $t2, 0											# pos -> t2
			loop_sl_inner:
				bge $t1, 4, end_loop_sl_inner					# if (j >= 4); goto end_loop_sl_inner
				mul $t3, $t0, 4
				add $t3, $t3, $t1
				mul $t3, $t3, 4
				add $t3, $s0, $t3								# addr(cell[i][j]) = gameArr + (i * 4 + j) * 4

				lw $t4, 0($t3)									# gameArr[i][j] -> t4
				beqz $t4, sl_b2									# if (gameArr[i][j] == 0); goto sl_b2

				beq $t1, $t2, sl_b1								# if (j == pos); goto sl_b1;
				mul $t5, $t0, 4
				add $t5, $t5, $t2
				mul $t5, $t5, 4
				add $t5, $s0, $t5								# addr(cell[i][pos]) = gameArr + (i * 4 + j) * 4
				sw $t4, 0($t5)									# gameArr[i][pos] = gameArr[i][j]
				sw $zero, 0($t3)								# gameArr[i][j] = 0

				sl_b1:
					addi $t2, $t2, 1							# pos++
					addi $t1, $t1, 1							# j++
					j loop_sl_inner

				sl_b2:
					addi $t1, $t1, 1							# i++
					j loop_sl_inner

			end_loop_sl_inner:
				addi $t0, $t0, 1
				j loop_sl_outer

		end_loop_sl_outer:
			jr $ra


	print_gameArr:
		# prints gameArr
		# args:
		#		None
		# return:tz
		#		None
		addi $sp, $sp, -4
		sw $ra, 0($sp)											# push return addr onto stack

		la $t0, gameArr											# load gameArr addr into t0
		li $t1, 0												# i -> t1
		loop_pga_outer:
			bge $t1, 4, end_loop_pga_outer						# if (i >= 4); goto end_loop_pga_outer
			li $t2, 0											# j -> t2
			loop_pga_inner:
				bge $t2, 4, end_loop_pga_inner					# if (j >= 4); goto end_loop_pga_inner

				mul $t3, $t1, 4
				add $t3, $t3, $t2
				mul $t3, $t3, 4
				add $t3, $t0, $t3								# cellAddr = baseAddr + [i * 4 + j] * 4
				lw $a0, 0($t3)									# load cellValue into a0

				jal int_to_string
				li $v0, 4										# print_string syscall
				la $a0, buffer									# load buffer addr into a0
				syscall

				jal print_comma
				addi $t2, $t2, 1								# j++
				j loop_pga_inner

			end_loop_pga_inner:
				jal print_newline
				addi $t1, $t1, 1								# i++
				j loop_pga_outer

		end_loop_pga_outer:

			lw $ra, 0($sp)										# pop return addr from stack
			addi $sp, $sp, 4
			jr $ra


	int_to_string:
		# parse int to string and store in buffer
		# args:
		#		a0 -> integer
		# return:
		# 		None
		addi $sp, $sp, -16
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)											# push variables onto stack


		li $t0, 10												# divisor -> t0
		li $t1, 0												# counter -> t1
		move $t2, $a0											# cpyNum -> t2

		push_digits:
			div $t2, $t0										# cpyNum / 10
			mfhi $t3											# remainder -> t3 (current digit)
			mflo $t2											# quotient -> t2 (next iteration)
			addi $t3, $t3, '0'									# convert to ASCII
			addi $sp, $sp, -4
			sw $t3, 0($sp)										# push digit onto stack
			addi $t1, $t1, 1									# counter++
			bnez $t2, push_digits								# if (cpyNum != 0); goto push_digits;

		la $t2, buffer											# load buffer addr into t2
		pop_digits:
			lw $t3, 0($sp)										# pop digit from stack
			addi $sp, $sp, 4
			sb $t3, 0($t2)
			addi $t2, $t2, 1									# move to next byte
			addi $t1, $t1, -1									# counter--
			bnez $t1, pop_digits								# if (counter != 0); goto pop_digits;

		sb $zero, 0($t2)										# null terminate string

		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)											# pop variables from stack
		addi $sp, $sp, 16
		jr $ra

	print_comma:
		# args:
		#		None
		# return:
		#		None
		li $v0, 4												# print_string syscall
		la $a0, comma											# load comma addr into a0
		syscall
		jr $ra

	print_newline:
		# prints '\n'
		# args:
		#		None
		# return:
		#		None
		li $v0, 4												# print_string_syscall
		la $a0, newline											# load newline addr into a0
		syscall
		jr $ra

	read_file:
		# reads game state from inputFile and stores it in gameArr
		# args:
		# 		None
		# return:
		#		None
		addi $sp, $sp, -4
		sw $ra, 0($sp)											# push return addr onto stack

		li $v0, 13												# open_file syscall
		la $a0, inputFile										# load inputFile addr into a0
		li $a1, 0												# read flag
		li $a2, 0												# no special permissions
		syscall
		move $s0, $v0											# inputFileDesc -> s0

		li $v0, 14												# read_file syscall
		move $a0, $s0											# move inputFileDesc into a0
		la $a1, buffer											# load buffer addr into a1
		lw $a2, bufferLen										# load bufferLen word into a2
		syscall
		move $s1, $v0											# charCount -> s1

		li $v0, 16												# close_file syscall
		move $a0, $s0											# move inputFileDesc into a0
		syscall
		move $s0, $s1											# move charCount into s0

		#[DEBUG]
		#li $v0, 4												# print_string syscall
		#la $a0, buffer
		#syscall

		li $t0, 0												# currChar -> t0
		la $t1, buffer											# leftPtr -> t1
		la $t2, buffer											# rightPtr -> t2
		li $t3, 0												# cellsPushed -> t3
		find_delimiter:
			bge $t0, $s0, read_file_return						# if (currChar >= charCount); goto read_file_return
			lb $t4, 0($t2)										# load byte from rightPtr
			beq $t4, ',', push_cell								# if (t4 == ','); goto push_cell
			beq $t4, '\n', encounter_nl							# if (t4 == '\n'); goto encounter_nl
			addi $t2, $t2, 1									# rightPtr++
			addi $t0, $t0, 1									# currChar++
			j find_delimiter

		push_cell:
			# args:
			#		leftPtr -> t1
			#		rightPtr -> t2
			#		cellsPushed -> t3
			# return:
			# 		None
			addi $t2, $t2, -1									# rightPtr--
			move $a0, $t1										# move leftPtr into a0
			move $a1, $t2										# move rightPtr into a1
			jal string_to_int
			la $t4, gameArr										# load gameArr addr into t4
			mul $t5, $t3, 4
			add $t5, $t4, $t5									# pushAddr = gameArr + cellsPushed * 4
			sw $v0, 0($t5)										# store convertedValue into gameArr
			addi $t2, $t2, 2									# rightPtr += 2
			move $t1, $t2										# move leftPtr to rightPtr
			addi $t3, $t3, 1									# cellsPushed++
			j find_delimiter

		encounter_nl:
			addi $t2, $t2, 1									# rightPtr++
			move $t1, $t2										# move leftPtr to rightPtr
			j find_delimiter

		read_file_return:
			lw $ra, 0($sp)										# pop return addr from stack
			addi $sp, $sp, 4
			jr $ra

	string_to_int:
		# args:
		#		a0 -> leftPtr
		#		a1 -> rightPtr
		# return:
		# 		v0 -> convertedValue
		addi $sp, $sp, -4
		sw $t0, 0($sp)											# push t0 onto stack

		li $v0, 0												# accumulator -> v0
		string_to_int_loop:
			bgt $a0, $a1, end_string_to_int_loop				# if (a0 > a1); goto end_string_to_int_loop

			lb $t0, 0($a0)										# load byte at leftPtr
			sub $t0, $t0, '0'									# convert ASCII to digit

			mul $v0, $v0, 10
			add $v0, $v0, $t0									# v0 = v0 * 10 + t0

			addi $a0, $a0, 1									# leftPtr++
			j string_to_int_loop

		end_string_to_int_loop:
			lw $t0, 0($sp)										# pop t0 from stack
			addi $sp, $sp, 4
			jr $ra