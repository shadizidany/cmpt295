# Copy an n-by-n character matrix A into B
# rdi=A | rsi=B | edx=n

    .globl copy

copy:
    testl %edx, %edx
    jle exit            # if n <= 0 return

    imulq %rdx, %rdx
    addq %rdi, %rdx     # rdx = A + n^2

loop:
    # B[i][j] = A[i][j]
    movb (%rdi), %al
    movb %al, (%rsi)

    # Advance pointers
    incq %rdi
    incq %rsi

    cmpq %rdx, %rdi
    jl loop             # if A < &A[n-1][n] continue

exit:
    ret


# Transpose an n-by-n character matrix A
# rdi=A | esi=n

    .globl transpose

transpose:
    leal -1(%esi), %eax     # eax = n-1

    xorl %edx, %edx          # i = 0

rowLoop:
    cmpl %eax, %edx
    jge end                 # if i >= n-1 return

    leaq 1(%rsi), %rcx      # tmp = n+1
    imulq %rdx, %rcx        # tmp *= i
    leaq 1(%rdi,%rcx), %r8  # r8 = &A[i][i+1]
    leaq (%r8,%rax), %r9    # r9 = &A[i+1][i]

    leal 1(%edx), %ecx      # j = i+1

colLoop:
    # Swap A[i][j] with A[j][i]
    movb (%r8), %r10b
    movb (%r9), %r11b
    movb %r10b, (%r9)
    movb %r11b, (%r8)

    incq %r8                # r8 = &A[i][j+1]
    addq %rsi, %r9          # r9 = &A[j+1][i]

    incl %ecx               # j++
    cmpl %esi, %ecx
    jl colLoop              # if j < n continue

    incl %edx               # i++
    jmp rowLoop             # else break

end:
	ret


# Reverse the columns of an n-by-n character matrix A
# rdi=A | esi=n

    .globl reverseColumns

reverseColumns:
    movl %esi, %eax             # eax = n
    sarl $1, %eax               # eax /= 2

    xorl %ecx, %ecx              # j = 0

col_loop:
    cmpl %eax, %ecx
    jge done                    # if j >= n/2 return

    leaq (%rdi,%rcx), %r8       # r8 = &A[0][j]
    leaq -1(%rdi,%rsi), %r9
    subq %rcx, %r9              # r9 = &A[0][n-j-1]

    xorl %edx, %edx             # i = 0

row_loop:
    # Swap A[i][j] with A[i][n-j-1]
    movb (%r8), %r10b
    movb (%r9), %r11b
    movb %r10b, (%r9)
    movb %r11b, (%r8)

    addq %rsi, %r8              # r8 = &A[i+1][j]
    addq %rsi, %r9              # r9 = &A[i+1][n-j-1]

    incl %edx                   # i++
    cmpl %esi, %edx
    jl row_loop                 # if i < n continue

    incl %ecx                   # j++
    jmp col_loop                # else break

done:
	ret
