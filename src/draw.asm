	.data

draw_msg:
 	.byte 12 					# clear first
	.asciiz "Here you can draw your template.\nUse WASD to move and <enter> to activate/deactivate the pixel.\nPress c when you are ready."


	.text

	.globl draw
# draw() launches the interactive menu where the player create their template by selecting the pixel to invert and pressing enter
draw:
	# spill registers (push)
	addi $sp $sp -4
	sw $ra 0($sp) 					# return address

	la $a0 draw_msg
	jal print

	# quickly access to colors and constants
	li $t7 0x00ff00 				# cursor on
	li $t6 0xff0000 				# cursor off
	li $t5 64
	la $t3 active_color
 	lw $t3 0($t3) 					# active pixels' color in t3

	# load MMIO address
	la $t9 in_flag
	lw $t9 0($t9) 					# input flag address in t9
	la $t8 in_val
	lw $t8 0($t8) 					# input value address in t8

	# setting up initial position
	li $t0 2080 					# monodimensional position in t0 (starting in the middle)
	la $t1 display_matrix
	addi $t1 $t1 8320 				# corresponding address in t1
	lw $t2 0($t1) 					# current color in t2

	# if the pixel is active, display green cursor, else display red cursor
	beqz $t2 init_off
	# init_on:
		sw $t7 0($t1)
		j check
	init_off:
		sw $t6 0($t1)

	# wait for any input then proceed accordingly
	check:
		lw $t4 0($t9)
		beqz $t4 check 	  			# check for new input

		lw $t4 0($t8) 				# input value in t4
		beq $t4 'w' w
		beq $t4 'a' a
		beq $t4 's' s
		beq $t4 'd' d
		beq $t4 'c' c
		beq $t4 '\n' enter
		j check


		w:
			blt $t0 $t5 check 		# check if boundary pixel (up)

			sw $t2 0($t1) 			# update former cursor color

			sub $t0 $t0 $t5
			addi $t1 $t1 -256 		# update index and address
			j wasd_after


		a:
			div $t0 $t5
			mfhi $t4
			beqz $t4 check 			# check if boundary pixel (left)

			sw $t2 0($t1)

			addi $t0 $t0 -1
			addi $t1 $t1 -4
			j wasd_after


		s:
			bge $t0 4032 check 		# check if boundary pixel (down)

			sw $t2 0($t1)

			add $t0 $t0 $t5
			addi $t1 $t1 256
			j wasd_after


		d:
			div $t0 $t5
			mfhi $t4
			beq $t4 63 check 		# check if boundary pixel

			sw $t2 0($t1)

			addi $t0 $t0 1
			addi $t1 $t1 4
			j wasd_after


		wasd_after:
			lw $t2 0($t1) 			# new position's color in t2

			# set new cursor color
			beqz $t2 off
			# on:
				sw $t7 0($t1) 		# load active color in new cursor position
				j check

			off: 	# case new off
				sw $t6 0($t1) 		# load inactive color in new cursor position
				j check


		enter:
			beqz $t2 enter_off
			# enter_on:
				move $t2 $zero
				sw $t6 0($t1)
				j check
			enter_off:
				move $t2 $t3
				sw $t7 0($t1)
				j check


		c:
			sw $t2 0($t1) 			# reset color

			# pop registers from stack
			lw $ra 0($sp) 			# return address
			addi $sp $sp 4

			jr $ra
