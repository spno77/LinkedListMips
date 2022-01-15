		.text
		.globl main

main:
		#          Pointers used in the program
		#-------------------------------------------------------
		# $s7 --> pointer to the head of the list
		# $s3 --> pointer to the current node
		# $t0 --> pointer to the new node(return of sbrk() call)
		#-------------------------------------------------------

		#--------------------------------------------------
		# Print prompt and read int from stdin(user input)
		#--------------------------------------------------

		la $a0,msg 			# print the msg
		li $v0,4
		syscall

		la $a0,endl 		# print new line('\n')
		li $v0,4
		syscall

		li $v0,5        	# read int from stdin
		syscall		    
		move $t0,$v0

		#-------------------------------------------------------
		# Based on the user input go to one of the labels below
		#-------------------------------------------------------

		beq $t0,1,insert
		beq $t0,2,delete
		beq $t0,3,print
		beq $t0,4,exit

		#--------------------------------------------------------
		# If user's input is not in the range (1,4) jump to main
		#--------------------------------------------------------

		la $a0,otherMsg		# print otherMsg
		li $v0,4
		syscall

		la $a0,endl 		# print new line('\n')
		li $v0,4
		syscall

		j main				# jump to main label
		
insert:    
		#--------------------------------------------
		# Function to insert a new node in the list
		#--------------------------------------------

		# allocate memory with sbrk for a new node 

		li,$a0,8   			# $a0 number of bytes to alloc	 		
		li $v0,9        	# $v0 is the address of alloc mem
		syscall
		move $t1,$v0		

		sw $zero,4($t1) 	# initialize next pointer of the newNode to zero

		la $a0,insertMsg	# print insertMsg
		li $v0,4
		syscall

		li $v0,5        	# read the int from stdin and move it to $t0
		syscall		    
		move $t0,$v0
		
		# if the list is empty then insert in the head node
		beq $s7,$zero,insertFirstNode

		
		# $s3 points to the current node
		# $t1 points to the new node 
	
		lw $t3,($s7)
		ble $t0,$t3,newHead	

		# if list is not empty( the second node + all the others )
		
		move $s3,$s7  # current = head (move command copies the value of one register into another)

		# this loop is to find the correct node to insert
	loop:	
		beq $s3,$zero,lastNode

		lw $t4,($s3) 		# load in $t4 register the value pointed by $s3
			
		#-------------------------------------------
		# if(current != Null && newnode <= current)
		#-------------------------------------------
        ble $t0,$t4,endloop

        move $t6,$s3        # this is a dummy register used to store the previous pointer

        lw $s3,4($s3) 		# current = current->next           

		j loop 
	
	endloop:
		#--------------------------
		# Here we fix the pointers
		#--------------------------

		lw  $t5,4($t6)
		sw  $t5,4($t1)
		sw  $t1,4($t6)


		# store the integer to the node
		sw  $t0, ($t1)  	# $t0---> the int read from stdin

		j main
	
lastNode:
		#---------------------------------------------------------
		# Insert int in the last node of the list
		#---------------------------------------------------------
				
		sw  $t1,4($t6)

		# store the integer to the node
		sw  $t0, ($t1)  	# $t0---> the int read from stdin

		j main

newHead:
		#---------------------------------------------------------------
		# Make new head node in the list
		#--------------------------------------------------------------
		
		sw $s7,4($t1)
		
		move $s7, $t1		# set head pointer ($s7) to point to the new node
		
		sw  $t0, ($t1)  	# $t0--->the int read from stdin 
							# store the value in the new node
		j main
	
insertFirstNode:
		#----------------------------------------------------
		# Declare the first node of the linkedList
		#----------------------------------------------------

		move $s7, $t1		# set head pointer ($s7) to point to the new node
		move $s3, $t1		# set curr pointer ($s3) to point to the new node
		
		sw  $t0, ($t1)  	# $t0--->the int read from stdin 
							# store the value in the new node
		j main

print:
		#-------------------------------------------------------------
		# print all the list elements, starting from the head pointer
		#--------------------------------------------------------------
	
		# start from the start of the list
		move $s3,$s7  # current = head 

	loop2:
		beq $s3,$zero,endloop2

		# print the integer stored in this node
		lw $a0,($s3)		
		li $v0,1
		syscall

		la $a0,arrow		# print arrow string
		li $v0,4
		syscall
		
		lw $s3,4($s3) 		# current = current->next

		j loop2
	
	endloop2:

		la $a0,nullMsg		# print nullMsg
		li $v0,4
		syscall

		la $a0,endl			# print endl
		li $v0,4
		syscall

		j main				# jump to main label

# option 2 delete
delete:
		#-------------------------------------------
		# Function to delete a node from the List
		#-------------------------------------------

		la $a0,deleteMsg	# print deleteMsg
		li $v0,4
		syscall

		li $v0,5        	# read an int from stdin and move it in $t0
		syscall		    
		move $t0,$v0

		move $s3,$s7		# current = head

		# Find the node we want to delete
	loop3:
		lw $t5,($s3)

		beq $t0,$t5,endloop3

		move $t6,$s3		# keep track of the previous node.
		lw $s3,4($s3)		# go to the next pointer

		# Check if we reached the last node (next pointer == 0)
		beq $s3,$zero,missing

		j loop3

	endloop3:

		# check if the node we want to delete is the head of the list
		lw $t4,($s7)
		beq $t0,$t4,deleteHead

		# get the next node of the current
		lw $s3,4($s3)
		move $t5,$s3

		# store it in the previous node 
		sw $t5,4($t6)

		j main

deleteHead:

		# next node of the head is now the new head
		
		# go to the next node
		lw $s3,4($s3)
		move $s7,$s3	# head pointer point to next node 

		j main

# the case if element is not in the list
missing: 

		la $a0,missingMsg	# print missingMsg
		li $v0,4
		syscall

		la $a0,endl   		# print new line('\n')
		li $v0,4
		syscall
	
		j main
		
exit:	
		#---------------------------
		# Exit the program(option 4)
		#---------------------------

		la $a0,exitMsg		# print exitMsg
		li $v0,4
		syscall

		li $v0,10			# exit program
		syscall


	.data
msg:	.asciiz "Choose one of the following options : 	
			1 --> Enter a new Node in the List 	
			2 --> Delete a Node from the List
			3 --> Print the List 
			4 --> Exit"
endl:	   .asciiz "\n"
insertMsg: .asciiz "Insert an integer value: "
deleteMsg: .asciiz "Delete node with integer value: "
exitMsg:   .asciiz "\tExiting program ..."
arrow:	   .asciiz "-->"
nullMsg:   .asciiz "Null"
otherMsg:  .asciiz "\tPlease insert 1,2,3,4."
missingMsg:.asciiz "\tThis element is not in the list."