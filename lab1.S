.global lab1
.syntax unified

#define NZK #0x8205

.section .rodata
	res_f: .asciz "Result F = 2(X1 & _X2 + X3) - 16(X4 + 1) in PK:"
	reg_f: .asciz "First reg:\t"
	reg_s: .asciz "Second reg:\t"

.section .text
lab1:
	push {lr}

// calculate function F = 2(X1 & _X2 + X3) - 16(X4 + 1)

// get data memory
	ldr r7, =X_data
	
// load X1, X2 to regs
	ldm r7!, {r0, r1, r2, r3}
	
// NOT to X2
	eor r2, #0xFFFFFFFF
	eor r3, #0xFFFFFFFF
	
// X1 & _X2
	and r0, r2
	and r1, r3
	
// to DK
	mov r5, r0
	mov r6, r1
	bl DK
	mov r0, r5
	mov r1, r6
	
// load X3 to regs
	ldm r7!, {r2, r3}
	
// to DK
	mov r5, r2
	mov r6, r3
	bl DK
	mov r2, r5
	mov r3, r6
	
// (X1 & _X2) + X3 in DK
	adds r1, r3
	adc r0, r2

// to PK
	mov r5, r0
	mov r6, r1
	bl DK
	mov r0, r5
	mov r1, r6

// 2(X1 & _X2 + X3)
	lsls r3, r1, #1
	lsl r2, r0, #1
	adc r2, #0
	
// to DK
	mov r5, r2
	mov r6, r3
	bl DK
	mov r0, r5
	mov r1, r6
	
// load X4 to regs
	ldm r7!, {r2, r3}
	
// X4 + 1
	adds r3, #1
	adc r2, #0

// 2(X4 + 1)
	lsls r3, #1
	lsl r2, r2, #1
	adc r2, #0
	
	cmp r2, 0
	IT LT
	orrLT r2, r2, #0xC0000000
	
// 4(X4 + 1)
	lsls r3, #1
	lsl r2, r2, #1
	adc r2, #0
	
	cmp r2, 0
	IT LT
	orrLT r2, #0xC0000000
	
// 8(X4 + 1)
	lsls r3, #1
	lsl r2, r2, #1
	adc r2, #0
	
	cmp r2, 0
	IT LT
	orrLT r2, #0xC0000000
	
// 16(X4 + 1)
	lsls r3, #1
	lsl r2, r2, #1
	adc r2, #0
	
	cmp r2, 0
	IT LT
	orrLT r2, #0xC0000000
	
// - 16(X4 + 1)
	eor r2, #0xC0000000
	
// to DK
	mov r5, r2
	mov r6, r3
	bl DK
	mov r2, r5
	mov r3, r6
	
// 2(X1 & _X2 + X3) - 16(X4 + 1) in DK
	adds r3, r1
	adcs r2, r0
	
// to PK, print and back to DK
	mov r5, r2
	mov r6, r3
	bl DK
	
	ldr r0, =res_f
	bl dbgput_line
	
	ldr r0, =reg_f
	bl dbgput
	
	mov r0, r5
	bl dbgput_num
	
	ldr r0, =reg_s
	bl dbgput
	
	mov r0, r6
	bl dbgput_num
	
	bl DK
	mov r2, r5
	mov r3, r6
	
// result correction
// 1)
	ITTT VS
	lsrVS r2, r2, #1
	lsrVS r3, r3, #1
	orrVS r2, #0x80000000
	
// 2)
	cmp r3, 0

// 3)	
	ITT EQ
	movEQ r3, NZK
	lslEQ r3, r3, #4
	
// 4)
	mov r2, NZK
	
// 5)
	and r0, r2, #0xC0000000
	cmp r0, #0x80000000
	
// 6)
	ITT EQ
	asrEQ r2, r2, #1
	lsrEQ r3, r3, #1
	
// 7)
	IT VC

// result to mem
	stmVC r7!, {r2, r3}

	pop {pc}


DK:
	push { lr }
	
// to DK
	cmp r5, 0
	
	IT GE
	popGE { pc }
	
	eor r6, #0xFFFFFFFF
	eor r5, #0xFFFFFFFF
	adds r6, #1
	adc r5, r5, #0
	orr r5, #0xC0000000
	
	pop { pc }
