.data
	intInput: .asciiz "enter num > "
	binaryStr: .space 33										# 32 bits + null terminating

.text
.globl main
	main:
		li $v0, 4												# print_string syscall
		la $a0, intInput										# load intInput addr into a0
		syscall

		li $v0, 5												# read_int syscall
		syscall
		move $t0, $v0											# num -> t0 = v0

	convert_binary:
		li $t1, 31												# i -> t1 = 32

		loop:
			andi $t2, $t0, 1									# get least significant bit
			addi $t2, $t2, '0'									# store ASCII for '0' or '1'
			sb $t2, binaryStr($t1)								# str[i] = t4
			srl $t0, $t0, 1										# right shift to get next bit
			subi $t1, $t1, 1									# i--
			bgt $t1, -1, loop								# loop while (i != 0)

		li $t1, 32
		sb $zero, binaryStr($t1)								# store null terminating at 33

	exit:
		li $v0, 4												# print_string syscall
		la $a0, binaryStr										# load binaryStr addr into a0
		syscall

		li $v0, 10												# exit syscall
		syscall