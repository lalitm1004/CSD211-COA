.data
	result: .asciiz "Sum of even numbers from 1 to 10 > "

.text
	main:
		li $t1, 1									# load 1 into t1	(i)
		li $t2, 1									# load 10 into t2	(10)
		li $t3, 2									# load 2 into t3	(2)

		loop:
			ble $t1, $t2, check_even				# if (i <= 10); check_even(i);
			j end_loop								# else; goto end_loop

		check_even:
			rem $t4, $t1, $t3						# t4 = i % 2
			bnez $t4, increment_i					# if (i % 2 != 0); skip addition
			add $t0, $t0, $t1						# sum += i

		increment_i:
			addi $t1, $t1, 1						# i++
			j loop									# goto loop

		end_loop:
			li $v0, 4								# print_string syscall
			la $a0, result							# load result addr into a0
			syscall

			li $v0, 1								# print_int syscall
			move $a0, $t0							# move t0 to a0
			syscall

		exit:
			li $v0, 10								# exit syscall
			syscall
