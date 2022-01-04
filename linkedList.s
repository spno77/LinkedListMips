	.text
	.globl main

main:

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

		beq $t0,1,new
		beq $t0,2,delete
		beq $t0,3,print




new: # sbrk for two ints the first is the data
	 # and the second is the address(pointer)

delete: 

print: # print every node of the list one by one

	
		li $v0,10		# exit program
		syscall


	.data
msg: .asciiz "Choose one of the following options : 	
			1. Enter a new Node in the List 	
			2. Delete a Node from the List
			3. Print the List "
endl:	.asciiz "\n"
