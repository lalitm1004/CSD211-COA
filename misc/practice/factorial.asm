.data
	input: .asciiz "x > "
	output: .asciiz "fact(x) > "

.text
	li $v0, 4
	la $a0, input
	syscall
	
	li $v0, 5
	syscall
	move $a0, $v0
	
	jal factorial
	move $a1, $v0
	
	li $v0, 4
	la $a0, output
	syscall
	
	li $v0, 1
	move $a0, $a1
	syscall
	
	exit:
		li $v0, 10
		syscall
	
	factorial:
		addi $sp, $sp, -8
		sw $a0, 0($sp)
		sw $ra, 4($sp)
		
		li $v0, 1
		ble $a0, 1, end_factorial
		addi $a0, $a0, -1
		jal factorial
		
		lw $a0, 0($sp)
		mul $v0, $v0, $a0
		
	end_factorial:
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		jr $ra
		