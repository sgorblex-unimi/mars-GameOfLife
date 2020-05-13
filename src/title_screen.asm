	.data
hello: 	.asciiz "Welcome! This is the primary input/output source for the game.\nPress any character or enter to continue."

	.text

	.globl title_screen
# title_screen() executes the titlescreen, wich displays the game title with a little animation (sort of a GIF)

# note: pop of ra is done at the end of the loop to improve efficiency
title_screen:
	# spilling registers (push)
	addi $sp $sp -8
	sw $ra 4($sp) 		# return address
	sw $s0 0($sp)

	# load MMIO address
	la $s0 in_flag
	lw $s0 0($s0) 		# input flag address in s0
	
	# print message
	la $a0 hello
	jal print

	loop:
		# print titlea picture
		la $a0 titlea 		# load copy_matrix() argument
		jal copy_matrix 	# call copy_matrix procedure

		lw $t0 0($s0)
		bnez $t0 end		# check for new input

		li $v0 32
		li $a0 500
		syscall 		# sleep half a second

		# print titleb picture
		la $a0 titleb 		# load copy_matrix() argument
		jal copy_matrix 	# call copy_matrix procedure

		lw $t0 0($s0)
		bnez $t0 end		# check for new input

		li $v0 32
		li $a0 500
		syscall 		# sleep half a second

		# print titlec picture
		la $a0 titlec 		# load copy_matrix() argument
		jal copy_matrix 	# call copy_matrix procedure

		lw $t0 0($s0)
		bnez $t0 end		# check for new input

		li $v0 32
		li $a0 500
		syscall 		# sleep half a second

		# print titled picture
		la $a0 titled 		# load copy_matrix() argument
		jal copy_matrix 	# call copy_matrix procedure

		lw $t0 0($s0)
		bnez $t0 end		# check for new input

		li $v0 32
		li $a0 500
		syscall 		# sleep half a second

		# repeat
		j loop

end:
	lw $s0 0($sp)
	lw $ra 4($sp)
	addi $sp $sp 8 	# pop return address from stack
	jr $ra
