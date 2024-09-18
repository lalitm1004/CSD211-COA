.data
	inputFileName: .asciiz "q1_input.txt"
	outputFileName: .asciiz "q1_output.txt"
	outputMsg: .asciiz "char count > "
	buffer: .space 4096
	countBuffer: .space 20

.text
.globl main
	main:
		li $v0, 13											# open_file syscall
		la $a0, inputFileName								# load inputFileName addr into a0
		li $a1, 0											# read flag
		li $a2,	0											# no special permissions
		syscall
		move $s0, $v0										# inputFileDesc -> s0 = v0
		
		li $v0, 14											# read_file syscall
		move $a0, $s0										# move inputFileDesc into a0
		la $a1, buffer										# load buffer addr into a1
		li $a2, 4096										# max read size
		syscall
		
		move $s1, $v0										# charCount -> s1 = v0
		li $v0, 4											# print_string syscall
		la $a0, outputMsg									# load outputMsg addr into a0
		syscall
		li $v0, 1											# print_int syscall
		move $a0, $s1										# move charCount into a0
		syscall
		
		
		li $v0, 16											# close_file syscall
		move $a0, $s0										# move inputFileDesc into a0
		syscall
		
		li $v0, 13											# open_file syscall
		la $a0, outputFileName								# load outputFileName addr into a0
		li $a1, 1											# write flag
		li $a2, 0											# no special permissions
		syscall
		move $s0, $v0										# outputFileDesc -> s0 = v0
		
		li $v0, 15											# write_file syscall
		move $a0, $s0										# move outputFileDesc into a0
		la $a1, outputMsg									# load outputMsg addr into a1
		li $a2, 13											# hard coded char count
		syscall
		
		la $a0, countBuffer									# load countBuffer addr into a0
		move $a1, $s1										# move charCount into a1
		jal int_to_string
		move $s2, $v0										# move strLen into s2
		
		li $v0, 15											# write_file syscall
		move $a0, $s0										# move outputFileDesc into a0
		la $a1, countBuffer									# load countBuffer addr into a0
		move $a2, $s2										# move strLen into a2
		syscall
		
		li $v0, 16											# close_file syscall
		move $a0, $s0										# move outputFileDesc into a0
		syscall
		
	exit:
		li $v0, 10											# exit syscall
		syscall
	
	int_to_string:
	# a0 -> countBuffer
	# a1 -> num
		li $t0, 10											# divisor
		li $t1, 0											# counter -> t1
		move $t2, $a1										# cpyNum -> t2 = a1
		
		push_digits:
			div $t2, $t0									# cpyNum / 10
			mfhi $t3										# remainder -> t3 (current digit)
			mflo $t2										# quotient -> t2 (next iteration)
			addi $t3, $t3, 48								# convert to ASCII
			addi $sp, $sp, -4								# allocate space on stack
			sw $t3, 0($sp)									# push digit onto stack						
			addi $t1, $t1, 1								# counter++
			bnez $t2, push_digits							# if (quotient != 0); goto push_digits;
		
		move $t2, $a0										# start of countBuffer
		pop_digits:
			lw $t3, 0($sp)									# pop digit
			addi $sp, $sp, 4								# deallocate space on stack
			sb $t3, 0($t2)									# store into countBuffer
			addi $t2, $t2, 1								# move to next byte
			addi $t1, $t1, -1								# decrement counter
			bnez $t1, pop_digits							# if (counter != 0); goto pop_digits;
		
		sb $zero, 0($t2)									# null terminate string
		sub $v0, $t2, $a0									# strLen -> v0
		jr $ra		