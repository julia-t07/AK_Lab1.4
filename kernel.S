.syntax unified
.cpu cortex-m4
//.fpu softvfp
.thumb

// Global memory locations.
.global vtable_kernel
.global __kernel_reset__

.global X_data

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector

vtable_kernel:
	.word __stack_start
	.word __kernel_reset__+1
	.size vtable_kernel, .-vtable_kernel

.section .rodata

	data: .asciz "kernel started!\n"
	task11: .asciz "Task 1 is started.\n"
	res_f2: .asciz "\nResult after correction:"
	task21: .asciz "\nTask 1 is finished.\n\nTask 2 is started.\n"
	task22: .asciz "\nTask 2 is finished."
	reg_f: .asciz "First reg:\t"
	reg_s: .asciz "Second reg:\t"
	
.section .text

__kernel_reset__:
	ldr r0, =data
	bl dbgput_line

	ldr r0, =task11
	bl dbgput_line
	
	bl lab1

	ldr r0, =res_f2
	bl dbgput_line
	
	ldr r0, =reg_f
	bl dbgput
	
	mov r0, r2
	bl dbgput_num
	
	ldr r0, =reg_s
	bl dbgput
	
	mov r0, r3
	bl dbgput_num
	
	ldr r0, =task21
	bl dbgput_line
	
	bl lab2
	
	ldr r0, =task22
	bl dbgput_line
    
end:
	b end
    
X_data:
	.word 	0		//X1_1
	.word	12		//X1_2
	.word	0		//X2_1
	.word	2		//X2_2
	.word	0xC0000000	//X3_1
	.word	10		//X3_2
	.word	0		//X4_1
	.word	15		//X4_2
	.word	0		//F_1
	.word	0		//F_2
	
