	.text
	
# WIP note: the game is not meant to iterate forever, changes will be made (check for inputs at every iteration)
# WIP note: sleep time will be made modifiable by the player
	.globl game
# game() executes the game
game:
	# spilling return address before looping
	addi $sp $sp -4
	sw $ra 0($sp)

	game_iterate:
		jal next_state 		# next_state_matrix gets updated using game rules

		# copy next_state_matrix into the dislay matrix
		la $a0 next_state_matrix
		addi $sp $sp -4
		sw $ra 0($sp) 		# push return address to stack
		jal copy_matrix 	# call copy_matrix(next_state_matrix)
		lw $ra 0($sp)
		addi $sp $sp 4  	# pop return address from stack

		# idle until next update 
		# li $v0 32
		# li $a0 0
		# syscall 		# sleep

		j game_iterate 			# reiterate
end:
	# popping return address
	lw $ra 0($sp)
	addi $sp $sp 4
