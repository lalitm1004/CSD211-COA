.data
input_1: .asciiz "Enter the first number > "
input_2: .asciiz "Enter the second number > "
output: .asciiz "The sum of the two numbers is > "

.text
.globl main

main:
	li $v0, 4		# print_string syscall
	la $a0, input_1		# load input_1 addr
	syscall
	
	li $v0, 6		# read_float syscall
	syscall
	mov.s $f2, $f0   	# move input to $f2
	
	li $v0, 4		# print_string syscall
	la $a0, input_2 	# load input_2 addr
	syscall
	
	li $v0, 6		# read_float syscall
	syscall
	mov.s $f4, $f0		# move input to $f4
	
	add.s $f6, $f2, $f4
	
	li $v0, 4		# print_string syscall
	la $a0, output		# load output addr
	syscall
	
	li $v0, 2		# print_float syscall
	mov.s $f12, $f6		# move sum to f12
	syscall

exit:
	li $v0, 10		# exit syscall
	syscall
	
	