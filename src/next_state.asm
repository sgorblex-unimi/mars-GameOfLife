	.text

	.globl next_state
# next_state() calculates the next state of the game based on the display_matrix and puts it in the next_state_matrix
#
# note: since multiplying the matrix index by the word size and adding the result to the base address is expensive and given that the procedure works sequentially, we prefer keeping a display_matrix and a next_state_matrix current address, wich we update at every iteration. For the same reason there's also no need for nested loops.
next_state:
	# spill registers (push)
	addi $sp $sp -24
	sw $s0 20($sp) 						# static registers
	sw $s1 16($sp) 			 			
	sw $s2 12($sp)
	sw $s6 8($sp)
	sw $s7 4($sp)
	sw $ra 0($sp) 			 			# return address

	move $s0 $zero 						# monodimensional current word index in s0
	la $s1 display_matrix					# display_matrix base address in s1
	la $s2 next_state_matrix 				# next_state_matrix base address in s2
	li $s7 4096 						# exit loop constant in s7
	la $s6 active_color
	lw $s6 0($s6) 						# active color in s6

	loop:
		beq $s0 $s7 end

		# calling neighbor_counter
		move $a0 $s0 					# first argument: monodimensional word counter
		move $a1 $s1 					# second argument: absolute display_matrix word address
		jal neighbor_counter 				# call neighbor_counter(a0, a1)

		# apply game rules to determine the next state
		beq $v0 3 on					# if the cell has 3 active neighbors it lives
			bne $v0 2 off				# if the cell has 2 active neighbors it lives only if it is active
				lw $t0 0($s1)
				bnez $t0 on

		# apply next state to the respective next_state_matrix word
		off:
			sw $zero 0($s2)
			j after
		on:
			sw $s6 0($s2)

		after:
			addi $s1 $s1 4 				# updates current working address in display_matrix
			addi $s2 $s2 4 				# updates current working address in next_state_matrix
			addi $s0 $s0 1 				# updates word index
			j loop

end:
	# pop registers from stack
	lw $ra 0($sp) 						# return address
	lw $s7 4($sp) 						# static registers
	lw $s6 8($sp)
	lw $s2 12($sp)
	lw $s1 16($sp)
	lw $s0 20($sp) 						# static registers
	addi $sp $sp 24

	jr $ra 							# return
