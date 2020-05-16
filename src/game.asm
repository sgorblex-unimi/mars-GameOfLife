	.data
gamemsg:
	.byte 12 				# clear first
	.asciiz "The game is going! Press any character key or enter to go back to the menu"
	.text
	
	.globl game
# game() executes the game
game:
	# spilling registers (push)
	addi $sp $sp -8
	sw $ra 4($sp) 			# return address
	sw $s0 0($sp) 			# s0

	# print
	la $a0 gamemsg
	jal print

	# load MMIO address
	la $s0 in_flag
	lw $s0 0($s0) 			# input flag address in s0

	game_iterate:
		jal next_state 		# next_state_matrix gets updated using game rules

		# copy next_state_matrix into the dislay matrix
		la $a0 next_state_matrix
		jal copy_matrix 	# call copy_matrix(next_state_matrix)

		# idle until next update 
		li $v0 32
		la $t1 idle_time
		lw $a0 0($t1) 		# fetch global idle time
		syscall 		# sleep

		# check for new input
		lw $t0 0($s0)
		beqz $t0 game_iterate		# check for new input
end:
	# popping registers
	lw $s0 0($sp) 			# s0
	lw $ra 4($sp) 			# return address
	addi $sp $sp 8
