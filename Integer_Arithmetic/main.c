#include "avr/io.h"

int main() {
	//setting program pre-conditions/assumptions
	signed char* p;
	p = 0x244;
	*(p++) = 0x4D;
	*(p++) = 0xCB;
	*(p++) = 0xB6;
	*p = 0xF1;
	
	//(i) solution
	signed int* sumloc; //pointer to 0x210, to store sum
	sumloc = 0x210;
	*sumloc = 0;
	p = 0x244; 
	int a = 4; //loop counter
	while(a) {
		*sumloc = *sumloc + *(p++);
		a--;
	}
	
	//(ii) solution
	p = 0x244;
	signed int sub1, sub2;
	sub1 = *p - *(p+1);  //first subtraction
	sub2 = *(p+2) - *(p+3); //second subtraction
	signed long* mulloc;
	mulloc = 0x212;
	*mulloc = sub1*sub2; //loading product into 0x212
	
	//(iii) solution
	signed int q, r;
	//several cases for signed division
	if(sub1>=0 && sub2>0) {
		q = sub1/sub2;
		r = sub1 % sub2;
	}
	else if(sub1>=0 && sub2>0) {
		q = sub1/sub2;
		r = sub1 % (-sub2);
	}
	else if(sub1<0 && sub2>0) {
		q = sub1/sub2;
		q--;
		r = sub2 - (-sub1)%sub2;
	}
	else {
		q = (-sub1)/(-sub2);
		r = (-sub2) - (-sub1)%(-sub2);
	}
	
	signed int* divloc;
	divloc = 0x80;
	*(divloc++) = r; //finally storing the remainder
	*divloc = q; //and storing the quotient
	
	while(1);
	return 0;
}