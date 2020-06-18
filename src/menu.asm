	.data

menu_msg:
	.byte 12 					# clear first
	.asciiz "MENU\nSelect what to do:\n\n1: Draw template\t2: Load preset\n3: Random pattern\t4: Play the game!\n5: Settings\t\t6: Exit"

exit_msg:
	.byte 12 					# clear first
	.asciiz "Exiting..."


	.text

	.globl menu
# menu() launches the main menu on the MMIO Keyboard+Display simulator, where the player can choose to modify their settings, draw or load a template or start the game (or exit)
menu:
	# spill registers (push)
	addi $sp $sp -4
	sw $ra 0($sp) 					# return address

	# loop over the menu until exit option is selected
	loop:
		la $a0 menu_msg
		jal print

		# load MMIO addresses
		la $t7 in_flag
		lw $t7 0($t7) 				# input flag address in t7
		la $t6 in_val
		lw $t6 0($t6) 				# input value address in t6

		# wait for any input then proceed accordingly
		wait:
			li $a0 100
			li $v0 32
			syscall 			# sleep to lower CPU usage
			lw $t1 0($t7)
			beqz $t1 wait 	  		# check for new input

			lw $t1 0($t6) 			# input value in t1
			beq $t1 '1' launch_draw
			beq $t1 '2' launch_preset
			beq $t1 '3' launch_random
			beq $t1 '4' launch_game
			beq $t1 '5' launch_settings
			beq $t1 '6' exit
			j wait

		# launch the right feature
		launch_draw:
			jal draw
			j loop

		launch_preset:
			jal preset
			j loop

		launch_game:
			jal game
			j loop

		launch_random:
			jal random
			j loop

		launch_settings:
			jal settings
			j loop

		exit:
			la $a0 exit_msg
			jal print

			# pop registers from stack
			lw $ra 0($sp) 			# return address
			addi $sp $sp 4

			# return
			jr $ra
