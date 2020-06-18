	.text

	.globl random
# random() fills the display_matrix with randomly chosen active pixels
#
# note: there's no need to set a random seed since java does it itself. Also, the generator id is not set since not knowing it highens the randomness.
random:
	la $t0 display_matrix 			# current address in t0
	addi $t1 $t0 16384 			# ending address in t1
	la $t2 active_color
	lw $t2 0($t2) 				# active color in t2

	loop:
		beq $t0 $t1 end
		li $a1 2
		li $v0 42
		syscall 			# pick a random binary value

		beqz $a0 off
		# on:
			sw $t2 0($t0)
			j after
		off:
			sw $zero 0($t0)
	after:
		addi $t0 $t0 4
		j loop

end:
	jr $ra
