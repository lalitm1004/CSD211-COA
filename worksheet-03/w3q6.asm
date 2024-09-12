.data
	strInput: .asciiz "enter string (max len 100) > "
	isPalindromeOutput: .asciiz "palindrome\n"
	isNotPalindromeOutput: .asciiz "not palindrome\n"
	buffer: .space 101

.text
.globl main
	main:
		li $v0, 4													# print_string syscall
		la $a0, strInput											# load strInput addr into a0
		syscall

		li $v0, 8													# read_string syscall
		la $a0, buffer												# load buffer addr into a0
		li $a1, 101													# max input length, additional 1 for \0
		syscall

		la $t0, buffer												# load buffer addr into t0 (start of str)
		move $t1, $t0												# copy t0 into t1 for finding length of str

	find_length:
		lb $t2, 0($t1)												# load byte from current position of str
		beq $t2, $zero, check_palindrome							# if (t2 == '\0'); check_palindrome;
		addi $t1, $t1, 1											# move to next char
		j find_length

	check_palindrome:
		sub $t3, $t1, $t0											# strLen -> t3 = end - start
		subi $t3, $t3, 2											# exclude newline char and \0

		move $t4, $t0												# i -> t4 = start
		add $t5, $t0, $t3											# j -> t5 = start + strLen (doesnt include \n)

	palindrome_loop:
		lb $t6, 0($t4)												# load byte from i
		lb $t7, 0($t5)												# load byte from j

		bne $t6, $t7, is_not_palindrome								# if (str[i] !== str[j]); not_palindrome
		addi $t4, $t4, 1											# i++
		subi $t5, $t5, 1											# j++

		bge $t4, $t5, is_palindrome									# if (i > j); is_palindrome
		j palindrome_loop

	is_palindrome:
		la $a0, isPalindromeOutput									# load isPalindromeOutput addr into a0
		j exit

	is_not_palindrome:
		la $a0, isNotPalindromeOutput								# load isNotPalindromeOutput addr into a0

	exit:
		li $v0, 4													# print_string syscall (print result)
		syscall
		li $v0, 10													# exit syscall
		syscall