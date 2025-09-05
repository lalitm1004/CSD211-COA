.data
arr: .word 10, 20, 30, 40, 50
input_prompt: .asciiz "Enter integer to search for > "
found_output: .asciiz "Element found at index > "
not_found_output: .asciiz "Element not found in arr"

.text
.globl main

main:
	li $v0, 4				# print_string syscall
	la $a0, input_prompt			# load str addr into a0
	syscall
	
	li $v0, 5				# read_int syscall
	syscall
	move $s0, $v0				# $s0: target = $v0 

loop:
	la $s1, arr				# load arr addr into s1
	li $t0, 0				# $t0: i = 0
	li $t1, 5				# $t1: n = 0
loop_iter:
	bge $t0, $t1, loop_exit			# if (i >= n) goto loop_exit
	
	lw $t2, 0($s1)				# $t2: curr = arr[i]
	beq $t2, $s0, element_found		# if (curr == target) goto element_found
	
	addi $s1, $s1, 4			# increment arr pointer
	addi $t0, $t0, 1			# i++
	j loop_iter

element_found:
	li $v0, 4				# print_string syscall
	la $a0, found_output			# load str addr into a0
	syscall
	
	li $v0, 1				# print_int syscall
	move $a0, $t0				# move i into a0
	syscall
	j exit
	
loop_exit:
	li $v0, 4				# print_string syscall
	la $a0, not_found_output		# load str addr into a0
	syscall

exit:
	li $v0, 10				# exit syscall
	syscall