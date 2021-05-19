
;Name : SHUBHAM KUMAR
;ROLL : 18IE10021
 ;THIS IS NOT A GROUP PROJECT, I AM THE ALONE CONTRIBUTOR

.include "m32def.inc"

;setting Stack Pointer to the end of RAM location
ldi r16, low(ramend)
out spl, r16
ldi r16, high(ramend)
out sph, r16

;setting problem pre-conditions/assumptions
ldi xl, 0x44 ;loading X with 0x0244
ldi xh, 0x02 ;X will act as a pointer to memory location $244
ldi r16, 0x4D
st x+, r16  ;Storing $4D in memory location $244
ldi r16, 0xCB
st x+, r16  ;Storing $CB in memory location $245
ldi r16, 0xB6
st x+, r16  ;Storing $B6 in memory location $246
ldi r16, 0xF1
st x, r16   ;Storing $F1 in memory location $247

;solving problem statements

;(i) solution :-
ldi xl, 0x44  ;using x as pointer to point to memory location 0x244
ldi xh, 0x02

ldi r16, 0
ldi r17, 0
ldi r18, 4   ;loop1 counter
	loop1 : ldi r20,0 ; Implementing standard 16bit signed algorithm and adding each number every iteration
		   ld r19, x+ ; loading values from memory
		   tst r19 ; setting flag registers
		   brmi minus1 ; branching if number is negative 
		           add r16, r19
		           adc r17, r20
				   rjmp here1
		   minus1 : neg r19
		           sub r16, r19
				   sbc r17, r20
    here1 : dec r18
		   brne loop1
ldi xl, 0x10 ;using x as apointer to memory location 0x210
ldi xh, 0x02
st x+, r16 ; storing 16bit values at location 0x211 : 0x210 in little endian format
st x, r17

;(ii) solution :-
ldi xl, 0x44 ;using x as pointer to point to memory location 0x244
ldi xh, 0x02
ldi yl, 0x16 ;using y as pointer to point to memory location 0x216 for storing subtraction result
ldi yh, 0x02

ldi r18, 2 ; loop2 counter
	loop2 :ldi r16, 0 ; implementing signed subtraction, one in ach iteration
           ldi r17, 0  
	       ldi r20, 0
		   ld r19, x+ ; loading values from memory
		   tst r19 ; setting flag registers
		   brmi minus2 ; branching if number is negative
		           add r16, r19 ; if number is +ve
		           adc r17, r20
		           rjmp here2
	       minus2 : neg r19 ;if number is -ve
	               sub r16, r19
			       sbc r17, r20
	       here2 : ldi r20, 0
		          ld r19, x+ ;loading next number and performing similar operation
		          tst r19
		          brmi minus_2
		          sub r16, r19 
		          sbc r17, r20
		          rjmp there2
		   minus_2 : neg r19
		            add r16, r19
		            adc r17, r20
		   there2 : st y+, r16 ; finally storing the value at 0x216 onwards
				   st y+, r17
		   dec r18
		   brne loop2
; now we need to multiply the differences
ldi yl, 0x16
ldi yh, 0x02
; loading registers with differences
ld r22, y+
ld r23, y+
ld r20, y+
ld r21, y+

;standard 16x16=32 signed multiplication
clr	r2
	muls	r23, r21		; (signed)ah * (signed)bh
	movw	r19:r18, r1:r0
	mul	r22, r20		; al * bl
	movw	r17:r16, r1:r0
	mulsu	r23, r20		; (signed)ah * bl
	sbc	r19, r2
	add	r17, r0
	adc	r18, r1
	adc	r19, r2
	mulsu	r21, r22		; (signed)bh * al
	sbc	r19, r2
	add	r17, r0
	adc	r18, r1
	adc	r19, r2

ldi xl, 0x12
ldi xh, 0x02
;finally storing 32 bit product at required memory location
st x+, r16
st x+, r17
st x+, r18
st x, r19

;(iii) solution :-
;loading registers with differences
lds r16, 0x216
lds r17, 0x217
lds r18, 0x218
lds r19, 0x219

;standard 16bit signed division

.def	d16s	=r13			;sign register
.def	drem16sL=r14			;remainder low byte
.def	drem16sH=r15			;remainder high byte
.def	dres16sL=r16			;result low byte
.def	dres16sH=r17			;result high byte
.def	dd16sL	=r16			;dividend low byte
.def	dd16sH	=r17			;dividend high byte
.def	dv16sL	=r18			;divisor low byte
.def	dv16sH	=r19			;divisor high byte
.def	dcnt16s	=r20			;loop counter

div16s:	mov	d16s,dd16sH		;move dividend High to sign register
	eor	d16s,dv16sH		;xor divisor High with sign register
	sbrs	dd16sH,7		;if MSB in dividend set
	rjmp	d16s_1
	com	dd16sH			;    change sign of dividend
	com	dd16sL
	subi	dd16sL,low(-1)
	sbci	dd16sL,high(-1)
d16s_1:	sbrs	dv16sH,7		;if MSB in divisor set
	rjmp	d16s_2
	com	dv16sH			;    change sign of divisor
	com	dv16sL
	subi	dv16sL,low(-1)
	sbci	dv16sH,high(-1)
d16s_2:	clr	drem16sL		;clear remainder Low byte
	sub	drem16sH,drem16sH	;clear remainder High byte and carry
	ldi	dcnt16s,17		;init loop counter

d16s_3:	rol	dd16sL			;shift left dividend
	rol	dd16sH
	dec	dcnt16s			;decrement counter
	brne	d16s_5			;if done
	sbrs	d16s,7			;    if MSB in sign register set
	rjmp	d16s_4
	com	dres16sH		;        change sign of result
	com	dres16sL
	subi	dres16sL,low(-1)
	sbci	dres16sH,high(-1)
d16s_4:	rjmp here3			;    return
d16s_5:	rol	drem16sL		;shift dividend into remainder
	rol	drem16sH
	sub	drem16sL,dv16sL		;remainder = remainder - divisor
	sbc	drem16sH,dv16sH		;
	brcc	d16s_6			;if result negative
	add	drem16sL,dv16sL		;    restore remainder
	adc	drem16sH,dv16sH
	clc				;    clear carry to be shifted into result
	rjmp	d16s_3			;else
d16s_6:	sec				;    set carry to be shifted into result
	rjmp	d16s_3

; we have stored remainder at 0x81 : 0x80 and quotient at 0x83 : 0x82
here3 : sts 0x80, drem16sL
sts 0x81, drem16sH
sts 0x82, dres16sL
sts 0x83, dres16sH

end : rjmp end
