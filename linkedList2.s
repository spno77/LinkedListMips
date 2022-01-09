	.text
	.globl main

main:
		#------------------------------------------
		# $s7 --> is head pointer
		# $a3 --> is the current
		#------------------------------------------

		#--------------------------------------------------
		# Create a new list(maybe head pointer ?) and init
		#--------------------------------------------------

		la $a0,msg 			# print the msg
		li $v0,4
		syscall

		la $a0,endl 		# print a new line
		li $v0,4
		syscall

		li $v0,5        	# read the option(int)
		syscall		    
		move $t0,$v0

		#---------------------------------------------
		# based on user input go one of the following
		#----------------------------------------------

		beq $t0,1,insert
		#beq $t0,2, delete
		beq $t0,3,print
		beq $t0,4,exit

		la $a0,exitMsg		# print exitMsg
		li $v0,4
		syscall

		li $v0,10			# exit program
		syscall



insert:    
		#---------------------------------------------
		# Function to insert a new node in the list
		#----------------------------------------------

		# sbrk() allocates space for the new node

		li,$a0,8   			# $a0 number of bytes to alloc	 		
		li $v0,9        	# $v0 is the address of alloc mem
		syscall
		move $t1,$v0		

		sw $zero,4($t1) 	# initialize next pointer to zero

		#------------------------------------------
		la $a0,insertMsg	# print insertMsg
		li $v0,4
		syscall

		li $v0,5        	# read the int from stdin
		syscall		    
		move $t0,$v0
		#-------------------------------------------

		# if the list is empty then insert in the head node
		beq $zero,$s7,declareFirstNode

		
		# $a3 points to the current node
		# $t1 points to the new node ---> because we have moved here the address of the node
		#                                 returned by the sbrk command


		# if list is not empty( the second node + all the others )
		sw   $t1, 4($a3) 
		move $a3, $t1		# set curr pointer ($a3) to point to the new node

		sw  $t0, ($t1)  	# $t0---> the int read from stdin 
	

		j main


# Here we declare the first node of the linkeList
declareFirstNode:

		# Just printing here
	#--------------------------------------------------------
		la $a0,lala			# print lala
		li $v0,4
		syscall

		la $a0,endl			# print exitMsg
		li $v0,4
		syscall
	#--------------------------------------------------
		
		# la	$s7, ($t1)		# set head pointer ($s7) to point to the new node
		# la	$a3, ($t1)		# set curr pointer ($a3) to point to the new node

		# I will try with lw for now

		move	$s7, $t1		# set head pointer ($s7) to point to the new node
		move	$a3, $t1		# set curr pointer ($a3) to point to the new node
		
		sw  $t0, ($t1)  	# $t0--->the int read from stdin 
							# store the value in the new node

		move $a0,$t0
		li $v0,1
		syscall

		j main


	# print all the list from the head pointer.
print:
	
	# start from the start of the list
	move $a3,$s7  # current = head (move command copies the value of one register into another)

	loop:
		beq $a3,$zero,endloop


		# print the integer stored in this node
		#----------------------------------------------
		lw $a0,($a3)
		li $v0,1
		syscall

		la $a0,arrow		# print arrow string
		li $v0,4
		syscall
		#-----------------------------------------------

		lw $a3,4($a3) 		# current = current->next

		j loop
	
	endloop:



	la $a0,nullMsg	# print nullMsg
	li $v0,4
	syscall

	la $a0,endl		# print endl
	li $v0,4
	syscall

	j main



exit:	
		la $a0,exitMsg	# print exitMsg
		li $v0,4
		syscall

		li $v0,10		# exit program
		syscall


	.data
msg:	.asciiz "Choose one of the following options : 	
			1 --> Enter a new Node in the List 	
			2 --> Delete a Node from the List
			3 --> Print the List 
			4 --> Exit"
endl:	   .asciiz "\n"
insertMsg: .asciiz "Insert an integer value: "
exitMsg:   .asciiz "Exiting program..."
arrow:	   .asciiz "-->"
nullMsg:   .asciiz "Null"
lala:      .asciiz "lalala"