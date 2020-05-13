	.text

# WIP note: color constants could be put in a static register in order not to load it at every iteration
	.globl next_state
# next_state() calculates the next state of the game based on the display matrix and puts it in the next_state_matrix
#
# note: since spilling return address at every iteration is expensive, it is done before and after the entire loop
# note: since multiplying the matrix index by the word size and adding the result to the base address is expensive and given that the procedure works sequentially, we prefer keeping a display matrix and a next_state_matrix current address, wich we update at every iteration. For the same reason there's also no need for nested loops.
next_state:

	# spilling s registers (push)
	addi $sp $sp 20
	sw $s0 16($sp) 			# s0
	sw $s1 12($sp) 			# s1
	sw $s2 8($sp) 			# s2
	sw $s3 4($sp) 			# s3
	sw $ra 0($sp) 			# return address (for future call)

	move $s0 $zero 			# initializes monodimensional current index in s0
	la $s1 display 			# display matrix base address in s1
	la $s2 next_state_matrix 	# next_state_matrix base address in s2

next_state_loop:
	beq $s0 4096 end

	# calling neighbor_counter
	move $a0 $s0
	jal neighbor_counter 		# neighbor_counter(matrix-monodimensional-index)

	# apply game rules to determine the next state
	beq $v0 3 on
	bne $v0 2 off
	lw $t0 0($s1)
	bne $t0 0x000000 on

	# apply next state to the respective display matrix word
off:
	li $t0 0x000000
	sw $t0 0($s2)
	j after
on:
	li $t0 0xffffff
	sw $t0 0($s2)
	
after:
	addi $s1 $s1 4 			# updates current working address in the display matrix
	addi $s2 $s2 4 			# updates current working address in the next_state_matrix
	addi $s0 $s0 1 			# updates counter
	j next_state_loop
end:
	# popping spilled registers
	lw $ra 0($sp) 			# return address
	lw $s3 4($sp) 			# s3
	lw $s2 8($sp) 			# s2
	lw $s1 12($sp) 			# s1
	lw $s0 16($sp) 			# s0
	addi $sp $sp -20

	jr $ra 				# return
