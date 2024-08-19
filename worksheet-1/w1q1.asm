.data
	string: .ascii "Hello world"			# String to be printed

.text
	main:
		li $v0, 4				# Load print syscall into v0
		la $a0, string				# Load string pointer into a0
		syscall
		
		li $v0, 10				# Load terminate syscall into v0
		syscall