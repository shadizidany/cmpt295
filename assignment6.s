    .globl    copy             # Copy an N-by-N character matrix A into C
# ***** Version 2 *****
copy:
# A in %rdi, C in %rsi, N in %edx

# Using A and C as pointers

# This function is not a "caller", i.e., it does not call functions. 
# It is a leaf function (a callee). 
# Hence it does not have the responsibility of saving "caller-saved" registers 
# such as %rax, %rdi, %rsi, %rdx, %rcx, and %r8 to %r11.
# This signifies that it can use these registers without 
# first saving their content if it needs to use registers.

# Set up registers
    xorl %eax, %eax            # set %eax to 0
    xorl %ecx, %ecx            # i = 0 (row index i is in %ecx)

# For each row
rowLoop:
    xorl %r8d, %r8d            # j = 0 (column index j in %r8d)
    cmpl %edx, %ecx            # while i < N (i - N < 0)
    jge doneWithRows

# For each cell of this row
colLoop:
    cmpl %edx, %r8d            # while j < N (j - N < 0)
    jge doneWithCells

# Copy the element A points to (%rdi) to the cell C points to (%rsi)
    movb (%rdi), %r9b          # temp = element A points to
    movb %r9b, (%rsi)          # cell C points to = temp

# Update A and C so they now point to their next element 
    incq %rdi
    incq %rsi

    incl %r8d                  # j++ (column index in %r8d)
    jmp colLoop                # go to next cell

# Go to next row
doneWithCells:
    incl %ecx                  # i++ (row index in %ecx)
    jmp rowLoop                # go to next row

doneWithRows:                  # bye! bye!
    ret


#####################
	.globl	transpose       # Transpose an n-by-n character matrix A
# rdi=A | esi=n

transpose:
    leal -1(%esi), %eax     # eax = n-1

    movl $-1, %edx          # i = -1

row_loop:
    incl %edx               # i++
    cmpl %eax, %edx
    jge end                 # if i >= n-1 return

    leaq 1(%rsi), %rcx      # tmp = n+1
    imulq %rdx, %rcx        # tmp *= i
    leaq (%rdi,%rcx), %r8
    movq %r8, %r9           # r8 = r9 = &A[i][i]

    movl %edx, %ecx         # j = i

col_loop:
    incl %ecx               # j++
    cmpl %esi, %ecx
    jge row_loop            # if j >= n goto row_loop

    incq %r8                # r8 = &A[i][j]
    addq %rsi, %r9          # r9 = &A[j][i]

    # Swap A[i][j] with A[j][i]
    movb (%r8), %r10b
    movb (%r9), %r11b
    movb %r10b, (%r9)
    movb %r11b, (%r8)

    jmp col_loop

end:
	ret


##########################
	.globl	reverseColumns      # Reverse the columns of an n-by-n character matrix A
# rdi=A | esi=n

reverseColumns:
    movl %esi, %eax             # eax = n
    shrl $1, %eax               # eax /= 2

    movl $-1, %ecx              # j = -1

loop_cols:
    incl %ecx                   # j++
    cmpl %eax, %ecx
    jge done                    # if j >= n/2 return

    leaq (%rdi,%rcx), %r8       # r8 = &A[0][j]
    leaq -1(%rdi,%rsi), %r9
    subq %rcx, %r9              # r9 = &A[0][n-j-1]

    xorl %edx, %edx             # i = 0

loop_rows:
    cmpl %esi, %edx
    jge loop_cols               # if i >= n goto loop_cols

    # Swap A[i][j] with A[i][n-j-1]
    movb (%r8), %r10b
    movb (%r9), %r11b
    movb %r10b, (%r9)
    movb %r11b, (%r8)

    addq %rsi, %r8              # r8 = &A[i+1][j]
    addq %rsi, %r9              # r9 = &A[i+1][n-j-1]

    incl %edx                   # i++
    jmp loop_rows

done:
	ret
