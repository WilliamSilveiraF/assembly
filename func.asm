.data
	indexA:	.asciiz	"\nUsando A: \n"
	indexB:	.asciiz	"\nUsando B: \n"
	result: .asciiz "\nO resultado: \n"
.text
main:
	li 	$v0, 5
	syscall
	move 	$t0, $v0	# $t0 = A

	li	$v0, 5
	syscall
	move 	$t1, $v0	# $t1 = B

	jal	calculate
	jal	print
	j	exit
calculate:
	mul 	$t2, $t1, -1
	div	$t2, $t0
	mflo	$t3
	
	jr	$ra
print:
	li	$v0, 4
	la	$a0, indexA
	syscall
	
	li	$v0, 1
	move 	$a0, $t0
	syscall

	li	$v0, 4
	la	$a0, indexB
	syscall
	
	li	$v0, 1
	move	$a0, $t1
	syscall
	
	li	$v0, 4
	la	$a0, result
	syscall
	
	li	$v0, 1
	move	$a0, $t3
	syscall
	
	jr	$ra
exit:
	
