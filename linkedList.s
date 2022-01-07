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
		beq $t0,2, delete
		beq $t0,3, print

insert:    
		#---------------------------------------------
		# Function to insert a new node in the list
		#----------------------------------------------

		#----------------------------------------------
		# sbrk for two ints(first for data,second 
		# for next node adress)
		#-----------------------------------------------

		li,$a0,8   		# $a0 number of bytes to alloc	 		
		li $v0,9        # $v0 is the address of alloc mem
		syscall

		move $t1,$v0	# move the address to a temp register

		la $a0,insertMsg	# print the insertMsg string 
		li $v0,4
		syscall

		li $v0,5		# read an int from the user
		syscall
		move $t2,$v0

		sw $t2,($t1)	# store the user input integer in the heap
		sw $zero,4($t1) # initialize next  pointer to zero
	
		#---------------------------------------------------
		# IF list is empty then this is the first node 
		#----------------------------------------------------

		beq $s7,$zero,firstNode

		#----------------------------------------------------
		# $a3 ptr to the current node
		# $t1 ptr to the new node
		#----------------------------------------------------

		lw $t2,4($a3) # check for the next node of the current node
		beq $zero,$t2,noNextNode
		

otherNode:

		#-----------------------------------------------------
		# Check for the next node of the current node
		#-----------------------------------------------------

		lw $t3,4($t1)
		beq $t3,$zero,noNextNode


noNextNode: 

		#------------------------------------------------------
		#    1.Get address of the next field of current node
	    #    2.Store that address in new node next field
		#------------------------------------------------------

		lw $t2,4($a3) # 1.
		sw $t2,4($t1) # 2.

		la $t0,($t1) # load addrees of the int stored 
		sw $t0,4($a3)# store the address int current node next field

		la $t2,($a3)
		sw $t2,($t1)


		la $a3,$t1

		j insert

firstNode: 

		#-----------------------------------------------------
		# head pointer $s7 is now pointing the int inside the node
		#----------------------------------------------------

		la $s7,($t1) 

		#-------------------------------------------------------
		# current pointer $a3 is pointing the int inside the node
		#-------------------------------------------------------

		la $a3,($t1)

		j otherNode
		

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
msg:	.asciiz "Choose one of the following options : 	
			1 --> Enter a new Node in the List 	
			2 --> Delete a Node from the List
			3 --> Print the List "
endl:	.asciiz "\n"
insertMsg: .asciiz "Insert an integer value: "
