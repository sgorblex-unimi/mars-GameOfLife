	.data
menutext:
	.byte 12 				# clear first
	.asciiz "MENU\nSelect what to do:\n\n1: Draw template\t2: Load preset\n3: Random pattern\t4: Play the game!\n5: Settings\t\t6: Exit"

	.text

	.globl menu
# menu() launches the main menu on the MMIO Keyboard+Display simulator, where the player can choose to modify their settings, draw or load a template or start the game (or exit)
menu:
	# spilling return address
	addi $sp $sp -4
	sw $ra 0($sp)

menu_print:
	la $a0 menutext
	jal print

	# load MMIO address
	la $t7 in_flag
	lw $t7 0($t7) 				# input flag address in t7
	la $t6 in_val
	lw $t6 0($t6) 				# input value address in t6

	wait:
		li $a0 100
		li $v0 32
		syscall 			# sleep to lower CPU usage
		lw $t1 0($t7)
		beqz $t1 wait 	  		# check for new input

		lw $t1 0($t6) 			# input value in t1
		beq $t1 49 launch_draw 		# if input = 1
		beq $t1 50 launch_preset 	# if input = 2
		beq $t1 51 launch_random 	# if input = 3
		beq $t1 52 launch_game   	# if input = 4
		beq $t1 53 launch_settings 	# if input = 5
		beq $t1 54 exit          	# if input = 6
		j wait


	launch_draw:
		jal draw
		j menu_print

	launch_preset:
		jal preset
		j menu_print

	launch_game:
		jal game
		j menu_print

	launch_random:
		jal random
		j menu_print

	launch_settings:
		jal settings
		j menu_print

	exit:
		# popping return address
		lw $ra 0($sp)
		addi $sp $sp 4

		jr $ra
