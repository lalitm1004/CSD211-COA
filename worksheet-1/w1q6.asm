.data
	value: .word 0								# reserve word in memory
	
.text
	main:
		li $t0, 25								# load 25 into t0
		sw $t0, value							# store t0 in value
		lw $t0, value							# load value into t0

	exit:
		li $v0, 10								# exit syscall
		syscall							