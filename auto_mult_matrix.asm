.data
	inTextNSize:	.asciiz 	"\nMatrix size: "
	breakLine:	.asciiz		"\n"
	filename:	.asciiz 	"dataout_dynamic_matrix.txt"
.text
main:
	# $s3 = result matrix base address
	# $s4 = second matrix base address
	# $s5 = position amount for both matrixs
	# $s6 = HeapBaseAddress
	# $s7 = MatrixSize (n x n)
	jal createDynamicMemory
	
	jal calculateMatrixIndexs
	li	$t0, 0
	move	$t9, $s6
	jal readMatrix
	
	j multiply
	j exit
createDynamicMemory:
	# GET MATRIX SIZE
	la	$a0, inTextNSize
	li 	$v0, 4
	syscall

	li	$v0, 5
	syscall
	move	$s7, $v0
	
	#ALLOCATE MEMORY
	li	$v0, 9
	mul	$t0, $s0, $s0
	mul	$t0, $t0, 4
	move	$a0, $t0
	syscall

	move	$s6, $v0

	jr	$ra
calculateMatrixIndexs: 
	mul	$t0, $s7, $s7  
	mul	$s5, $t0, 2 	#$s5 = position amount for both matrixs
	
	mul	$t0, $t0, 4	# matrix pos amount
	
	add	$s4, $t0, $s6	# (Second matrix address = a matrix pos amount + base heap)
	
	add	$s3, $t0, $s4 	# Result Matrix Base Address

	jr $ra
readMatrix:
	# $t9 heap pos index
	# get value to be stored
	li	$v0, 5
	syscall
	move	$t1, $v0
	
	sw	$t1, ($t9)
	addi	$t9, $t9, 4
	addi	$t0, $t0, 1

	beq	$t0, $s5, goBack

	j readMatrix
	goBack:
	jr $ra
multiply:
	li	$t0, 0 # $t0 = i
	li	$t1, 0 # $t1 = j
	li	$t2, 0 # $t2 = K
	
	move	$t7, $s3 # result matrix ref
	
	j iterate_row
iterate_row:
	beq	$t0, $s7, formatASCII

	j iterate_col
iterate_col:
	beq	$t1, $s7, goBackRow
	
	
	li	$t6, 0	# $t6 sum K results
	jal	iterate_K
	
	#store mult result
	sw	$t6, ($t7)
	addi	$t7, $t7, 4

	addi	$t1, $t1, 1
	
	j iterate_col
	goBackRow:
	addi	$t0, $t0, 1 # NextRow
	li	$t1, 0 # clear col index
	j iterate_row
iterate_K:
	beq	$t2, $s7, goBackCol
	
	#break line
	#la	$a0, breakLine
	#li 	$v0, 4
	#syscall

	# GET FIRST MATRIX VALUE
	# [i * n + K] == [$t0 * $s7 + $t2]
	
	mul	$t9, $t0, $s7
	add 	$t9, $t9, $t2
	mul	$t9, $t9, 4
	add	$t9, $s6, $t9
	lw	$t9, ($t9) # $t9 FIRST MATRIX VALUE

	
	# GET SECOND MATRIX VALUE
	# [K * n + j] == [$t2 * s7 + $t1]
	
	mul	$t8, $t2, $s7
	add	$t8, $t8, $t1
	mul	$t8, $t8, 4
	add	$t8, $s4, $t8
	lw	$t8, ($t8) # $t8 SECOND MATRIX VALUE
	
	mul	$t9, $t8, $t9
	add	$t6, $t6, $t9 # add K(n) mult
	
	addi	$t2, $t2, 1
	j iterate_K
	goBackCol:
	li $t2, 0
	jr $ra

formatASCII:
	# $s0 = 32
	# $s1 = 10
	# $s2 = base adress ASCII REF
	# $s4 = 45 "-" ASCII
	# $t7 = ASCII REF PIVOT
	li	$s0, 32
	li	$s1, 10
	move	$s2, $t7 # ASCII REF
	li	$s4, 45

	move	$t0, $s3 # $t0 = result matrix pivot
	mul	$t1, $s7, $s7 # $t1 = final pos ref
	li	$t2, 0 # $t2 = pos pivot index
	j	iterateResult
	
iterateResult:
	beq	$t2, $t1, goExit
	
	div	$t5, $t2, $s7
	mfhi 	$t5
	bne	$t5, $zero, jumpBreakLine

	li	$a0, 10
	sw	$a0, ($t7)
	addi	$t7, $t7, 4
	
	jumpBreakLine:
	
	lw	$t9, ($t0)
	
	li	$t8, 0

	jal	convert
	
	sw	$s0, ($t7) # STORE SPACES BETWEEN NUMBERS
	addi	$t7, $t7, 4

	addi	$t0, $t0, 4
	addi	$t2, $t2, 1
	
	j iterateResult
	goExit:
	j exit
convert:
	maskSignal:
	blt	$t9, $zero, maskNegative
	j maskDigit
	maskNegative:
	mul	$t9, $t9, -1

	sw	$s4, ($t7)
	addi	$t7, $t7, 4
	maskDigit:
	# $t8 = digits amount
	beq	$t9, $zero, maskNum
	div	$t9, $s1
	
	mfhi	$a0
	addi	$sp, $sp, -4
	sw	$a0, 0($sp)
	
	mflo	$t9
	addi	$t8, $t8, 1
	j maskDigit

	maskNum:
	beq	$t8, $zero, goBackConvert
	
	lw	$a0, 0($sp)
	addi	$a0, $a0, 48 # !! ASCII
	sw	$a0, ($t7)
	addi	$t7, $t7, 4
	
	addi	$sp, $sp, 4
	addi	$t8, $t8, -1

	j maskNum
	goBackConvert:
	jr $ra
exit:
	# open file
	li	$v0, 13
	la 	$a0, filename
	li	$a1, 1
	li	$a2, 0
	syscall
	
	move	$s6, $v0
	
	#write file
	li	$v0, 15
	move	$a0, $s6
	move	$a1, $s2 # $s2 === base address - ASCII Result Matrix 
	li	$a2, 2048
	syscall
	
	#closing file
	li	$v0, 16
	move	$a0, $s6
	syscall
	