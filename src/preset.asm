	.data

preset_msg:
	.byte 12 					# clear first
	.asciiz "Choose the preset to load:\n\n1: Gosper's glidergun\t2: Spaceships\n3: Oscillators\t\t4: R-pentomino\n5: Go back\n\n(more info on these patterns in the readme)"


	.text

	.globl preset
# preset () launches the menu which makes the player choose the preset to load in the display matrix
preset:
	# spill registers (push)
	addi $sp $sp -4
	sw $ra 0($sp) 					# return address

	la $a0 preset_msg
	jal print

	# load MMIO address
	la $t7 in_flag
	lw $t7 0($t7) 					# input flag address in t7
	la $t6 in_val
	lw $t6 0($t6) 					# input value address in t6

	# wait for any input then proceed accordingly
	loop:
		li $a0 100
		li $v0 32
		syscall 				# sleep to lower CPU usage

		lw $t1 0($t7)
		beqz $t1 loop				# check for new input

		# when input detected
		lw $t1 0($t6) 				# input value in t1
		beq $t1 '1' load_glidergun
		beq $t1 '2' load_spaceships
		beq $t1 '3' load_oscillators
		beq $t1 '4' load_rpentomino
		beq $t1 '5' exit
		j loop

		load_glidergun:
			la $a0 glidergun
			jal copy_matrix
			j exit

		load_spaceships:
			la $a0 spaceships
			jal copy_matrix
			j exit

		load_oscillators:
			la $a0 oscillators
			jal copy_matrix
			j exit

		load_rpentomino:
			la $a0 rpentomino
			jal copy_matrix
			j exit

		exit:
			# pop registers from stack
			lw $ra 0($sp) 			# return address
			addi $sp $sp 4

			jr $ra
