.data
	matrixA:	.word	1, 2, 3, 0, 1, 4, 0, 0, 1
	matrixB:	.word	1, -2, 5, 0, 1, -4, 0, 0, 1
	newMatrix:	.space  9
.text
main:
	j 	loopRow
loopRow: # t8 = col ; t9 = row
	bgt	$t9, 2, exit 

	ble	$t9, 2,	loopCol

	j loopRow
loopCol:
	bgt	$t8, 2, clearColReg #t8 col index
	
	la 	$a0, matrixA
	mul	$t0, $t9, 3 # rowIdx x columnSize
	
	add 	$t1, $t0, 0 # (rowIdx x columnSize) + columnIndex
	mul	$t1, $t1, 4
	add 	$t1, $t1, $a0
	lw	$t1, ($t1)

	add	$t2, $t0, 1 # (rowIdx x columnSize) + columnIndex
	mul	$t2, $t2, 4
	add	$t2, $t2, $a0
	lw	$t2, ($t2)
	
	add	$t3, $t0, 2 # (rowIdx x columnSize) + columnIndex
	mul	$t3, $t3, 4
	add	$t3, $t3, $a0
	lw	$t3, ($t3)

	
	la	$a0, matrixB
	
	li	$t0, 0
	add 	$t4, $t0, $t8 # (rowIdx x columnSize) + columnIndex
	mul	$t4, $t4, 4
	add 	$t4, $t4, $a0
	lw	$t4, ($t4)

	li 	$t0, 3
	add 	$t5, $t0, $t8 # (rowIdx x columnSize) + columnIndex
	mul	$t5, $t5, 4
	add 	$t5, $t5, $a0
	lw	$t5, ($t5)

	li	$t0, 6
	add 	$t6, $t0, $t8 # (rowIdx x columnSize) + columnIndex
	mul	$t6, $t6, 4
	add 	$t6, $t6, $a0
	lw	$t6, ($t6)
	
	
	mul	$t1, $t1, $t4 # A00 x B00, A01 x B10,...
	mul	$t2, $t2, $t5
	mul	$t3, $t3, $t6

	add	$t1, $t1, $t2 # sum all
	add 	$t1, $t1, $t3 
	
	
	#STORING value $t1
	la	$a0, newMatrix
	mul	$t0, $t9, 3
	add 	$t0, $t0, $t8
	mul	$t0, $t0, 4
	add	$t0, $t0, $a0
	
	sw	$t1, ($t0)
	
	addi	$t8, $t8, 1
	j loopCol
clearColReg:
	li $t8, 0
	addi	$t9, $t9, 1
	j loopRow
exit:
