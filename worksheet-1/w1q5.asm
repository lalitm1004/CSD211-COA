.data
	var0: .word 12								# number to check

.text
	main:
		lw $t0, var0							# load var0 into t0
		li $t2, 2								# store 2 in t2
		div $t0, $t2							# t0 / 2

		mfhi $t3								# store remainder in t3
		beq $t3, $zero, even					# remainder == 0; goto even

		# if remainder is not equal to zero, program will naturally flow into odd subroutine and exit hence no jump to odd is required

	odd:
		li $t1, 0								# t0 is odd; store 0 in t1
		j exit									# jump to exit

	even:
		li $t1, 1								# t0 is even; store 1 in t1
		j exit									# jump to exit

	exit:
		li $v0, 10								# exit syscall
		syscall