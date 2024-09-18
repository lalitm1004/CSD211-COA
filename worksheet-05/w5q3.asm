.data
	inputFileName: .asciiz "q3_input.txt"
	outputFileName: .asciiz "q3_output.txt"
	buffer: .space 4096

.text
.globl main
	main:
		li $v0, 13												# open_file syscall
		la $a0, inputFileName									# load inputFileName addr into a0
		li $a1, 0												# read flag
		li $a2, 0												# no special permissions
		syscall
		move $s0, $v0											# move inputFileDesc into s0
		
		li $v0, 14												# read_file syscall
		move $a0, $s0											# move inputFileDesc into a0
		la $a1, buffer											# load buffer addr into a1
		li $a2, 4096											# max read size
		syscall
		move $s1, $v0											# numChar -> s1 = v0
		
		li $v0, 16												# close_file syscall
		move $a0, $s0											# move inputFileDesc into a0
		syscall
		
		la $a0, buffer											# load buffer addr into a0
		move $a1, $s1											# move numChar into a1
		
		li $t0, 1												# currentCharNum -> t0 = 1
		move $t1, $a0											# leftPtr -> t1 = bufferAddr
		move $t2, $a0											# rightPtr -> t2 = bufferAddr
		j reverse_file

		write_to_file:
			li $v0, 13											# open_file syscall
			la $a0, outputFileName								# load outputFileName addr into a0
			li $a1, 1											# write flag
			li $a2, 0											# no special permissions
			syscall
			move $s0, $v0										# move outputFileDesc into s0
		
			li $v0, 15											# write_file syscall
			move $a0, $s0										# move outputFileDesc into a0
			la $a1, buffer										# load buffer addr into a1
			move $a2, $s1										# move numChar into s1
			syscall
			
			li $v0, 16											# close_file syscall
			move $a0, $s0										# move outputFileDesc into a0
			syscall
			
		exit:
			li $v0, 10											# exit syscall
			syscall
			
		reverse_file:
			find_delimiter:
				bge $t0, $s1, write_to_file
				lb $t3, 0($t2)									# currRightByte -> t3
				beq $t3, 13, reverse_line						# if (currRightByte == CR); goto revese_line;
				addi $t2, $t2, 1								# increment rightPtr
				addi $t0, $t0, 1								# incrment currentCharNum
				j find_delimiter
			
			reverse_line:
				addi $t3, $t2, -1								# get addr of substr end excluding carriage return
				
				reverse_line_loop:
					lb $t8, 0($t1)								# load leftChar
					lb $t9, 0($t3)								# load rightChar
			
					sb $t9, 0($t1)								# store rightChar in leftAddr
					sb $t8, 0($t3)								# store leftChar in rightAddr
				
					addi $t1, $t1, 1							# increment leftPtr
					addi $t3, $t3, -1							# decrement t3
				
					bge $t1, $t3, reverse_line_end_loop
					j reverse_line_loop
				
				reverse_line_end_loop:
					addi $t2, $t2, 2							# skip EOL
					move $t1, $t2								# move leftPtr to rightPtr
					j find_delimiter