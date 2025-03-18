/*
 * File: moduleLumiere.asm
 * Purpose: MicroProjet, light dimmer module
 * Authors: Bassam El Rawas, Ali Elmorsy
 */ 


.equ	npt = 2424			;for lights off start at 2424 micro_secs, and for max lighting 270 microsecs
.def	g0=r26
.def	g1=r28
.def	g2=r29
.def	g3=r30


quit:
	ret

routine_servo:
ldi	r31,$19					;25 cycles so about 0.5 seconds
npset:						;neutral point setting
	dec	r31
	breq	quit
	cpi	r23, 0b11111110
	breq _cw				;clockwise
	cpi	r23, 0b11111101
	breq _ccw				;counter clockwise
_exec:
	rcall	servoreg_pulse
	rjmp	npset			;will jump back to npset if nothing is pressed
_cw:
	ADDI2	g1,g0,2			;increase pulse timing, this would be incrementing ton by 2 microseconds,of the black servo and accelerating the blue one
	cpi		g1,$09
	brne	_exec
	cpi		g0,$7a
	brne	_exec
	SUBI2	g1,g0,2		;light is off
	rjmp	_exec	
_ccw:
	SUBI2	g1,g0,2		;decrease pulse timing, this would be decrementing ton of the black servo by 2 microseconds and decelerating the blue one 	
	cpi		g1,$01
	brne	_exec
	cpi		g0,$0c
	brne	_exec
	ADDI2	g1,g0,2 	;light is maxed out
	rjmp	_exec


servoreg_pulse:
	WAIT_US	20000
	MOV2	g3,g2,g1,g0
	P1	PORTB,SERVO1		; pin=1	
lpssp01:	
	SUBI2	g3,g2,0x1
	brne	lpssp01			;loop for T-ON
	P0	PORTB,SERVO1		;pin=0
	ret

init_light:						;initializations
	P0	PORTB,SERVO1			;pin=0
	LDI2	g1,g0,npt			;load neutral point value in regs a1 a0
	rcall	servoreg_pulse
ret
