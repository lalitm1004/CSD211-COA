.data
	inputLen: .asciiz "enter len > "
	inputElement: .asciiz "enter element"
	arrow: .asciiz " > "
	space: .asciiz " "
	lenError: .asciiz "lenght of array must be between 0 and 10\n"

.text
	main:
		li $v0, 4
		la $a0, inputLen
		syscall
		
		li $v0, 5
		syscall
		move $s1, $v0
		
		bgt $s1, 10, len_error
		blez $s1, len_error
		
	malloc:
		mul $t0, $s1, 4
		move $a0, $t0
		li $v0, 9
		syscall
		move $s0, $v0
	
	take_input:
		li $t0, 0									# i -> t0 = 0
		
		input_loop:
			bge $t0, $s1, sort_arr
		
			li $v0, 4
			la $a0, inputElement
			syscall
			
			li $v0, 1
			move $a0, $t0
			syscall
		
			li $v0, 4
			la $a0, arrow
			syscall
		
			mul $t1, $t0, 4
			add $t1, $s0, $t1						# currAddr = baseAddr + i * 4
			
			li $v0, 5
			syscall
			sw $v0, 0($t1)
			
			addi $t0, $t0, 1
			j input_loop
	
	sort_arr:
		move $t0, $s1
		addi $t0, $t0, -1							# i -> t0 = size - 1
		
		outer_loop:
			blez $t0, end_outer
			li $t1, 0								# j -> t1 = 0
			
			inner_loop:
				addi $t8, $t0, 1					# t8 = i + 1
				ble $t1, $t8, end_inner
				
				mul $t2, $t1, 4
				add $t2, $s0, $t2					# t2 -> addr[j]
				lw $t4, 0($t2)
				
				addi $t3, $t2, 4					# t3 -> addr[j + 1]
				lw $t5, 0($t3)
				
				bgt $t4, $t5, swap
				
				addi $t1, $t1, 1
				j inner_loop
				
			end_inner:
				addi $t0, $t0, -1
				j outer_loop
			
			swap:
				sw $t5, 0($t2)
				sw $t4, 0($t3)
				addi $t1, $t1, 1
				j inner_loop
		
		end_outer:
			j print_arr
		
	print_arr:
		li $t0, 0									# i -> t0 = 0
		
		print_loop:
			bge $t0, $s1, exit_print
			
			mul $t1, $t0, 4
			add $t1, $s0, $t1						# currAddr = baseAddr + i * 4
			
			lw $a0, 0($t1)
			li $v0, 1
			syscall
			
			li $v0, 4
			la $a0, space
			syscall
			
			addi $t0, $t0, 1
			j print_loop
		
		exit_print:
			j exit
	
	len_error:
		li $v0, 4
		la $a0, lenError
		syscall
		j exit
	
	exit:
	 	li $v0, 10
	 	syscall