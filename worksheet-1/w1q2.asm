.data
	var1:   .word 20               
    	var2:   .word 30               # variable to be swapped
    	space:  .asciiz " "            # whitespace
    	newline: .asciiz "\n"          # newline

.text
	main:
                # load values into register
                lw $s0, var1
                lw $s1, var2

                # print values before swapping
                li $v0, 1                      # print_int syscall
                move $a0, $s0                  # load var1 into a0
                syscall

                li $v0, 4                      # print_string syscall
                la $a0, space                  # load space into a0
                syscall

                li $v0, 1                      # print_int syscall
                move $a0, $s1                  # load var2 into a0
                syscall

                # swap
                add $s0, $s0, $s1              # var1 = var1 + var2
                sub $s1, $s0, $s1              # var2 = var1 - var2
                sub $s0, $s0, $s1              # var1 = var1 - var2

                # print newline before the output
                li $v0, 4                      # print_string syscall
                la $a0, newline                # load newline into a0
                syscall

                # print the output
                li $v0, 1                      # print_int syscall
                move $a0, $s0                  # load swapped var1 into a0
                syscall

                li $v0, 4                      # print_string syscall
                la $a0, space                  # load space into a0
                syscall

                li $v0, 1                      # print_int syscall
                move $a0, $s1                  # load swapped var2 into a0
                syscall

                # Exit the program
                li $v0, 10                     # exit syscall
                syscall