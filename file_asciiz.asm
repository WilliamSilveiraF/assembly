
.data
	matrix:		.word 1, 2, 0, 1
		 	.word -1, -3, 0, 1
		 	.word 3, 6, 1, 3
		 	.word 2, 4, 0, 3
	newMatrixAscii:	.space	132
	newMatrix:	.space 16
	filename:	.asciiz "dataout.dat"

.text
main:	
	# open file
	li	$v0, 13
	la 	$a0, filename
	li	$a1, 1
	li	$a2, 0
	syscall
	move	$s5, $v0

	j 	loopRow
loopRow:
	bgt	$t7, 3, makeFile 
	ble	$t7, 3,	loopCol
	
	j loopRow
loopCol:
	bgt	$t6, 3, clearColReg
	
	# t6 = col ; t7 = row
	la 	$a0, matrix
	mul	$t0, $t7, 4 # (row index * colum size)
	add	$t0, $t0, $t6 #  (row index * colum size + column index)
	mul	$t0, $t0, 4
	add	$t0, $t0, $a0
	
	la	$a1, newMatrix
	mul	$t1, $t6, 4 
	add	$t1, $t1, $t7
	mul	$t1, $t1, 4
	add	$t1, $t1, $a1 # t1 = destino

	lw	$t0, ($t0)
	sw	$t0, ($t1)
	
	addi	$t6, $t6, 1
	j loopCol
clearColReg:
	li $t6, 0
	addi	$t7, $t7, 1
	j loopRow

makeFile:
	la	$s6, newMatrix
	move	$t0, $s6
	la	$s7, newMatrixAscii
	move	$t1, $s7
	
	li	$s0, 32
	li	$s1, 45
 	
 	jal	makeFileLoop
 
makeFileLoop:
	bge	$t1, $s6, exit
	lw	$t2, ($t0)
	addi	$t0, $t0, 4
	
	jal	convert

	sw	$s0,  ($t1)
	addi	$t1, $t1, 4
	
	j makeFileLoop
convert:
	blt	$t2, 0, maskNegative
	addi	$t3, $t2, 48
	
	sw	$t3, ($t1)
	addi	$t1, $t1, 4

	jr	$ra
	maskNegative:
	sw	$s1, ($t1)
	addi	$t1, $t1, 4
	
	move	$t3, $t2
	not 	$t3, $t3
	addi	$t3, $t3, 49
	sw	$t3, 0($t1)
	addi	$t1, $t1, 4

	jr	$ra

exit:
	li	$v0, 15
	move	$a0, $s5
	la	$a1, newMatrixAscii
	li	$a2, 132
	syscall
	
	li   $v0, 16       
  	move $a0, $s5      	
  	syscall 
