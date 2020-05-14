	.data
msg: 	.asciiz "Test message"
	.text

	.globl draw
# draw() launches the interactive menu where the player creates their template by selecting the pixel to invert and pressing enter.
draw:
	li $v0 4
	la $a0 msg
	syscall

	jr $ra
