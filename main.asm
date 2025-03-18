/*
 * File: main.asm
 * Purpose: MicroProjet, main module
 * Authors: Bassam El Rawas, Ali Elmorsy
 */ 

.include "macros.asm"
.include "definitions.asm"
.include "m128def.inc"
;.include "printf.asm"
;.include "lcd.asm"


; === INTERRUPTION TABLE ===
.org 0
	jmp resetMain
	
/*.org INT7addr
	jmp ext_int7*/

.org OVF0addr
	rjmp overflow0


;.equ	temperatureSetButtonValue = 0x01		;bouton "1"
.equ	temperatureShowButtonValue = 0x02		;bouton "2"
.equ	musicButtonValue = 0x10			;bouton "+"
.equ    lightButtonValue = 0xdf				;bouton ">"
.equ    dimButtonValue = 0xde					;bouton "<"
.equ    lightsOffButtonValue = 0x03		;bouton "3"
.equ    endSetTemp = 0x04	
.equ    tempUpButtonValue = 0x05				;bouton "5"
.equ    tempDownButtonValue = 0x08			;bouton "8"

.equ TEMPERATURE = 0x0111

; === RESET ===
resetMain:
	LDSP	RAMEND
	;OUTI EIMSK, 0b10000000
	;OUTEI EICRB, 0b10000000
	OUTEI DDRF, 0xff
	rcall LCD_init
	OUTI ADCSR, (1<<ADEN)+6
	OUTI ADMUX, 3
	OUTI	DDRD, 0x00			;make buttons input
	sbi		DDRE, SPEAKER		;make pin SPEAKER an output

	rcall	LCD_init			;initialize LCD, needs to be done only once
	rcall	LCD_clear
	rcall	LCD_home			;place cursor to home position

	rcall	init_light
	rcall	routine_servo

	clr		b0
	clr		r23					;used for servo
	clr     r18
	OUTI	TIMSK, (1<<TOIE0)	;enable timer0 interruption
	OUTI	ASSR, (1<<AS0)		;external 32k Hz clock
	OUTI	TCCR0, 0			;CS00=7, CK/1024 (i.e periode de 8000ms: f=(32768/1024)/256)
	ldi a0, 152
	ldi a1, 1
	STS2	TEMPERATURE, a1, a0
	clr a1
	clr a0
	rjmp	main
	


	

; === INCLUDES ===
.include "lcd.asm"
.include "printf.asm"
.include "wire1.asm"

.include "moduleTelecommande.asm"
.include "moduleMusic.asm"
.include "moduleShowTemperature.asm"
.include "moduleSetTemperature.asm"
.include "moduleLumiere.asm"
.include "capt1.asm"

/*ext_int7:
	cbi	PORTB,3		; turn on LED 0 
	reti*/

; === CALLS TO SUBROUTINES ===
callSetTemperature:
	rcall	resetSetTemperature
	;rcall lcd_clear
	clr		b0
	rjmp	main

callShowTemperature:
	rcall	resetShowTemperature
	clr		b0
	rjmp	main

callMusic:
	rcall	resetMusic
	clr		b0
	rjmp	main

callLight:
    ldi		r23, 0b11111101        ;subsract from npt => turn lights on
    rcall	routine_servo
    clr		b0
    rjmp	main

callDim:
    ldi		r23, 0b11111110        ;add to npt => turn lights off
    rcall	routine_servo
    clr		b0
    rjmp	main

callLightsOff:
    rcall	init_light
    rcall	routine_servo
    clr		b0
    rjmp	main


; === MAIN PROGRAM (main loop) ===
main:
/*		CLR2 b1,b0
		ldi b2,14
		WP1 PINE,IR
		WAIT_US (T1/4)
loop:
		P2C PINE,IR
		ROL2 b1,b0
		WAIT_US (T1-4)
		DJNZ b2,loop
		com b0
		rcall LCD_clear
		rcall LCD_home
		PRINTF LCD
        .db "cmd=", FHEX,b,0
		rjmp main
*/
    rcall lcd_clear
	rcall lcd_home
	PRINTF	LCD
.db	"Welcome home :)", 0
	


	;cpi		b0, temperatureSetButtonValue
	;breq	callSetTemperature

	cpi		b0, tempUpButtonValue
	breq	callSetTemperature

	cpi		b0, tempDownButtonValue
	breq	callSetTemperature

	cpi		b0, temperatureShowButtonValue
	breq	callShowTemperature

	cpi		b0, musicButtonValue
	breq	callMusic

	cpi     b0, lightButtonValue
    breq    callLight

    cpi     b0, dimButtonValue
    breq    callDim

    cpi     b0, lightsOffButtonValue
    breq    callLightsOff					;check which button is pressed and call matching subroutine
	
	cpi     b0, 0x01
    breq    nothome


    

	rcall	detect_IR
	rjmp main

nothome : 
	rcall lcd_clear
	rcall main1
	
/*
reset :
		LDSP RAMEND 
		rcall LCD_init
		rjmp main

;.equ T1 = 1850

main :
        rcall LCD_home
		PRINTF LCD
        .db "hello", 0
		CLR2 b1,b0
		ldi b2,14
		WP1 PINE,IR
		WAIT_US (T1/4)
loop : 
        
		P2C PINE,IR
		ROL2 b1,b0
		WAIT_US (T1-4)
		DJNZ b2,loop
		com b0
		rcall LCD_clear
		rcall LCD_home
		PRINTF LCD
        .db "cmd=", FHEX,b,0
		rjmp main */
		

