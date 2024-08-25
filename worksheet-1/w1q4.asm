.data
	var0: .word -88								# number to be checked

.text
	lw $t0, var0								# load var0 into t0
	
	bgt $t0, $zero, greater						# if (t0 > 0) goto greater
	beq	$t0, $zero, equal						# if (t0 == 0) goto equal
	blt	$t0, $zero, lesser						# if (t0 < 0) goto lesser
	
	greater:
		li $t1, 1								# t0 is +ve; store 1 in t1
		j exit									# jump to exit
	
	equal:
		li $t1, 0								# t0 is 0; store 0 in t1
		j exit									# jump to exit
	
	lesser:
		li $t1, -1								# t0 is -ve; store -1 in t1
		j exit									# jump to exit
		
	exit:
		li $v0, 10								# exit syscall
		syscall