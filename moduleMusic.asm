/*
 * File: moduleMusic.asm
 * Purpose: MicroProjet, music module
 * Authors: Bassam El Rawas, Ali Elmorsy
 */ 


; === RESET, END ===
resetMusic:
	ldi		a0, 0
	ldi		r17, 0			;use r17 as counter

	rcall	lcd_clear
	rcall	lcd_home		;place cursor to home position

	PRINTF	LCD
.db	"Dicover :", 0
	CA lcd_pos, $40
	PRINTF	LCD
.db "YOA by dreamer", 0

	rjmp	mainMusic

endMusic:
	rcall	lcd_clear
	ret


; === MAIN PROGRAM ===
.include "sound.asm"		; include sound routine

mainMusic:
	clr		a0
	clr		a1
	add		a0, r17

	ldi		zl, low(2*soundTable)	;load table base into z
	ldi		zh, high(2*soundTable)	
	add		zl,a0						;add offset to table base
	adc		zh,a1						;add high byte
	lpm									;load program memory, r0 <- (z)
	
	mov		a0,r0						;load oscillation period
	ldi		b0,100						;load duration
	rcall	sound

	inc		r17							;make r17 play the next note
	cpi		r17, 96						;compares counter with 96 (# of notes)
	breq	endMusic					;if we're done, branch back to main program
	rjmp	mainMusic


; === MUSIC NOTES ===

soundTable:
	.db so, re2, rem2, do2, re2, lam 
	.db	so, re2, rem2, do2, re2, lam 
	.db	so, re2, rem2, do2, re2, lam 
	.db	do2, la, lam, do2, la, lam
	.db	so, re2, rem2, do2, re2, lam
	.db	so, re2, rem2, do2, re2, lam
	.db	so, re2, rem2, do2, re2, lam
	.db	do2, la, lam, so, fa, rem
	.db	re, re2, rem2, do2, re2, la
	.db	re, re2, rem2, do2, re2, la
	.db	re, la, do2, re2, rem2, fa2
	.db	re2, rem2, do2, re2, lam, la
	.db	re, re2, rem2, do2, re2, la
	.db	re, re2, rem2, do2, re2, la
	.db	re, do2, re2, rem2, fa2, re2
	.db	rem2, do2, re2, lam, do2, la, 0

/*
	.db	do2, so, mi, la, si, si2
	.db	la, so, mi2, so2, la2, fa2
	.db	so2, mi2, do2, re2, si, do2
	.db	so, mi, la, si, si2, la
	.db so, mi2, so2, la2, fa2, so2
	.db mi2, do2, re2, si, so2, fa2
	.db fa2, re2, mi2, so, la, do2
	.db so2, fa2, fa2, re2, mi2, do2 
	.db do2, do2, so2, fa2, fa2, re2
	.db	mi2, so, la, do2, la, do2
	.db re2, re2, re2, do2, do2, do2
	.db do2, do2, re2, mi2, do2, la
	.db	so, do2, do2, do2, do2, re2
	.db	mi2, do2, do2, do2, do2, re2
	.db	mi2, do2, la, so, mi2, mi2
	.db	mi2, do2, mi2, so2, so, so, 0*/