.data
	input: .asciiz "enter num rows > "
	space: .asciiz " "
	star: .asciiz "*"
	newline: .asciiz "\n"

.text
.globl main
	main:
		li $v0, 4
		la $a0, input
		syscall
		
		li $v0, 5
		syscall
		move $a1, $v0
		
	print_triangle:
		addi $sp, $sp, -4
		sw $ra, 0($sp)

		li $t0, 0										# i -> t0 = 0
		
		li $a2, 0										# numSpaces -> a2 = 0
		
		mul $a3, $a1, 2
		addi $a3, $a3, 1								# numStars -> a3 = 2*n + 1
		
		triangle_loop:
			bge $t0, $a1, end_triangle_loop				# if (i >= n); goto end_triangle_loop;
			
			
			jal print_line
			
			addi $t0, $t0, 1
			addi $a2, $a2, 1							# numStars++
			addi $a3, $a3, -2
			jal print_line
			
			j triangle_loop
			
		end_triangle_loop:
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			jr $ra
	
	print_line:
		addi $sp, $sp, 4
		sw $t0, 0($sp)
		
		li $t0, 0
		
		print_spaces:
			
		
			
		lw $t0, 0($sp)
		addi $sp, $sp, 4
		jr $ra	
	