.data
	var0: .word 1
	var1: .word 2									# variables to add and subtract

.text
	main:
		lw $t0, var0								# load var0 into t0
		lw $t1, var1								# load var1 into t1
		
		add $t2, $t0, $t1							# store t0 + t1 in t2
		sub $t3, $t0, $t1							# store t0 - t1 in t3
	
	exit:
		li $v0, 10									# exit syscall
		syscall