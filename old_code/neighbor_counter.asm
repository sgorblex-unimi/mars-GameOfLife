	.text

	.globl neighbor_counter
# neighbor_counter(a0) calculates the number of active neighbors of the a0th element in the 64x64 display matrix and returns the number in $v0
# to calculate &matr[i][j] we use the formula: base_addr + ( j + i * rowsize ) * datasize
# to calculate i and j with pacman effect, we use truei=(i+64)%64, where i is i+delta, wich may be negative or over the row's last element. Same goes for columns.
# row and column delta vary from -1 to 1 and skip 0,0, wich is the element a0 itself. This is done to iterate among a0's neighbors.
neighbor_counter:
	li $v0 0 					# initialize counter
	la $t2 display 					# monodimensional position in t2
	div $t3 $a0 64
	# mflo $t3 					# a0's row in t3 (quotient) - done in div
	mfhi $t4 					# a0's col in t4 (remainder)

	li $t0 -1 					# row delta in t0
ext_loop:
	beq $t0 2 end
	li $t1 -1 					# col delta in t1
	
	int_loop:
		beq $t1 2 ext_after

		# skip if deltas are both 0
		bnez $t0 go_on
		beqz $t1 int_after
	go_on:
		# t2 + ( ( ( t4 + t1 + 64 ) % 64 ) + ( ( t3 + t0 + 64 ) % 64 ) * 64) * 4
		# that is
		# base_addr + ( ( ( a0_col + col_delta + #col ) % #col ) + ( ( a0_col + row_delta + #row ) % #row ) * #col ) * datasize
		add $t5 $t4 $t1 			# t5 = t4 + t1
		add $t6 $t3 $t0 			# t6 = t3 + t0
		addi $t5 $t5 64 			# t5 += 64
		addi $t6 $t6 64 			# t6 += 64
		div $t5 $t5 64
		mfhi $t5 				# t5 %= 64
		# div $t6 64
		div $t6 $t6 64				# using pseudo only to use immiediate
		mfhi $t6 				# t6 %= 64 
		mul $t6 $t6 64 				# t6 *= 64
		add $t5 $t5 $t6 			# t5 += t6
		mul $t5 $t5 4 				# t5 *= 4
		add $t5 $t2 $t5 			# t5 += t2

		lw $t6 0($t5) 				# load matrix element
		# beq $t6 0x000000 int_after 		# DEPRECATED
		beqz $t6 int_after 		# if pixel is inactive skip
		addi $v0 $v0 1 				# update counter

	int_after:
		addi $t1 $t1 1
		j int_loop
ext_after:
	addi $t0 $t0 1
	j ext_loop
end:
	jr $ra
