
.pc=$0801
:BasicUpstart(main_start)
*=$080d
#import "bitmap.asm"
#import "random.asm"
*=$2000
#import "char_map.asm" 

*=$1000
pixel_bytes:
.byte %10000000, %01000000, %00100000, %00010000, %00001000, %00000100, %00000010, %00000001

// Fixed point 16 bit float -128.0 - 127.255


sea_char:
.byte %00010000
.byte %00001000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00001100
.byte %00000000
.byte %00000000




main_start:
	
	lda #06
	sta $d020
	sta $d021
	
	SetBitmapMode();
	ClearScreen();
	SetScreenColour($10);
	DrawPixel(2, 2);
	DrawPixel(2, 3);
	DrawPixel(2, 4);
	DrawPixel(2, 5);

	
	jmp *



