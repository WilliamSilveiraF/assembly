
.data
	matrix:		.word 1, 2, 0, 1
		 	.word -1, -3, 0, 1
		 	.word 3, 6, 1, 3
		 	.word 2, 4, 0, 3
	newMatrix:	.space 16

.text
main:	
	j 	loopRow
loopRow:
	bgt	$t7, 3, exit 
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

#getRowValues:
#	mul	$t6, $t7, 4 # (row Index * column size)
	
#	add	$t0, $t6, 0 # (row Index * column size + columnIndex)

#	mul 	$t0, $t0, 4 # (rowIndex * columnSize + columnIndex) * datasize
	
#	add	$s0, $t0, $a0

#	move $a0, $t0
#	li $v0, 1
#	syscall

#	jr $ra

exit:
	
