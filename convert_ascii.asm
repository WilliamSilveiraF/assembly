.data
	ASCII_DATA:	.space 	512
	FINAL_DATA:	.space 	256
	FILENAME: 	.asciiz "input.dat"
.text
main:
	# read file
	li	$v0, 13
	la	$a0, FILENAME
	li	$a1, 0
	syscall
	
	move	$s0, $v0
	
	# store ASCII_DATA in memory
	li 	$v0, 14
	move 	$a0, $s0
	la	$a1, ASCII_DATA
	li	$a2, 512
	syscall
	
	# convert method: ASCII -> Integer
	jal	convert


	move	$a0, $v0
	
	li	$v0, 16 
	syscall
	
	j	exit

convert:
	move 	$s1, $ra
	
	la	$a0, ASCII_DATA
	la	$a1, FINAL_DATA

	li	$s2, 10
	li	$s3, 0
	li	$s4, 0
	li 	$s5, 0
	
loop:
	move	$t0, $s3
	mul	$t0, $t0, 12
	add	$t0, $t0, $a0
	
	
	lw	$t1, 0($t0)
	lw	$t2, 4($t0)
	
	addi	$t1, $t1, -48
	addi	$t2, $t2, -48
	
	move	$t3, $s4
	mul	$t3, $t3, 4
	add	$t3, $t3, $a1
	
	mul	$t4, $t1, 10
	add	$t4, $t4, $t2
	
	sw	$t4, 0($t3)
	
	addi	$s3, $s3, 1
	addi	$s4, $s4, 1
	
	bne	$s2, $s3, loop
	
	jr	$ra
exit:
