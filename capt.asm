/*
 * capt.asm
 *
 *  Created: 27/05/2023 10:08:35
 *   Author: zaynab
 */ 
 
 .equ	gp2	= PORTD

 .macro CLK0
		sbi	gp2-1, GP2_CLK

		.endmacro
.macro	CLK1
		cbi gp2-1, GP2_CLK

		.endmacro

sharp_init:
		cbi	gp2,GP2_CLK
		ret

sharp: 
		CLK0
		WAIT_MS 70
		ldi		a1,8

loop:
		CLK1
		WAIT_US 100
		CLK0
		WAIT_US 100
		P2C gp2-2, GP2_DAT
		rol a0
		dec a1
		brne loop
		CLK1
		WAIT_MS 2
		ret