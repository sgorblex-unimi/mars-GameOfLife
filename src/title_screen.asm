	.text

# WIP note: pop of ra is done at the end of the loop to improve efficiency, however it must be changed if the loop gets modified in certain ways
# WIP note: titlescreen is not meant to iterate forever, changes will be made
	.globl titlescreen
# titlescreen() executes the titlescreen, wich displays the game title with a little animation (sort of a GIF)
titlescreen:
	addi $sp $sp 4
	sw $ra 0($sp) 		# push return address to stack

	loop:
		# print titlea picture
		la $a0 titlea 		# load copy_matrix() argument
		jal copy_matrix 	# call copy_matrix procedure
		li $v0 32
		li $a0 500
		syscall 		# sleep half a second

		# print titleb picture
		la $a0 titleb 		# load copy_matrix() argument
		jal copy_matrix 	# call copy_matrix procedure
		li $v0 32
		li $a0 500
		syscall 		# sleep half a second

		# print titlec picture
		la $a0 titlec 		# load copy_matrix() argument
		jal copy_matrix 	# call copy_matrix procedure
		li $v0 32
		li $a0 500
		syscall 		# sleep half a second

		# print titled picture
		la $a0 titled 		# load copy_matrix() argument
		jal copy_matrix 	# call copy_matrix procedure
		li $v0 32
		li $a0 500
		syscall 		# sleep half a second

		# repeat
		j loop

end:
	lw $ra 0($sp)
	addi $sp $sp -4 	# pop return address from stack
