.data
    inputMsg: .asciiz "x > "
    outputMsg: .asciiz "fact(x) > "

.text
.globl main
    main:
        jal take_input                      # call take_input procedure
        jal factorial                       # call factorial procedure
        jal give_output                     # call give_output procedure

    exit:
        li $v0, 10                          # exit syscall
        syscall

    take_input:
        li $v0, 4                           # print_string syscall
        la $a0, inputMsg                    # load inputMsg addr into a0
        syscall

        li $v0, 5                           # read_int syscall
        syscall
        move $a0, $v0                       # n -> a0 = v0

        jr $ra

    factorial:
        # n -> a0
        addi $sp, $sp, -8                   # allocate space in stack
        sw $ra, 4($sp)                      # store return addr
        sw $a0, 0($sp)                      # store n

        li $v1, 1                           # base_case return
        blt $a0, 2, end_factorial           # if (n < 2); goto end_factorial;

        addi $a0, $a0, -1                   # n--
        jal factorial                       # call factorial(n-1)

        lw $a0, 0($sp)                      # restore n
        mul $v1, $a0, $v1                   # n * factorial(n-1)

    end_factorial:
        lw $ra, 4($sp)                      # restore return addr
        addi $sp, $sp, 8                    # deallocate space in stack
        jr $ra

    give_output:
        li $v0, 4                           # print_string syscall
        la $a0, outputMsg                   # load outputMsg addr into a0
        syscall

        li $v0, 1                           # print_int syscall
        move $a0, $v1                       # move factorial(n) into a0
        syscall

        jr $ra