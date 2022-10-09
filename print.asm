.data
	age: 	.word 	-1
	name: 	.asciiz "\nJohn Doe\n"
.text
	li $v0, 1 	# 1 - print a word / an integer
	lw $a0, age
	syscall
	
	li $v0, 4 	# 4 - print a string
	la $a0, name
	syscall