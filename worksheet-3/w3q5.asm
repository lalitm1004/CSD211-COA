.data
	ageInput: .asciiz "enter age > "
	voterIdInput: .asciiz "voter id present (1/0) > "
	canVote: .asciiz "person can vote\n"
	cannotVote: .asciiz "person can not vote\n"

.text
.globl main
	main:
		li $v0, 4									# print_string syscall
		la $a0, ageInput							# load ageInput addr into a0
		syscall

		li $v0, 5									# read_int syscall
		syscall
		move $t0, $v0								# age -> t0 = v0

		li $v0, 4									# print_string syscall
		la $a0, voterIdInput						# load voterIdInput addr into a0
		syscall

		li $v0, 5									# read_int syscall
		syscall
		move $t1, $v0								# hasVoterId -> t1 = v0

		li $t2, 18									# store 18 in t2
		slt $t3, $t0, $t1							# t3 = (age < 18)

		beq $t3, 1, personCannotVote
		beq $t1, 0, personCannotVote


	personCanVote:
		la $a0, canVote
		j exit

	personCannotVote:
		la $a0, cannotVote
		j exit

	exit:
		li $v0, 4									# print_string syscall
		syscall
		li $v0, 10									# exit syscall
		syscall