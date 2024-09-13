.data
	inputPrompt: .asciiz "enter string (max len 100) > "
	outputMsg: .asciiz "reversed string > "
	buffer: .space 101

.text
.globl main
	main:
		jal user_input
		
		la $t0, buffer									# load buffer addr into t0
		jal find_length
		sub $a1, $t0, $a0								# str len -> a1 = t0 - a0; (end - start)
		jal reverse_string
		jal program_output
		
		li $v0, 10										# exit syscall
		syscall
		
		
	user_input:
		li $v0, 4										# print_string syscall
		la $a0, inputPrompt								# load inputPrompt addr into a0
		syscall
		
		li $v0, 8										# read_string syscall
		la $a0, buffer									# load buffer addr into a0
		li $a1, 101										# max input length accounting EOL
		syscall
		jr $ra
	
	program_output:
		li $v0, 4										# print_string syscall
		la $a0, outputMsg								# load outputMsg addr into a0
		syscall
		la $a0, buffer									# load buffer addr into a0
		syscall
		jr $ra
	
	find_length:
		lb $t1, 0($t0)									# load byte from t0
		addi $t0, $t0, 1								# move to next byte
		bne $t1, $zero, find_length						# if (t1 !== '\0'); loop;
		jr $ra
	
	reverse_string:
		# str pointer -> a0
		# str len -> a1
		move $t0, $a0									# i -> t0 = start
		add $t1, $t0, $a1								# j -> t1 = end; (start + strLen)
		
		loop:
			lb $t2, 0($t0)								# a = str[i]
			lb $t3, 0($t1)								# b = str[i]
			
			xor $t2, $t2, $t3							# a = a ^ b
			xor $t3, $t2, $t3							# b = a ^ b => (a ^ b) ^ b => a
			xor $t2, $t2, $t3							# a = a ^ b => (a ^ b) ^ a => b
			# swapped values a and b
			
			sb $t2, buffer($t0)							# str[i] = a; (a = b)
			sb $t3,	buffer($t1)							# str[j] = b; (b = a)
			addi $t0, $t0, 1							# i++
			subi $t1, $t1, 1							# j--
			
			bge $t1, $t0, loop
			jr $ra
		
	
			