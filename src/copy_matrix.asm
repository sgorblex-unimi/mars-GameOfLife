	.text

	.globl copy_matrix
# copy_matrix(a0), copies the 64x64 word matrix starting at a0 in the bitmap matrix (global)
copy_matrix:
	move $t0 $zero 			# loop counter in t0
	la $t1 display_matrix		# loads display_matrix

	loop:
		beq $t0 4096 return # exits loop at the 4096th iteration (no more matrix elements)

		# copying matrix element
		lw $t2 0($a0) 			# loads copied matrix value
		sw $t2 0($t1) 			# stores display_matrix value
		
		# updating matrixes' indices
		addi $a0 $a0 4 			# copied matrix value
		addi $t1 $t1 4 			# display_matrix value

		# updating loop counter and reiterating
		addi $t0 $t0 1
		j loop

return:
	jr $ra
