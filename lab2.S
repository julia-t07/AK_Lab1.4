.global lab2
.syntax unified

.section .rodata
	test_first: .asciz "First under-program in."
	test_first_2: .asciz "First under-program out."
	test_sec: .asciz "Second under-program in."
	test_sec_2: .asciz "Second under-program out."
	
.section .text
lab2:
	push {lr}
	mov r5, #2
	mov r6, #3
	
// 1)
	adds r7, r6, r5
	
// 2)
	mul r7, r6, r5

outer:
// 3)
	sub r7, r6, r5
	
// 4)
	IT CC
	bCC not_cs
	
// 6)
	add r7, r6, r5
	
// 5)
	mrs r7, APSR
	orr r7, #(1<<28)
	msr APSR_nzcvq, r7
	b over_first
	
not_cs:
// VI
	bl first
	
// 7)
	subs r7, r6, r5
over_first:
	
// 8)
	//IT VC
	bVC outer
	
// 9)
	add r7, r6, r5
	
	pop {pc}


first:
	push {lr}
	
// print	
	ldr r0, =test_first
	bl dbgput_line
	
outer_first:
// 10)
	mov r7, #1
	lsrs r7, #1
	
// 11)
	IT MI
	bMI over_second
	
// X
	bl second

// 12)
	mov r7, #3
	lsrs r7, #1
over_second:

// 13)
	IT CC
	bCC outer_first
	
// 14)
	sub r7, r6, r5
	
// 15)
	add r7, r6, r5
	
// print	
	ldr r0, =test_first_2
	bl dbgput_line
	
	pop {pc}
	

second:
	push {lr}
	
// print	
	ldr r0, =test_sec
	bl dbgput_line
	
// 17)
	adds r7, r6, r5
	
// 18)
	mul r7, r6, r5
	
// print	
	ldr r0, =test_sec_2
	bl dbgput_line
	
	pop {pc}
