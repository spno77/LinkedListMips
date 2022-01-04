	.globl main

main:

					# sbrk for two ints
newNode:	li,$a0,8   		 		
			li $v0,9       
			syscall
			       
			move $t1,$v0    # now $t1 is the address of the first node


			li,$a0,8   		 		
			li $v0,9       
			syscall
			       
			move $t1,$v0    # now $t1 is the address
		

	
	
			li $v0,10
			syscall

	.data
endl: .asciiz "\n"


