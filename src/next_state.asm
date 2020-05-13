	.text

# WIP note: color constants could be put in a static register in order not to load it at every iteration
	.globl next_state
# next_state() calculates the next state of the game based on the display_matrix and puts it in the next_state_matrix
#
# note: since spilling return address at every iteration is expensive, it is done before and after the entire loop
# note: since multiplying the matrix index by the word size and adding the result to the base address is expensive and given that the procedure works sequentially, we prefer keeping a display_matrix and a next_state_matrix current address, wich we update at every iteration. For the same reason there's also no need for nested loops.
next_state:

	# spilling s registers (push)
	addi $sp $sp -24
	sw $s0 24($sp)
	sw $s1 16($sp) 			 			# static registers
	sw $s2 12($sp)
	sw $s6 8($sp)
	sw $s7 4($sp)
	sw $ra 0($sp) 			 			# return address (for future call)

	move $s0 $zero 						# initializes monodimensional current word index in s0
	la $s1 display_matrix					# display_matrix base address in s1
	la $s2 next_state_matrix 				# next_state_matrix base address in s2
	li $s7 4096 						# first word out of the display_matrix (just a boundary for exiting the following loop - beq immediate is inefficient)
	li $s6 0xffffff 					# active color register (in order not to load it at every iteration)

	loop:
		beq $s0 $s7 end

		# calling neighbor_counter
		move $a0 $s0 					# first argument: monodimensional word counter
		move $a1 $s1 					# second argument: absolute display_matrix word address
		jal neighbor_counter 				# call neighbor_counter(a0, a1)

		# apply game rules to determine the next state
		beq $v0 3 on					# if the pixel has 3 active neighbors it lives
		bne $v0 2 off					# if the pixel has 2 active neighbors it lives only if it is active
		lw $t0 0($s1)
		bnez $t0 on					# (zero is inactive)

	# apply next state to the respective next_state_matrix word
	off:
		sw $zero 0($s2)
		j after
	on:
		sw $s6 0($s2)

	after:
		addi $s1 $s1 4 					# updates current working address in the display_matrix
		addi $s2 $s2 4 					# updates current working address in the next_state_matrix
		addi $s0 $s0 1 					# updates word index
		j loop

end:
	# popping spilled registers
	lw $ra 0($sp) 						# return address
	lw $s7 4($sp) 						# static registers
	lw $s6 8($sp)
	lw $s2 12($sp)
	lw $s1 16($sp)
	lw $s0 20($sp) 						# static registers
	addi $sp $sp 24

	jr $ra 							# return
