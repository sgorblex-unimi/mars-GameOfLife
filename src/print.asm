	.data
	.align 2
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

# note: we ignore the tool's delay implementation
print:
	# spilling registers
	addi $sp $sp -4
	sw $ra 0($sp)

	# load MMIO addresses
	la $t0 out_val
	lw $t0 0($t0) 				# output value address in s0

	loop:
		lbu $t2 0($a0) 			# load character
		beqz $t2 end 			# if NULL the string is over
		sw $t2 0($t0)
		addi $a0 $a0 1
		j loop

	end:
		lw $ra 0($sp)
		addi $sp $sp 4
		jr $ra
		
