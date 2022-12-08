.data

.text

main:
	# $s0 == n
	# $s1 == p
	
	# $s2 == numerator
	# $s3 == denominator == p!(n - p)!
	li	$v0, 5
	syscall
	move	$s0, $v0
	
	li	$v0, 5
	syscall
	move	$s1, $v0

	jal 	numerator
	move	$s2, $v0
	
	jal	denominator
	move	$s3, $v0
	
	div 	$a0, $s2, $s3
	li	$v0, 1
	syscall

	j EXIT
numerator:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)

	move	$a0, $s0	
	jal	FACT

	lw	$ra, 0($sp)
	addi	$sp, $sp, 4

	jr 	$ra
denominator:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)

	move	$a0, $s1
	jal	FACT
	move	$t8, $v0 # !p 
	
	sub	$a0, $s0, $s1 # (n - p)
	jal	FACT
	move	$t9, $v0 # !(n - p)

	mul	$v0, $t8, $t9 # !p * !(n - p)

	lw	$ra, 0($sp)
	addi	$sp, $sp, 4

	jr	$ra
FACT:
	# $t0 == ref
	li	$t0, 1
	
	beq 	$a0, $zero, GET_OUT_FACT
	
	FACT_LOOP:
	mul	$t0, $t0, $a0
	addi	$a0, $a0, -1
	
	bne	$a0, $zero, FACT_LOOP
	GET_OUT_FACT:
	move	$v0, $t0
	jr	$ra
EXIT: