.include "m32def.inc"                                                         ;clock cycles
																			  
ldi r31, high(ramend)														  ; 1
out sph, r31																  ; 1
ldi r31, low(ramend)														  ; 1
out spl, r31																  ; 1
																			  
ldi r16, -65																  ; 1
ldi r18, 0																	  ; 1
ldi r17, 1<<0																  ; 1
ldi r19, 1<<1																  ; 1
ldi r20, 1<<2																  ; 1
ldi r21, 1<<3																  ; 1
ldi r22, 1<<4																  ; 1
ldi r23, 1<<5																  ; 1
ldi r29, 1<<6																  ; 1
																			  
ldi r31, 0xFF																  ; 1
out ddrc, r31																  ; 1
																			  
start : ldi r24, 10															  ; 1
		loop1 : ldi r25, 10													  ; 1
				loop2 : ldi r26, 10											  ; 1
						loop3 : ldi r27, 10									  ; 1
								loop4 : ldi r28, 10							  ; 1
										loop5 :		out tcnt2, r16			  ; 1
													out tccr2, r17			  ; 1
													again : in r20, tifr	  ; 1
															sbrs r20, tov2	  ; 1 / 2
															rjmp again		  ; 2
													out tccr2, r18			  ; 1
													out tifr, r29			  ; 1
												in r31, portc				  ; 1
												eor r31, r17				  ; 1
												out portc, r31				  ; 1
												dec r28						  ; 1
												brne loop5					  ; 1 / 2
										in r31, portc						  ; 1
										eor r31, r19						  ; 1
										out portc, r31						  ; 1
										dec r27								  ; 1
										brne loop4							  ; 1 / 2
								in r31, portc								  ; 1
								eor r31, r20								  ; 1
								out portc, r31								  ; 1
								dec r26										  ; 1
								brne loop3									  ; 1 / 2
						in r31, portc										  ; 1
						eor r31, r21										  ; 1
						out portc, r31										  ; 1
						dec r25												  ; 1
						brne loop2											  ; 1 / 2
				in r31, portc												  ; 1
				eor r31, r22												  ; 1
				out portc, r31												  ; 1
				dec r24														  ; 1
				brne loop1													  ; 1 / 2
		in r31, portc														  ; 1
		eor r31, r23														  ; 1
		out portc, r31														  ; 1
		rjmp start															  ; 2

