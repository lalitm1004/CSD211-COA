.data
    matOneLabel: .asciiz "matrix 1:\n"
    matTwoLabel: .asciiz "matrix 2:\n"
    rowPrompt: .asciiz "enter num rows > "
    colPrompt: .asciiz "enter num cols > "

    orderError: .asciiz "invalid order\n"
    resultLabel: .asciiz "result:\n"
    x: .asciiz "x"
    arrow: .asciiz " > "

.text
.globl main
    # m1Rows -> s0 ; m1Cols -> s1
    # m2Rows -> s2 ; m2Cols -> s3
    # m3Rows -> s0 ; m3Cols -> s3
    # m1Ptr -> s4
    # m2Ptr -> s5
    # m3Ptr -> s6
    main:
    	# take mat1 dimensions
        li $v0, 4                                               	# print_string syscall
        la $a0, matOneLabel                                     	# load matOneLabel addr into a0
        syscall
    	jal printRowPrompt
    	jal takeIntInput
    	move $s0, $v0												# m1Rows -> s0 = v0
    	jal printColPrompt
    	jal takeIntInput
    	move $s1, $v0												# m1Cols -> s1 = v0
    	
    	# take mat2 dimensions
    	li $v0, 4													# print_string syscall
    	la $a0, matTwoLabel											# load matTwoLabel addr into a0
    	syscall
    	jal printRowPrompt
    	jal takeIntInput
    	move $s2, $v0												# m2Rows -> s2 = v0
    	jal printColPrompt
    	jal takeIntInput
    	move $s3, $v0												# m2Rows -> s3 = v0
    	
    	bne $s1, $s2, printOrderError								# if (m1Cols != m2Rows); throw error;
    	
    	move $a1, $s0												# numRows arg
    	move $a2, $s1												# numCols arg
    	jal malloc
    	move $s4, $v0												# mat1Ptr -> s4 = v0
    	
    	move $a1, $s2												# numRows arg
    	move $a2, $s3												# numCols arg
    	jal malloc
    	move $s5, $v0												# mat2Ptr -> s5 = v0
    
    	move $a1, $s0												# numRows arg
    	move $a2, $s3												# numRows arg
    	jal malloc
    	move $s6, $v0												# mat3Ptr -> s6 = v0											
    
    exit:
    	li $v0, 10													# exit syscall
    	syscall
	
	takeMatInput:
		addi $sp, $sp, -4											# allocate stack space
		sw, $ra, 0($sp)												# store return addr
		# ptr -> t0
		# numRows -> t1
		# numCols -> t2
		li $t3, $t0													# currAddr -> t3 = baseAddr
		li $t4, 0													# i -> t4 = 0
		li $t5, 0													# j -> t5 = 0
		mul $t7, $t1, $t2											# numRows * numCols
		mul $t7, $t7, 4												# numRows * numCols * 4
		add $t7, $t0, $t7											# baseAddr = numRows * numCols * 4
		subi $t7, $t7, 4											# decrement by 4 to get final addr for input
		
			inputLoop:
				# rowXcol user prompt
				li $v0, 1											# print_int syscall
				move $a0, $t4										# move i into a0
				addi $a0, $a0, 1									# a0++
				syscall
				
				li $v0, 4											# print_string syscall
				la $a0, x											# load x addr into a0				
				syscall
				
				li $v0, 1											# print_int syscall
				move $a0, $t5										# move j into a0
				addi $a0, $a0, 1									# a0++
				syscall
				
				li $v0, 4											# print_string syscall
				la $a0, arrow										# load arrow addr into a0
				syscall
			
				# calculate addr to store byte into; t6 -> currAddr = baseAddr + (i * numCols + j) * 4
				mul $t6, $t4, $t1									# i * numCols
				add $t6, $t6, $t5									# (i * numCols + j)
				mul $t6, $t6, 4										# (i * numCols + j) * 4
				add $t6, $t6, $t0									# currAddr -> t6 = baseAddr + (i * numCols + j) * 4		
				
				jal takeIntInput
				sw $v0, 0($t6)										# store userInput in currAddr
				
				addi
				
				blt $t6, $
	
		lw $ra, 0($sp)												# restore return addr
		addi $sp, $sp, 4											# free stack space
		jr $ra
	
	malloc:
		# numRows -> a1
		# numCols -> a2
		mul $a0, $a1, $a2											# numBytes -> a0 = numRows * numCols
		mul $a0, $a0, 4												# numBytes -> a0 = 4 * a0
		
		li $v0, 9													# sbrk (allocate heap memory) syscall
		syscall
		jr $ra
		
	printOrderError:
		li $v0, 4													# print_string syscall
		la $a0, orderError											# load orderError addr into a0
		syscall
		j exit
	
	printRowPrompt:
		li $v0, 4													# print_string syscall
		la $a0, rowPrompt											# load rowInput addr into a0
		syscall
		jr $ra
	
	printColPrompt:
		li $v0, 4													# print_string syscall
		la $a0, colPrompt											# load colInput addr into a0
		syscall
		jr $ra
		
	takeIntInput:
		li $v0, 5													# read_int syscall
		syscall
		jr $ra