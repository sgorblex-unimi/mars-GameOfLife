	.data

	.globl in_flag
in_flag:
	.word 0xffff0000

	.globl in_val
in_val: 
	.word 0xffff0004

	.globl out_val
out_val:
	.word 0xffff000c


	.text

	.globl print
# print(a0) prints to the MMIO Display+Keyboard Simulator the string beginning at the address a0 and ending with \0
#
# note: for simplicity we ignore the tool's delay implementation
print:
	# spill registers (push)
	addi $sp $sp -4
	sw $ra 0($sp) 				# return address

	# load MMIO addresses
	la $t0 out_val
	lw $t0 0($t0) 				# output value address in t0

	loop:
		lbu $t2 0($a0) 			# load character
		beqz $t2 end 			# if NULL the string is over
		sw $t2 0($t0) 			# output character
		addi $a0 $a0 1 			# advance string index
		j loop

end:
	# pop registers from stack
	lw $ra 0($sp) 			# return address
	addi $sp $sp 4

	jr $ra
