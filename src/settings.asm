	.data
	.align 2

	.globl active_color
active_color:
	.word 0xffffff
	.globl idle_time
idle_time:
	.word 1

settingstext:
	.byte 12 				# clear first
	.asciiz "Settings\n\n1. Change idle time (default: 1 ms)\t2. Change active pixels' color (default: white)\n3. Go back\n\nnote: idle time is added to the calculation time, which is perse a lot.\nnote: presets won't change color until the first display update."

timetext:
	.byte 12 				# clear first
	.asciiz "Choose the idle time in deciseconds (0 to 5)\n\n(0 will actually be 1 millisecond just in case)"


colortext:
	.byte 12 				# clear first
	.asciiz "Choose the active pixels' color:\n\n1. White\t2. Orange\n3. Purple\t4. Blue"


	.text

	.globl settings
# settings() launches the settings menu
settings:
	# spilling return address
	addi $sp $sp -4
	sw $ra 0($sp)

	la $a0 settingstext
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
		beqz $t1 wait			# check for new input

	# when input detected
	lw $t1 0($t6) 				# input value in t1
	beq $t1 49 time
	beq $t1 50 color
	beq $t1 51 exit
	j wait

	time:
		la $t3 idle_time 		# time global variable address in t3
		la $a0 timetext
		jal print
		
		time_wait:
			li $a0 200
			li $v0 32
			syscall 		# sleep to lower CPU usage

			lw $t1 0($t7)
			beqz $t1 time_wait	# check for new input

		# when input detected
		lw $t1 0($t6) 			# input value in t1
		beq $t1 48 time_zero
		beq $t1 49 time_one
		beq $t1 50 time_two
		beq $t1 51 time_three
		beq $t1 52 time_four
		beq $t1 53 time_five
		j time_wait

	time_zero:
		li $t0 1
		j after

	time_one:
		li $t0 100
		j after

	time_two:
		li $t0 200
		j after

	time_three:
		li $t0 300
		j after

	time_four:
		li $t0 400
		j after

	time_five:
		li $t0 500
		j after

	

	color:
		la $t3 active_color 		# time global variable address in t3
		la $a0 colortext
		jal print
		
		color_wait:
			li $a0 200
			li $v0 32
			syscall 		# sleep to lower CPU usage

			lw $t1 0($t7)
			beqz $t1 color_wait	# check for new input

		# when input detected
		lw $t1 0($t6) 			# input value in t1
		beq $t1 49 color_white
		beq $t1 50 color_orange
		beq $t1 51 color_purple
		beq $t1 52 color_blue
		j color_wait

	color_white:
		li $t0 0xffffff
		j after

	color_orange:
		li $t0 0xff5500
		j after

	color_purple:
		li $t0 0x8811ff
		j after

	color_blue:
		li $t0 0x0000ff




	after:
		sw $t0 0($t3) 			# saving value in the global variable
		la $a0 settingstext
		jal print
		j wait

	exit:
		# popping return address
		lw $ra 0($sp)
		addi $sp $sp 4

		jr $ra
