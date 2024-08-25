.data
	string: .ascii "Hello World"					# string to print
	
.text
	main:
		li $v0, 4									# print_string syscall
		la $a0, string								# load string addr into a0
		syscall
		
	exit:
		li $v0, 10									# exit syscall
		syscall