# 	WIP

	.data
	.globl display_matrix
display_matrix:
	.space 16384
	.align 2
	.globl next_state_matrix
next_state_matrix:
	.space 16384


	.text
	
	.globl main
main:
	li $v0 1
	li $a0 0
	syscall

	la $a0 glidergun
	jal copy_matrix

	li $v0 32
	li $a0 2000
	syscall

	jal game

	li $v0 10
	syscall
