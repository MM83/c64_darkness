
/*

This is a utility routine which draws a box on the screen in character mode.

*/

.macro DrawBox(x, y, w, h, char, colour)
{
	.var charAbs = x + y * 40
	.var bank = floor(charAbs / 256) + 4
	.var colBank = floor(charAbs / 256) + 216
	.var charIndex = mod(charAbs, 256)
	
	lda #charIndex
	sta $03 // Store for char mem
	sta $08 // Store for colour mem
	lda #bank
	sta $04
	lda #colBank
	sta $09
	lda #w
	sta $05
	lda #h
	sta $06
	lda #char
	sta $07
	lda #colour
	sta $0A
	jsr draw_box_start
}


draw_box_start:
ldy #00// Y is the incrementor

	draw_box_loop_row:
	lda $07		// Load the designated character into memory
	sta ($03), y
	lda $0A
	sta ($08), y
	iny
	cpy $05
	bne draw_box_loop_row
	
	// If it's here, the row is complete, time to start the next or rts
	ldy #00 // Reset the y counter
	ldx $06 // Load the height value
	dex		// Decrement
	stx $06 // Store the height value
	cpx #00 // Compare to zero
	beq global_rts // If it is zero, end the routine
	
	// If it's here, there's another row to draw.
	lda $03 // Load the lo value
	clc		// Clear carry flag
	adc #40	// Add 40 to the lo value
	sta $03 // Store the lo value for char
	sta $08 // Store the lo value for colour
	bcc draw_box_loop_row // If no carry set, continue
	
	// If it's here, the carry has been set
	ldx $04 // Increment and store the hi value
	inx		// Screen-bounds checking is assumed to have been done
	stx $04
	ldx $09 // Increment and store hi for colour
	inx
	stx $09
	jmp draw_box_loop_row
	
global_rts:
rts
