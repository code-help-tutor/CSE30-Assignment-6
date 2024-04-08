// === file header ===
	.arch armv6               // armv6 architecture
	.cpu cortex-a72           // our CPU model
	.arm                      // arm 32-bit IS
	.fpu vfp                  // floating point co-processor
	.syntax unified           // modern syntax
// === definitions applying to the entire source file ===
	// you could put the bit count of certain fields or masks here, for example
	// .equ EXAMPLE_DEF, 0xff
	// .data                  // uncomment if you need the data segment
	.text                     // start of text segment

// === convert_infinity ===
// Returns a 32-bit IEEE +Inf or -Inf.
	.global convert_infinity
	.type convert_infinity, %function
	.equ FP_OFFSET, 32 	       // (# of saved regs - 1) * 4 rounded up to multiples of 8
convert_infinity:
// you should not depend on the values of r1-r3 because convert_infinity takes no arguments
	mov r1, 28
	mov r2, 61
	mov r3, 5
// function prologue (do not edit)
	push {r4-r10, fp, lr}    // save regs
	add fp, sp, FP_OFFSET
// you can use any of r0-r10 inclusive
// R0 is the parameter to the function
// the last value of R0 is the value
// returned from the function
// r4-r10 are local to this function
// changes to these values will not be reflected
// in the main function.

// YOUR CODE BEGINS
    lsr r1, r0, 14          // Shift right to get the sign bit in the least significant position
    and r1, r1, #1          // Isolate the sign bit
    lsl r1, r1, 31          // Shift left to place the sign bit in the position for 32-bit FP

    // Set the exponent to all 1s for infinity in IEEE 754 format
    mov r2, #0xFF           // 8 bits of 1s
    lsl r2, r2, 23          // Shift left to place the exponent in position

    // Combine the sign and exponent to form the IEEE 754 representation of infinity
    orr r0, r1, r2          // Combine sign and exponent
// YOUR CODE ENDS


// function epilogue (do not edit)
	sub	sp, fp, FP_OFFSET
	pop {r4-r10, fp, lr}       // restore regs
	bx lr                      // return
// function footer
	.size convert_infinity, (. - convert_infinity)

// === file footer ===
	.section .note.GNU-stack, "", %progbits // stack/data non-exec (linker)
	.end
