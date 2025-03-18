/*
 * File: moduleShowTemperature.asm
 * Purpose: MicroProjet, temperature module (displaying temperature using 1 wire)
 * Authors: Bassam El Rawas, Ali Elmorsy
 */ 

 .equ ESPACE=0x0100
 overflow0 :
    
				;stop timer0
	rcall passage						
	reti

	passage : 

	LDS2	b1, b0, ESPACE
	inc b0
	STS2	 ESPACE, b1, b0
	ret

	 ;clt
	 ;ldi r18,1
	 ;CLT
; === RESET, END ===
 resetShowTemperature:
    OUTI	TCCR0, 7						;enable timer0 with 8000ms period
	clr b0
	clr b1
	STS2	ESPACE, b1, b0
	sei
	rcall	wire1_init						;initialize 1-wire interface
	rjmp	mainShowTemperature


endShowTemperature:
	OUTI	TCCR0, 0
	cli	
	rcall lcd_clear
	ret


; === MAIN PROGRAM ===
mainShowTemperature:
   LDS2	b1, b0, ESPACE
	cpi		b0, 0
	brne	endShowTemperature
	rcall	wire1_reset
	CA		wire1_write, skipROM			;skip ROM identification. CA macro: lign ~1825
	CA		wire1_write, convertT			;initiate temp conversion
	WAIT_MS 750

	
	rcall	wire1_reset						;send a reset pulse
	CA		wire1_write, skipROM
	CA		wire1_write, readScratchpad
	rcall	wire1_read						;read temperature LSB
	mov		c0, a0
	rcall	wire1_read						;read temperature MSB
	mov		a1, a0
	mov		a0, c0							;in the end, a0 will contain LSB and a1 MSB
	STS2	TEMPERATURE, a1, a0
	rcall	lcd_clear
	rcall	lcd_home						;place cursor to home position
	PRINTF	LCD
    .db	 "temp = ", FFRAC2+FSIGN, a, 4, $42, "C ", CR, 0
	rjmp mainShowTemperature
	
	
