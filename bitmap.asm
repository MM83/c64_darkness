

/* === TODO ===

DrawPixel


*/
	
//2000 - 3f3f = bitmap data
//0400 - 07e8 = colour data 

.label BITMAP_DATA = $2000
.label COLOUR_DATA = $0400



.macro SetBitmapMode()
{
		lda #%00111011 // Set graphics mode
		sta $d011
		lda #%11001000 // Set hires mode (11011000 is multicolour), bit 3 is 0/2000
		//lda #%11000000 // Set hires mode (11011000 is multicolour)
		sta $d016
		lda #%00011000 // Screen at $2000
		sta $d018
}

.macro SetCellColours(index, colours)
{
	lda #colours
	sta COLOUR_DATA + index
}



.macro ClearScreen()
{
	jsr clear_screen
}

clear_screen:
	
	//Set up the counters
	ldx #00
	ldy #00
	
	// Y will continue to cycle fully and X will get to 32
	
	// Setup address zp
	lda #$20
	sta $05
	lda #00
	sta $04
	
	_cs_main_loop:
	sta ($04), y
	iny
	cpy #00
	beq _cs_incy
	jmp _cs_main_loop
	
	
	_cs_incy:
	//If we're here, it's cycled through a y, so increment X
	inc $05
	inx
	cpx #32
	beq _cs_main_loop_end
	jmp _cs_main_loop
	
	_cs_main_loop_end:
	
	rts
	
.macro SetScreenColour(colour)
{
	lda #colour
	jsr set_screen_colour
}

set_screen_colour:
	ldx #00
	_ssc_loop:
	sta COLOUR_DATA, x
	sta COLOUR_DATA + 250, x
	sta COLOUR_DATA + 500, x
	sta COLOUR_DATA + 750, x
	
	inx
	cpx #250
	beq _sscend
	jmp _ssc_loop
	_sscend:

	rts
	



.macro DrawPixel(x, y)
{
	//TODO Values higher than 255 for x
	ldx #x
	ldy #y
	jsr draw_pixel
	
}

draw_pixel:

	lda #$20
	sta $05
	lda #00
	sta $04
	stx $10// Remember the x value
	txa // To get the pixel byte, we need to mask some bits...
	and #%00000111 //We only care about the first three bytes (0-7)
	tax 
	lda pixel_bytes, x // Load the correct pixel mask in
	sta $20// Store the pixel mask
	
	//Now, we need to divide the number by eight, to see how many times we have to add eight bytes
	//Do this to the original x value, then load it in
	lsr $10 
	lsr $10
	lsr $10
	ldx $10
	
	lda #00
	
	_dp_x_loop:
	cpx #00
	beq _dp_y_start
	dex
	clc
	adc #$8
	bcs _dp_x_inc
	jmp _dp_x_loop
	
	_dp_x_inc:
	inc $05
	jmp _dp_x_loop
	
	_dp_y_start:
	sta $11//The first thing we do is add the first three bits to the address, to set cell co-ordinate
	tya 
	and #%00000111
	clc 
	adc $11
	bcs _dp_y_start_inc
	jmp _dp_y_start_loop
	
	_dp_y_start_inc:
	inc $05

	_dp_y_start_loop:
	
	sty $11
	lsr $11
	lsr $11
	lsr $11
	ldy $11
	
	_dp_y_start_loop_inner:
	cpy #00
	beq _dp_draw
	
	dey
	inc $05
	clc
	adc #64
	bcs _dp_y_start_loop_inner_inc
	jmp _dp_y_start_loop_inner
	
	_dp_y_start_loop_inner_inc:
	inc $05
	jmp _dp_y_start_loop_inner
	
	_dp_draw:
	
	sta $04	
	ldy #00
	lda ($04), y
	ora $20
	sta ($04), y
	
	rts
	
	
clear_char:
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000


.macro DrawCharWithColour(x, y, charstart, colour)
{
	.var offset = x + y * 40;
	lda #colour
	sta COLOUR_DATA + offset;
	DrawChar(x, y, charstart);
}


.macro ClearCell(x, y)
{
	DrawChar(x, y, clear_char);
}

.macro DrawChar(x, y, charstart)
{
	lda #<charstart
	sta $20
	lda #>charstart
	sta $21
	ldx #x
	ldy #y
	jsr draw_char
}

draw_char:
	
	lda #$20
	sta $05
	lda #00
	_dc_addx:
	cpx #00
	beq _dc_addy
	dex
	clc
	adc #08
	bcs _dc_addxinc
	jmp _dc_addx
	
	_dc_addxinc:
	inc $05
	jmp _dc_addx
	
	
	_dc_addy:
	cpy #00
	beq _dc_initdraw
	dey
	//We need to add 320 to the acc each time, which means incrementing the high byte once and adding 64
	inc $05
	clc
	adc #64
	bcs _dc_addyinc
	jmp _dc_addy
	
	_dc_addyinc:
	inc $05
	jmp _dc_addy
	
	_dc_initdraw:
	
	sta $04
	ldy #00
	
	// DRAW 
	_dcdl:
	lda ($20), y
	sta ($04), y
	iny
	cpy #08
	bne _dcdl
	
	rts
	

