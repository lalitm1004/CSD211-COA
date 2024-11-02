.data
	input: .asciiz "enter n > "
	space: .asciiz " "
	
.text
	main:
		li $v0, 4
		la $a0, input
		syscall
	
		li $v0, 5
		syscall
		move $a1, $v0
		
		jal fibonacci

	exit:
		li $v0, 10
		syscall
		
	fibonacci:
		li $t0, 0
		li $t1, 1
		
		li $t2, 0								# i -> t2
		li $t3, 0								# next -> t3
		
		loop:
			bgt $t2, $a1, loop_exit
			bgt $t2, 1, print_next
			
			print_i:
				move $t3, $t2
				j after_conditional
				
			print_next:
				add $t3, $t0, $t1
				move $t0, $t1
				move $t1, $t3
				j after_conditional
			
			after_conditional:
				li $v0, 1
				move $a0, $t3
				syscall
				
				li $v0, 4
				la $a0, space
				syscall
				addi $t2, $t2, 1
				j loop
												
		loop_exit:
			jr $ra