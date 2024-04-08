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

// === fpconvert ===
	.global fpconvert         // make fpconvert global so the linker knows about it
	.type fpconvert, %function // define fpconvert to be a function
	.equ FP_OFFSET, 32 	      // (# of saved regs - 1) * 4 rounded up to multiples of 8
fpconvert:
// function prologue (do not edit)
	push {r4-r10, fp, lr}     // save registers to stack
	add fp, sp, FP_OFFSET     // set frame pointer to frame base
// you can use any of r0-r10 inclusive
// r0 is the parameter to the function
// the value of r0 upon bx lr is the value returned from the function

// YOUR CODE BEGINS
    // Extract the sign (1 bit), exponent (5 bits), and mantissa (9 bits)
    mov r1, r0                // Copy r0 to r1 for manipulation
    lsr r2, r1, #14           // Extract sign bit
    and r2, r2, #1            // Isolate sign bit
    lsl r2, r2, #31           // Place sign bit in position for 32-bit FP

    mov r3, r1                // Copy r0 to r3 for manipulation
    lsr r3, r3, #9            // Shift right to isolate exponent
    and r3, r3, #0x1F         // Mask to get 5-bit exponent

    // Load the mantissa mask into a register
    mov r4, #0xFF             // Lower 8 bits
    lsl r4, r4, #1            // Shift left to make space for the last bit
    orr r4, r4, #1            // Add the last bit to complete the mask
    and r1, r1, r4            // Apply the mask to the mantissa

    // Check for infinity
    cmp r3, #0x1F             // Check if exponent is all 1s
    beq convert_infinity      // Branch if so

    // Adjust exponent from 15-bit FP to 32-bit IEEE 754 format
    add r3, r3, #112          // Adjust the exponent
    lsl r3, r3, #23           // Shift left to place exponent in position

    // Combine sign, adjusted exponent, and mantissa
    orr r0, r2, r3            // Combine sign and exponent
    orr r0, r0, r1            // Combine with mantissa
// YOUR CODE ENDS


// function epilogue - do not edit
	sub sp, fp, FP_OFFSET
	pop {r4-r10, fp, lr}      // must match list in prolog's push
	bx lr                     // return
// function footer
	.size fpconvert, (. - fpconvert) // set size for function

// === file footer ===
	.section .note.GNU-stack, "", %progbits // stack/data non-exec (linker)
	.end