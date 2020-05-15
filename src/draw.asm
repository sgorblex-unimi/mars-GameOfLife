	.data
msg: 	.byte 12 				# clear first
	.asciiz "Here you can draw your template.\nUse WASD to move and <enter> to activate/deactivate the pixel.\nPress c when you are ready."
	.text

# WIP note: temporary register to store 64?
# WIP note: remove redundancy
	.globl draw
# draw() launches the interactive menu where the player creates their template by selecting the pixel to invert and pressing enter.
draw:
	# spilling registers
	addi $sp $sp -4
	sw $ra 0($sp) 				# return address

	la $a0 msg
	jal print 				# printing message

	# quickly access to colors and constants
	li $t7 0x00ff00 			# cursor on
	li $t6 0xff0000 			# cursor off
	li $t5 64

	# load MMIO address
	la $t9 in_flag
	lw $t9 0($t9) 				# input flag address in t7
	la $t8 in_val
	lw $t8 0($t8) 				# input value address in t6

	# setting up initial position
	li $t0 2048 				# monodimensional position in t0
	la $t1 display_matrix
	addi $t1 $t1 8192 			# corresponding address in t1
	lw $t2 0($t1) 				# current color in t2

	# if the pixel is active, display green cursor, else display red cursor
	beqz $t2 init_off
# init_on:
	sw $t7 0($t1)
	j check
init_off:
	sw $t6 0($t1)

check:
	lw $t4 0($t9)
	beqz $t4 check 	  			# check for new input
	
	# proceed when there's an input
	lw $t3 0($t8)
	beq $t3 119 w 				# W
	beq $t3 97 a				# A
	beq $t3 115 s				# S
	beq $t3 100 d				# D
	beq $t3 99 c				# C
	beq $t3 10 enter			# <enter>
	j check



w:
	blt $t0 $t5 check 			# check if boundary pixel

	sw $t2 0($t1) 				# update former cursor color

	addi $t0 $t0 -64
	addi $t1 $t1 -256 			# update index and address
	j after



a:
	div $t0 $t5
	mfhi $t4
	beqz $t4 check 				# check if boundary pixel

	sw $t2 0($t1) 				# update former cursor color

	addi $t0 $t0 -1
	addi $t1 $t1 -4 			# update index and address
	j after



s:
	bge $t0 4032 check 			# check if boundary pixel

	sw $t2 0($t1) 				# update former cursor color

	add $t0 $t0 $t5
	addi $t1 $t1 256 			# update index and address
	j after



d:
	div $t0 $t5
	mfhi $t4
	beq $t4 63 check 			# check if boundary pixel

	sw $t2 0($t1) 				# update former cursor color

	addi $t0 $t0 1
	addi $t1 $t1 4 				# update index and address
	j after



after:
	lw $t2 0($t1) 				# new position color in t2

	# set new cursor color
	beqz $t2 off

	# case new on
	sw $t7 0($t1) 				# load active color in new cursor position
	j check

off: 	# case new off
	sw $t6 0($t1)
	j check



enter:
	beqz $t2 enter_off

	# case on
	move $t2 $zero
	sw $t6 0($t1)
	j check

enter_off:
	li $t2 0xffffff
	sw $t7 0($t1)
	j check



c:
	sw $t2 0($t1)

	# popping return address
	lw $ra 0($sp)
	addi $sp $sp 4

	jr $ra
