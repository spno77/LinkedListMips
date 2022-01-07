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

		beq $t0,1, insert
		#beq $t0,2, delete
		#beq $t0,3, print
		beq $t0,4, exit

		la $a0,exitMsg	# print exitMsg
		li $v0,4
		syscall

		li $v0,10		# exit program
		syscall


insert:    
		#---------------------------------------------
		# Function to insert a new node in the list
		#----------------------------------------------

		#sbrk() allocates space for the new node

		li,$a0,8   		# $a0 number of bytes to alloc	 		
		li $v0,9        # $v0 is the address of alloc mem
		syscall
		move $t1,$v0

		sw $zero,4($t1) #initialize next pointer to zero

		#-------------------------------------
		la $a0,insertMsg	# print insertMsg
		li $v0,4
		syscall

		li $v0,5        	# read the int from stdin
		syscall		    
		move $t0,$v0
		#---------------------------------------

		# if the list is empty then this is the head node
		beq $zero,$s7,declareFirstNode

		# if list is not empty

		# $a3 points to the current node
		# $t1 points to the new node

		# load the address of the next pointer of the current node
		lw $t2,4($a3)
		beq $t2,$zero,noNextNode

		########################
		move $t0,$t2

		########################

		j exit



declareFirstNode:

		la $a0,lala	# print lala
		li $v0,4
		syscall

		la $a0,endl	# print exitMsg
		li $v0,4
		syscall
		
		la	$s7, ($t1)	#set head pointer to point the int in the new node
		la	$a3, ($t1)	#set curr pointer to point the int string in the new node
		sw  $t0, ($t1)  #store the value in the heap


		j main


noNextNode:
		
		#t1 is the address of the new node returned by the sbrk syscall

		lw	$t2, 4($a3)		# get address of next field of current node
		sw	$t2, 4($t1)		# store that adress in new node's next field 

		# get address of the current int
		la $t0,(t1)
		# store that address into current node's next field
		sw $t0,4($a3)

		#la	$t2, ($a3)	#load address of current node's string
		#sw	$t2, ($t1)	#store that address into the current node's previous field

		la $a3,($t1)

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
endl:	.asciiz "\n"
insertMsg: .asciiz "Insert an integer value: "
exitMsg:   .asciiz "Exiting program.."
lala: .asciiz "lalala"