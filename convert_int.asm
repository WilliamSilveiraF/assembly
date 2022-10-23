.data
	intArr:		.word	43 34 23 545 43 100 123 43 42 2
	newIntArr: 	.space 224
	filename:	.asciiz	"dataout.dat"
.text
main:
	la	$s0, intArr	# $s0 base address intArr
	la	$s1, newIntArr	# $s1 base address newIntArr
	li	$s7, 32		# $s7 ASCII SPACE
	j 	calculate
calculate:
	bgt 	$t0, 36, exit	# $t0 row index
	sw	$s7, ($s1)
	addi	$s1, $s1, 4
	add	$t9, $s0, $t0	# $t9 base address + loop index
	lw	$t9, ($t9)

	bge	$t9, 100, handleHundred
	bge	$t9, 10, handleDecimal
	blt	$t9, 10, handleDigit
handleHundred:
	li	$t8, 100
	div	$t9, $t8

	mflo	$t9
	jal 	convertASCII
	
	mfhi	$t9
	bge	$t9, 10, handleDecimal
	jal	convertASCII

	addi	$t0, $t0, 4
	j 	calculate
handleDecimal:
	li	$t8, 10
	div	$t9, $t8
	
	mflo	$t9
	jal 	convertASCII
	
	
	mfhi	$t9
	jal	convertASCII

	addi	$t0, $t0, 4
	j 	calculate
handleDigit:
	jal	convertASCII
	addi	$t0, $t0, 4
	j 	calculate
convertASCII:
	blt	$t9, 0, maskNegative
	addi	$t9, $t9, 48

	sw	$t9, ($s1)
	addi	$s1, $s1, 4
	jr	$ra
	maskNegative:
	not	$t9, $t9
	addi	$t9, $t9, 49

	sw	$t9, ($s1)
	addi	$s1, $s1, 4
	jr	$ra
exit:
	# open file
	li	$v0, 13
	la	$a0, filename
	li	$a1, 1
	li	$a2, 0
	syscall
	move	$s6, $v0
	
	#read file
	li	$v0, 15
	move	$a0, $s6
	la	$a1, newIntArr
	li	$a2, 220
	syscall
	
	
	#close file
	li	$v0, 16
	move	$a0, $s6
	syscall