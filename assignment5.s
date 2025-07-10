# edi=x | esi=y

	.globl	mul # Performs non-negative integer multiplication without using imul*

# x*y = x + x*(y-1)
mul:
	xorl	%eax, %eax		# eax = 0
	testl	%esi, %esi
	jle		endif			# if y <= 0 goto endif
	decl	%esi			# y--
	call	mul				# mul(x,y-1)
	addl	%edi, %eax		# eax += x
endif:
	ret
