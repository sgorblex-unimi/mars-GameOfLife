	.data
presettext:
	.byte 12 				# clear first
	.asciiz "Choose the preset to load:\n\n1: Gosper's glidergun\n2: Go back"

	.text

	.globl preset
# preset () launches the menu which makes the player choose the preset to load in the display matrix
preset:
	# spilling return address
	addi $sp $sp -4
	sw $ra 0($sp)

	la $a0 presettext
	jal print

	# load MMIO address
	la $t7 in_flag
	lw $t7 0($t7) 		# input flag address in t7
	la $t6 in_val
	lw $t6 0($t6) 		# input value address in t6

	wait:
		lw $t1 0($t7)
		beqz $t1 wait		# check for new input

		lw $t1 0($t6) 		# input value in t1
		beq $t1 49 load_glidergun
		beq $t1 50 exit
		j wait

	load_glidergun:
		la $a0 glidergun
		jal copy_matrix
		j exit

	exit:
		# popping return address
		lw $ra 0($sp)
		addi $sp $sp 4

		jr $ra
