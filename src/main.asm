	.data

	.globl display_matrix
display_matrix:
	.space 16384

	.globl next_state_matrix
next_state_matrix:
	.space 16384

welcome_msg:
	.asciiz "Welcome to Game of Life!\nthis is a MIPS assembly implementation of the popular cellular automation by Conway, specifically thought for the emulator MARS.\n\nTo play the game:\n- close this window\n- open the MARS tool Bitmap Display, in the tools menu\n- set the bitmap display to the settings displayed on the terminal\n- open the MARS tool Keyboard and Display MMIO Simulator, wich you'll use for input and output from now on, side by side with the bitmap display.\n- Press Connect to MIPS on both tools\n- have fun!\n"

setup_msg:
	.asciiz "Bitmap Display settings:\n- Unit Width in Pixels: 8\n- Unit Height in Pixels: 8\n- Display Width in Pixels: 512\n- Display Height in Pixels: 512\n- Base Address for Display: 0x10010000 (static data)\n\nMMIO Keyboard and Display Simulator settings: [defaults]\n\nPress a character key or enter in the MMIO Simulator when you're ready"


	.text
	
	.globl main
main:
	# print setup message on the console
	li $v0 4
	la $a0 setup_msg
	syscall

	# print welcome message in a dialog box
	li $v0 55
	li $a1 1
	la $a0 welcome_msg
	syscall

	# load title screen
	jal title_screen

	# when the player presses a key, the title screen leaves space to the main menu
	la $a0 next_state_matrix
	jal copy_matrix 			# clearing the screen first
	jal menu
	
	# exit when done
	li $v0 10
	syscall
