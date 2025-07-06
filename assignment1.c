#include <stdio.h>
#define BITS_IN(type) (sizeof(type) * 8) // bits in datatype
typedef unsigned char* byte_pointer;

void show_bytes(byte_pointer start, size_t len) {
  for (size_t i = 0; i < len; i++)
    printf("%p 0x%.2x\n", (void*)(start + i), start[i]); // print byte address and value in hex
}

void show_bits(int decimal) {
  unsigned int mask = 1u << (BITS_IN(int) - 1); // set MSB=1
  while (mask) { // mask != 0
    printf("%d", (decimal & mask) ? 1 : 0); // print corresponding bit (x&1 = x)
    mask >>= 1;
  }
  // for (int i = BITS_IN(int) - 1; i >= 0; i--)
  //   printf("%d", (decimal & (1u << i)) ? 1 : 0);
  printf("\n");
}

int mask_LSbits(int n) {
  if (n <= 0) return 0;
  if (n >= BITS_IN(int)) return ~0;
  return (1u << n) - 1; // set n LSBs to 1
}