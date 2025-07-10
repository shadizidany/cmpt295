# This file contains assembly implementations of basic arithmetic operations
# edi=x | esi=y

	.globl	is_less_than # Compares 2 integers x,y and returns 1 if x < y, 0 otherwise
	.globl	plus		 # Performs integer addition without using add*
	.globl	minus		 # Performs integer subtraction without using sub*
	.globl	mul			 # Performs non-negative integer multiplication without using imul*

is_less_than:
	xorl	%eax, %eax	# eax = 0
	cmpl	%esi, %edi
	setl	%al         # set least significant byte of eax (al) to 1 if x < y
	ret

plus:
	leal    (%edi,%esi), %eax	# eax = x+y
	ret

minus:
	negl	%esi				# y = -y
	leal    (%edi,%esi), %eax	# eax = x + (-y) = x-y
	ret

# x*y = x+...+x (y times)
mul:
	xorl	%eax, %eax	# eax = 0
	jmp		cond
loop:
	addl	%edi, %eax	# eax += x
	decl	%esi		# y--
cond:
	testl	%esi, %esi
	jg		loop		# if y > 0 goto loop
	ret
