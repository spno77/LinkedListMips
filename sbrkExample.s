	.text
	.globl main

main:

					# sbrk for two ints
	li,$a0,8   		# $a0 number of bytes to alloc	 		
	li $v0,9        # $v0 is the address of alloc mem
	syscall
		       
	move $t1,$v0

	li $v0,5
	syscall
	sw $v0,($t1) 	# store it to the heap

	li $v0,5
	syscall
	sw $v0,4($t1)   # store the second one 

	lw $a0,($t1)   	# print the first one
	li $v0,1
	syscall

	la $a0,endl     # print endl
	li $v0,4
	syscall

	lw $a0,4($t1) 	# print the second one
	li $v0,1
	syscall

	li $v0,10
	syscall

	.data
endl: .asciiz "\n"


