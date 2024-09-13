.data
	inputMsg: .asciiz "enter string (max len 100) > "
	outputMsg: .asciiz "reversed string > "
	buffer: .space 101

.text
.globl main
	main:
		jal take_input								# call take_input procedure
		la $a1, buffer								# a1 = buffer
		jal find_length								# call find_length procedure
		move $a2, $v1								# move strLen into a2
		jal reverse_string							# call reverse_string procedure
		jal give_output								# call give_output procedure


	exit:
		li $v0, 10									# exit syscall
		syscall

	take_input:
		li $v0, 4									# print_string syscall
		la $a0, inputMsg							# load inputMsg addr into a0
		syscall

		li $v0, 8									# read_string syscall
		la $a0, buffer								# load buffer addr into a0
		li $a1, 101									# bufferSize -> a1 = 101
		syscall

		jr $ra

	find_length:
		move $t0, $a1								# i -> t0 = buffer

		lenLoop:
			lb $t1, 0($t0)							# load byte stored at t0
			beq $t1, $zero, lenEnd_loop				# if t1 == 0; goto end_loop;
			addi $t0, $t0 1							# i++
			j lenLoop

		lenEnd_loop:
			# start addr -> a0
			# end addr -> t0
			sub $v1, $t0, $a1						# len -> v0 = end - start <- t0 - a0
			subi $v1, $v1, 2						# subtract by 2 to avoid newline and eol char

		 jr $ra

	reverse_string:
		# strAddr -> a1
		# strLen -> a2
		move $t0, $a1								# leftPtr -> t0 = a1
		add $t1, $t0, $a2							# rightPtr -> t1 = leftPtr + strLen

			revLoop:
				bge	$t0, $t1, revEnd_loop

				lb $t2, 0($t0)						# load Byte at leftPtr (t2 -> leftByte)
				lb $t3, 0($t1)						# load byte at rightPtr (t3 -> rightByte)

				sb $t3, 0($t0)						# store rightByte in leftPtr
				sb $t2, 0($t1)						# store leftByte in rightPtr

				addi $t0, $t0, 1					# leftPtr++
				subi $t1, $t1, 1					# rightPtr--

				j revLoop

			revEnd_loop:
				jr $ra

	give_output:
		li $v0, 4									# print_string syscall
		la $a0, outputMsg							# load outputMsg addr into a0
		syscall
		la $a0, buffer								# load buffer addr into a0
		syscall

		jr $ra