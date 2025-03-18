/*
 * File: moduleTelecommande.asm
 * Purpose: MicroProjet, remote control module
 * Authors: Bassam El Rawas, Ali Elmorsy
 */ 


;.def	rc_reg = r22							;use r27 to stock pulse


.equ	T1 = 1850	

detect_IR:

	CLR2		b1, b0						 
	ldi			b2, 14			
	;clr			rc_reg
	WP1			PINE, IR		;stays blocked until IR=0		
	WAIT_US		(T1/4)	

			
	
	


; === REMOTE CONTROL FUNCTIONS ===
;Read Adress:
addr: 
    P2C PINE, IR
    ROL2 b1,b0
    WAIT_US(T1-4)
    DJNZ b2,addr
    com b0
	rcall main
	rjmp detect_IR




