#include "avr/io.h"

int main() {
	
	DDRC = 0xFF;
	
	while(1) {
		int a1 = 10;
		while(a1) {
			int a2 = 10;
			while(a2) {
				int a3 = 10;
				while(a3) {
					int a4 = 10;
					while(a4) {
						int a5 = 10;
						while(a5) {
							TCNT1H = 0xFF;
							TCNT1L = 0xBF;
							TCCR1A = 0;
							TCCR1B = 0x01;
							while(!(TIFR & (1<<TOV1)));
							TCCR1B = 0;
							TIFR = 1<<TOV1;
							PORTC ^= 1<<0;
							--a5;
						}
						PORTC ^= 1<<1;
						--a4;
					}
					PORTC ^= 1<<2;
					--a3;
				}
				PORTC ^= 1<<3;
				--a2;
			}
			PORTC ^= 1<<4;
			--a1;
		}
		PORTC ^= 1<<5;
	}
	return 0;
}