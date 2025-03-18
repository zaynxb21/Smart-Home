; file	int0c.asm   target ATmega128L-4MHz-STK300		
; purpose using INT0..INT3
.include "macros.asm"		; include macros definitions
.include "definitions.asm"	; include register/constant definition
;.include "lcd.asm"
;.include "printf.asm"
.include "capt1.asm"

; === interrupt table ===
.org	0
	jmp	reset
.org	INT0addr
	jmp	ext_int0
/*.org	INT1addr
	jmp	ext_int1
.org	INT2addr
	jmp	ext_int2
.org	INT3addr
	jmp	ext_int3*/

; === interrupt service routines	
ext_int0:
	cbi	PORTB,1		; turn on LED 1 
	reti
/*ext_int1:
	cbi	PORTB,1		; turn on LED 1 
	reti
ext_int2:
	cbi	PORTB,2		; turn on LED 2 
	reti
ext_int3:
	cbi	PORTB,3		; turn on LED 3 
	reti*/

; === initialization (reset) ====
reset:
	LDSP	RAMEND		; load stack pointer SP
	OUTI	DDRB, 0xFF	; portB = output
	OUTI	EIMSK,0b00000001 ; enable INT0..INT3	; 
	sei					; set global interrupt

; === main program ===
main:
	WAIT_US	10000		; wait 10 msec
	dec	r18				; decrement counter
	out	PORTB,r18		; output counter value to LED
	rjmp	main