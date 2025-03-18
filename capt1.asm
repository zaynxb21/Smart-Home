/*
 * capy1.asm
 *
 *  Created: 27/05/2023 10:19:53
 *   Author: zaynab
 */ 
 ;.include "macros.asm"
 ;.include "definitions.asm"

 

/*.org 
	jmp	reset
.org INT0addr
	jmp ext_int0

ext_int0:
	cbi	PORTB,3		
	reti*/

 /*reset : 
		LDSP	RAMEND
		;OUTI	DDRD, 0x00
		OUTI	DDRB, 0xff
		OUTI	EIMSK, 0b00001111
		
		rcall	sharp_init

		rcall	LCD_init
		jmp main

 .include "lcd.asm"
.include "printf.asm"
.include "capt.asm"

main:
	
		rcall sharp
		PRINTF LCD

.db		"a=", FDEC+FDIG3, a, CR, 0
		rjmp main
*/



;.include "sound.asm"

	resetalarm:

	ldi		a0, 0
	ldi		r21, 0			;use r19 as counter
	;clr r0
	;clr r1
	;clr a0
	;spm 
	rcall	lcd_clear
	rcall	lcd_home		;place cursor to home position

	PRINTF	LCD
	.db	"Warning", 0

	rjmp	mainalarm

	
	; .include "lcd.asm"
;.include "printf.asm"
	

	main1 :
			;clr b0
		
			PRINTF	LCD
			.db	"ALARM ON",0
			sbi ADCSR, ADSC
			WP1 ADCSR, ADSC
			in a0, ADCL
			in a1, ADCH
			mov r28, a0
		    clr a0
			cpi	r28, 0x47
			breq resetalarm 
		    mov a0, r28
		    clr r28	
			rjmp main1

	
	


	mainalarm :


	clr		a0
	clr		a1
	add		a0, r21
	
	ldi		zl, low(2*alarmTable)	;load table base into z
	ldi		zh, high(2*alarmTable)	
	add		zl,a0						;add offset to table base
	adc		zh,a1						;add high byte
	lpm									;load program memory, r0 <- (z)
	
	mov		a0,r0						;load oscillation period
	ldi		b0,100						;load duration
	rcall	sound
	
	inc		r21 

							;make r17 play the next note
	cpi		r21, 6					;compares counter with 96 (# of notes)
	breq	endalarm					;if we're done, branch back to main program
	rjmp	mainalarm


	endalarm:
	
	rjmp main
	;ret

	alarmTable:
	.db so, re2, rem2, do2, re2, lam 
	;.db	so, re2, rem2, do2, re2, lam
	;.db	so, re2, rem2, do2, re2, lam 
	;.db	do2, la, lam, do2, la, lam
	;.db	so, re2, rem2, do2, re2, lam,0
	
	/*.db so, la, si2, do, re, mi
	.db fa, sol, la, si2, do, re
	.db si2, la, sol, so, la, si2,0*/
	