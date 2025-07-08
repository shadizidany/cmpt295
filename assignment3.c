long decode2(long x, long y, long z) {
    //       %rdi=x, %rsi=y, %rdx=z
    y -= z; //  subq %rdx, %rsi
    x *= y; // imulq %rsi, %rdi
    // movq %rsi, %rax
    // salq $63,  %rax
    // sarq $63,  %rax
    return x ^ ((y << 63) >> 63); // xorq %rdi, %rax
}