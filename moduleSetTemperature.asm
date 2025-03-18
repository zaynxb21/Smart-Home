/*
 * File: moduleSetTemperature.asm
 * Purpose: MicroProjet, temperature module (setting temperature using remote control)
 * Authors: Bassam El Rawas, Ali Elmorsy
 */ 


; === INTERRUPT ROUTINES ===
/*ovf0:
	OUTI	TCCR0, 0			;stop timer0
	set							;set T flag
	reti


; === CONSTANTS ===
.equ USER_TEMPERATURE = 0x0100		;=256
.equ DEFAULT_TEMPERATURE = 320		;default user temperature = 0x1400, 20 concactenated with 


; === RESET, END ===
 resetSetTemperature:
	LDI2	b1, b0, DEFAULT_TEMPERATURE
	STS2	USER_TEMPERATURE, b1, b0		;start out with default temperature in SRAM

	OUTI	TCCR0, 7						;enable timer0 with 8000ms period
	sei
	clt
	rjmp	mainSetTemperature

endSetTemperature:
	rcall	lcd_clear
	clr		a0
	clr		a1
	clr		b0
	clr		b1
	clr		c0
	clr		r31
	cli			
	ret

	
; === MAIN PROGRAM ===
mainSetTemperature:
	brbs	6, endSetTemperature			;6 = 6th big in SREG = T
	rcall	lcd_clear
	rcall	lcd_home

	LDS2	b1, b0, USER_TEMPERATURE		;get user temperature ready for lcd display

	PRINTF	LCD
.db	"Set Temperature:", 0
	CA lcd_pos, $40
	PRINTF	LCD
.db	 FFRAC2+FSIGN, b, 4, $42, "C ", CR, 0

	push	a0
	push	a1
	push	b0
	push	b1
	push	c0
	
	rcall detect_IR	

	pop	c0
	pop	b1
	pop	b0
	pop	a1
	pop	a0
	
	cpi		b0, tempUpButtonValue
	breq	callTemperatureUp

	cpi		b0,tempDownButtonValue
	breq	callTemperatureDown
	
	rjmp	mainSetTemperature
	

callTemperatureUp:
	in		_sreg, SREG
	lds		r31, USER_TEMPERATURE			;read user temperature from SRAM			
	ADDI	r31, 0b00001000					;increment temperature by 0.5C
	sts		USER_TEMPERATURE, r31
	out		SREG, _sreg
	rjmp	mainSetTemperature

callTemperatureDown:
	in		_sreg, SREG
	lds		r31, USER_TEMPERATURE
	subi	r31, 0b00001000
	sts		USER_TEMPERATURE, r31
	out		SREG, _sreg
	rjmp	mainSetTemperature
	*/
	;.equ USER_TEMPERATURE = 0x0100		;=256

	

	resetSetTemperature:
	
	rjmp mainSetTemperature




	


		
	

	

	mainSetTemperature:

	LDS2	a1, a0, TEMPERATURE
	rcall lcd_clear
	rcall lcd_home
	
	PRINTF	LCD
    .db	 "Stemp = ", FFRAC2+FSIGN,a, 4, $42, "C ", CR, 0
	
	
	
	
    cpi		b0, tempUpButtonValue
	breq	callTemperatureUp
	
	cpi		b0,tempDownButtonValue
	breq	callTemperatureDown

	cpi		b0,endSetTemp
	breq	endSetTemperature
	
    rcall detect_IR
	rjmp	mainSetTemperature

	callTemperatureUp:

	clr b0
	in		_sreg, SREG
	LDS2	a1, a0, TEMPERATURE
	ADDI	a0, 0b00001000				;increment temperature by 0.5C
	STS2	TEMPERATURE, a1, a0
	out		SREG, _sreg
	rjmp	mainSetTemperature

    callTemperatureDown:

	clr b0
	in		_sreg, SREG
	LDS2	a1, a0, TEMPERATURE
	SUBI	a0, 0b00001000				;increment temperature by 0.5C
	STS2	TEMPERATURE, a1, a0
	out		SREG, _sreg
	rjmp	mainSetTemperature


	endSetTemperature:
	rcall lcd_clear
	ret


    

	
	