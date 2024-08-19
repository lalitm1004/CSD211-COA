.data
	var1: .word 100
	var2: .word 200

.text
	main:
		lw $t0, var1
		lw $t1, var2

		add $t2, $t0, $t1
		sub $t3, $t0, $t1

		li $v0, 10
		syscall