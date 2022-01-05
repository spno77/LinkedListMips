	.text
	.globl main

main:
		#------------------------------------------
		# $s7 --> is head pointer
		# $a3 --> is the current
		#------------------------------------------

		la $a0,msg 		# print the msg
		li $v0,4
		syscall

		la $a0,endl 	# print a new line
		li $v0,4
		syscall

		li $v0,5        # read the option(int)
		syscall		    
		move $t0,$v0

		#---------------------------------------------
		# based on user input go one of the following
		#----------------------------------------------

		beq $t0,1, new
		beq $t0,2, delete
		beq $t0,3, print

new:    
		#---------------------------------------------
		# Function to add a new node in the list
		#----------------------------------------------

		#----------------------------------------------
		# sbrk for two ints(first for data,second 
		# for next node adress)
		#-----------------------------------------------

		li,$a0,8   		# $a0 number of bytes to alloc	 		
		li $v0,9        # $v0 is the address of alloc mem
		syscall

		move $t1,$v0	# move the address to a temp register

		li $v0,5		# read an int from the user
		syscall
		move $t2,$v0

		sw $t2,($t1)	# store the user input int in the heap
		sw $zero,4($t1) # initialize next to zero pointer to zero

delete: 

print:	 #----------------------------------------------
		 # print every node of the list one by one
		 #----------------------------------------------

loop: 	 beqz $s7,done 	# while the pointer is not null

		 #------------------------------------------------
		 #  1. Get the data of this node.
		 #  2. Print the data of this node
		 #  3. Get the pointer to the next node
		 # 	4. jump to the loop label
		 #-------------------------------------------------	


		 

done:		


	
exit:	li $v0,10		# exit program
		syscall


	.data
msg: .asciiz "Choose one of the following options : 	
			1. Enter a new Node in the List 	
			2. Delete a Node from the List
			3. Print the List "
endl:	.asciiz "\n"
