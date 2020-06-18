	.text

	.globl neighbor_counter
# neighbor_counter(a0, a1) calculates the number of active neighbors of the a0th element in the 64x64 display_matrix, which is found at the address a1, and returns the number in $v0. The choice of using two arguments despite the fact that one of them can be calculated from the other is due to efficiency.
#
# note: instead of using the canonical formula to calculate &matr[i][j], that is: [base_addr + ( j + i * rowsize ) * datasize] we choose to use a multiple cases linear/sequential approach which saves many instruction executions (at the cost of more lines of code). A previous, inefficient version of this procedure, which uses instead far more complicated nested loops, can be found in the old_code repo directory.
neighbor_counter:
	move $v0 $zero 					# initialize return variable

	# branch to special cases (boundaries), keep center for last to save a jump (most common case, Amdahl's law)
	li $t7 64
	blt $a0 $t7 top
	li $t5 4032
	bge $a0 $t5 bottom
	div $a0 $t7
	mfhi $t0
	beqz $t0 left
	li $t6 63
	bne $t0 $t6 center

	# right:
	# corner cases have been excluded by the top/bottom branches
	# r_1:
		lw $t2 -260($a1)
		beqz $t2 r_2
		addi $v0 $v0 1
	r_2:
		lw $t2 -256($a1)
		beqz $t2 r_3
		addi $v0 $v0 1
	r_3:
		lw $t2 -508($a1)
		beqz $t2 r_4
		addi $v0 $v0 1
	r_4:
		lw $t2 -4($a1)
		beqz $t2 r_5
		addi $v0 $v0 1
	r_5:
		lw $t2 -252($a1)
		beqz $t2 r_6
		addi $v0 $v0 1
	r_6:
		lw $t2 252($a1)
		beqz $t2 r_7
		addi $v0 $v0 1
	r_7:
		lw $t2 256($a1)
		beqz $t2 r_8
		addi $v0 $v0 1
	r_8:
		lw $t2 4($a1)
		beqz $t2 end
		addi $v0 $v0 1
		jr $ra

	left:
	# corner cases have been excluded by the top/bottom branches
	# l_1:
		lw $t2 -4($a1)
		beqz $t2 l_2
		addi $v0 $v0 1
	l_2:
		lw $t2 -256($a1)
		beqz $t2 l_3
		addi $v0 $v0 1
	l_3:
		lw $t2 -252($a1)
		beqz $t2 l_4
		addi $v0 $v0 1
	l_4:
		lw $t2 252($a1)
		beqz $t2 l_5
		addi $v0 $v0 1
	l_5:
		lw $t2 4($a1)
		beqz $t2 l_6
		addi $v0 $v0 1
	l_6:
		lw $t2 508($a1)
		beqz $t2 l_7
		addi $v0 $v0 1
	l_7:
		lw $t2 256($a1)
		beqz $t2 l_8
		addi $v0 $v0 1
	l_8:
		lw $t2 260($a1)
		beqz $t2 end
		addi $v0 $v0 1
		jr $ra

	top:
	# branch to special top cases (top left and right corners)
	beqz $a0 top_left
	beq $a0 $t6 top_right
	# t_1:
		lw $t2 16124($a1)
		beqz $t2 t_2
		addi $v0 $v0 1
	t_2:
		lw $t2 16128($a1)
		beqz $t2 t_3
		addi $v0 $v0 1
	t_3:
		lw $t2 16132($a1)
		beqz $t2 t_4
		addi $v0 $v0 1
	t_4:
		lw $t2 -4($a1)
		beqz $t2 t_5
		addi $v0 $v0 1
	t_5:
		lw $t2 4($a1)
		beqz $t2 t_6
		addi $v0 $v0 1
	t_6:
		lw $t2 252($a1)
		beqz $t2 t_7
		addi $v0 $v0 1
	t_7:
		lw $t2 256($a1)
		beqz $t2 t_8
		addi $v0 $v0 1
	t_8:
		lw $t2 260($a1)
		beqz $t2 end
		addi $v0 $v0 1
		jr $ra

	top_left:
	# tl_1:
		lw $t2 16380($a1)
		beqz $t2 tl_2
		addi $v0 $v0 1
	tl_2:
		lw $t2 16128($a1)
		beqz $t2 tl_3
		addi $v0 $v0 1
	tl_3:
		lw $t2 16132($a1)
		beqz $t2 tl_4
		addi $v0 $v0 1
	tl_4:
		lw $t2 252($a1)
		beqz $t2 tl_5
		addi $v0 $v0 1
	tl_5:
		lw $t2 4($a1)
		beqz $t2 tl_6
		addi $v0 $v0 1
	tl_6:
		lw $t2 508($a1)
		beqz $t2 tl_7
		addi $v0 $v0 1
	tl_7:
		lw $t2 256($a1)
		beqz $t2 tl_8
		addi $v0 $v0 1
	tl_8:
		lw $t2 260($a1)
		beqz $t2 end
		addi $v0 $v0 1
		jr $ra

	top_right:
	# tr_1:
		lw $t2 16124($a1)
		beqz $t2 tr_2
		addi $v0 $v0 1
	tr_2:
		lw $t2 16128($a1)
		beqz $t2 tr_3
		addi $v0 $v0 1
	tr_3:
		lw $t2 15876($a1)
		beqz $t2 tr_4
		addi $v0 $v0 1
	tr_4:
		lw $t2 -4($a1)
		beqz $t2 tr_5
		addi $v0 $v0 1
	tr_5:
		lw $t2 -252($a1)
		beqz $t2 tr_6
		addi $v0 $v0 1
	tr_6:
		lw $t2 252($a1)
		beqz $t2 tr_7
		addi $v0 $v0 1
	tr_7:
		lw $t2 256($a1)
		beqz $t2 tr_8
		addi $v0 $v0 1
	tr_8:
		lw $t2 4($a1)
		beqz $t2 end
		addi $v0 $v0 1
		jr $ra

	bottom:
	# branch to special bottom cases (bottom left and right corners)
	beq $a0 $t5 bottom_left
	beq $a0 4095 bottom_right
	# b_1:
		lw $t2 -260($a1)
		beqz $t2 b_2
		addi $v0 $v0 1
	b_2:
		lw $t2 -256($a1)
		beqz $t2 b_3
		addi $v0 $v0 1
	b_3:
		lw $t2 -252($a1)
		beqz $t2 b_4
		addi $v0 $v0 1
	b_4:
		lw $t2 -4($a1)
		beqz $t2 b_5
		addi $v0 $v0 1
	b_5:
		lw $t2 4($a1)
		beqz $t2 b_6
		addi $v0 $v0 1
	b_6:
		lw $t2 -16132($a1)
		beqz $t2 b_7
		addi $v0 $v0 1
	b_7:
		lw $t2 -16128($a1)
		beqz $t2 b_8
		addi $v0 $v0 1
	b_8:
		lw $t2 -16124($a1)
		beqz $t2 end
		addi $v0 $v0 1
		jr $ra

	bottom_left:
	# bl_1:
		lw $t2 -4($a1)
		beqz $t2 bl_2
		addi $v0 $v0 1
	bl_2:
		lw $t2 -256($a1)
		beqz $t2 bl_3
		addi $v0 $v0 1
	bl_3:
		lw $t2 -252($a1)
		beqz $t2 bl_4
		addi $v0 $v0 1
	bl_4:
		lw $t2 252($a1)
		beqz $t2 bl_5
		addi $v0 $v0 1
	bl_5:
		lw $t2 4($a1)
		beqz $t2 bl_6
		addi $v0 $v0 1
	bl_6:
		lw $t2 -15876($a1)
		beqz $t2 bl_7
		addi $v0 $v0 1
	bl_7:
		lw $t2 -16128($a1)
		beqz $t2 bl_8
		addi $v0 $v0 1
	bl_8:
		lw $t2 -16124($a1)
		beqz $t2 end
		addi $v0 $v0 1
		jr $ra

	bottom_right:
	# br_1:
		lw $t2 -260($a1)
		beqz $t2 br_2
		addi $v0 $v0 1
	br_2:
		lw $t2 -256($a1)
		beqz $t2 br_3
		addi $v0 $v0 1
	br_3:
		lw $t2 -508($a1)
		beqz $t2 br_4
		addi $v0 $v0 1
	br_4:
		lw $t2 -4($a1)
		beqz $t2 br_5
		addi $v0 $v0 1
	br_5:
		lw $t2 -252($a1)
		beqz $t2 br_6
		addi $v0 $v0 1
	br_6:
		lw $t2 -16132($a1)
		beqz $t2 br_7
		addi $v0 $v0 1
	br_7:
		lw $t2 -16128($a1)
		beqz $t2 br_8
		addi $v0 $v0 1
	br_8:
		lw $t2 -16380($a1)
		beqz $t2 end
		addi $v0 $v0 1
		jr $ra

	center:
	# c_1:
		lw $t2 -260($a1)
		beqz $t2 c_2
		addi $v0 $v0 1
	c_2:
		lw $t2 -256($a1)
		beqz $t2 c_3
		addi $v0 $v0 1
	c_3:
		lw $t2 -252($a1)
		beqz $t2 c_4
		addi $v0 $v0 1
	c_4:
		lw $t2 -4($a1)
		beqz $t2 c_5
		addi $v0 $v0 1
	c_5:
		lw $t2 4($a1)
		beqz $t2 c_6
		addi $v0 $v0 1
	c_6:
		lw $t2 252($a1)
		beqz $t2 c_7
		addi $v0 $v0 1
	c_7:
		lw $t2 256($a1)
		beqz $t2 c_8
		addi $v0 $v0 1
	c_8:
		lw $t2 260($a1)
		beqz $t2 end
		addi $v0 $v0 1
end:
	jr $ra
