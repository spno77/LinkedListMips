		.text
		.globl main

main:
		# Pointers used in the program
		#-----------------------------------------------
		# $s7 --> is head pointer
		# $a3 --> is the current
		# $t0 --> pointer to the new node(return of sbrk() call)
		# Maybe i will need a temp one in the sorted list
		#------------------------------------------------

		#--------------------------------------------------
		# Print prompt and read int from stdin
		#--------------------------------------------------

		la $a0,msg 			# print the msg
		li $v0,4
		syscall

		la $a0,endl 		# print a new line
		li $v0,4
		syscall

		li $v0,5        	# read int from stdin
		syscall		    
		move $t0,$v0

		#-----------------------------------------
		# Based on the user input go to the label
		#-----------------------------------------

		beq $t0,1,insert
		#beq $t0,2, delete
		beq $t0,3,print
		beq $t0,4,exit

		#--------------------------------------------------------
		# If user's input is not in the range (1,4) jump to main
		#--------------------------------------------------------

		la $a0,otherMsg		# print otherMsg
		li $v0,4
		syscall

		la $a0,endl 		# print '\n'
		li $v0,4
		syscall

		j main				# jump to main label
		

insert:    
		#--------------------------------------------
		# Function to insert a new node in the list
		#--------------------------------------------

		# sbrk() allocates space for the new node
		# allocate memory with sbrk for a new node 

		li,$a0,8   			# $a0 number of bytes to alloc	 		
		li $v0,9        	# $v0 is the address of alloc mem
		syscall
		move $t1,$v0		

		sw $zero,4($t1) 	# initialize next pointer of the newNode to zero

		#-----------------------------------------------
		la $a0,insertMsg	# print insertMsg
		li $v0,4
		syscall

		li $v0,5        	# read the int from stdin and move it in $t0
		syscall		    
		move $t0,$v0
		#-----------------------------------------------

		# if the list is empty then insert in the head node
		beq $s7,$zero,declareFirstNode

		
		# $a3 points to the current node
		# $t1 points to the new node ---> because we have moved here the address of the node
		#                                 returned by the sbrk command

		
		lw $t3,($s7)
		ble $t0,$t3,newHead			# branch on less than or equal


		# if list is not empty( the second node + all the others )
		##sw   $t1, 4($a3) 
		##move $a3, $t1		# set curr pointer ($a3) to point to the new node

		##sw $t0, ($t1)  	# $t0---> the int read from stdin

		move $a3,$s7  # current = head (move command copies the value of one register into another)

		# this loop2 is to find the correct node to insert
	loop2:
		
		beq $a3,$zero,lastNode

		lw $t4,($a3) 		# load in $t4 register the value pointed by $a3
			
		#-----------------------------------------
		# if(current != Null && newnode <= current )
		#-----------------------------------------
		#beq $t4,$zero,lastNode
		
		#	la $a0,lolo			# print lololo
		#	li $v0,4
		#	syscall

		#	la $a0,endl			# print endl
		#	li $v0,4
		#	syscall
        ble $t0,$t4,  endloop2

        move $t6,$a3        # this is a dummy register used to store the previous pointer

        lw $a3,4($a3) 		# current = current->next           

		j loop2 
	
	endloop2:

		#beq $t4,$zero,lastNode

		# fix the pointers
		##lw  $t5,4($a3)

		##sw  $t5,4($t1)
		
		##sw  $t1,4($a3) 

		#--------------------------------------------------------
		# Here we fix the pointers
		#--------------------------------------------------------

		#----------Check the insertion in the end----------------


		#--------------------------------------------------------

		lw  $t5,4($t6)
		sw  $t5,4($t1)
		sw  $t1,4($t6)


		# store the integer to the node
		sw  $t0, ($t1)  	# $t0---> the int read from stdin

		j main

		#---------------------------------------------------------------
		# 2. Make new head node in the list
		#--------------------------------------------------------------

lastNode:
				
		sw  $t1,4($t6)

		# store the integer to the node
		sw  $t0, ($t1)  	# $t0---> the int read from stdin

		j main

newHead:
		
		sw $s7,4($t1)
		
		move $s7, $t1		# set head pointer ($s7) to point to the new node
		# move $a3, $t1		# set curr pointer ($a3) to point to the new node
		
		sw  $t0, ($t1)  	# $t0--->the int read from stdin 
							# store the value in the new node

		# fix the pointers
		# sw   $t1, 4($a3) 


		move $a0,$t0 		# print the inserted int (Debug purposes)
		li $v0,1
		syscall

		j main
	
		#-------------------------------------------------------------------
		# 1. Here we declare the first node of the linkedList
		#-------------------------------------------------------------------
declareFirstNode:

		# Just printing here( For debug purposes )
	#--------------------------------------------------------
		la $a0,lala			# print lala
		li $v0,4
		syscall

		la $a0,endl			# print endl
		li $v0,4
		syscall
	#--------------------------------------------------
		
		# la	$s7, ($t1)		# set head pointer ($s7) to point to the new node
		# la	$a3, ($t1)		# set curr pointer ($a3) to point to the new node

		move $s7, $t1		# set head pointer ($s7) to point to the new node
		move $a3, $t1		# set curr pointer ($a3) to point to the new node
		
		sw  $t0, ($t1)  	# $t0--->the int read from stdin 
							# store the value in the new node

		move $a0,$t0 		# print the inserted int (Debug purposes)
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
otherMsg:  .asciiz "Please insert 1,2,3,4"
lala:      .asciiz "lalala"
lolo:      .asciiz "lololo"