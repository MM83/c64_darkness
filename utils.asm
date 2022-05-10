

.macro SaveWithAcc(value, address)
{
	lda #value
	sta address
}

.macro SetCharColourWholeScreen(Colour)
{
	lda #Colour
	ldx #0
	jsr set_screen_chars_col
}

set_screen_chars_col:
	sta $D800, x
	sta $D900, x
	sta $DA00, x
	sta $DB00, x
	inx
	cpx #$00
	bne set_screen_chars_col
	rts

.macro ClearScreen(Char, Colour)
{
	SetCharColourWholeScreen(Colour);
	lda #Char
	ldy #Colour
	jsr clear_screen_start			
}
clear_screen_start:
		ldx #00
clear_screen_loop:
		sta $0400, x
		sta $0500, x
		sta $0600, x
		sta $0700, x
		inx
		cpx #$00
		bne clear_screen_loop
		rts
		
		
		
		
_var_write_str_colour: .byte $07
_var_write_str_length: 	.byte $00	
_var_write_str_bank:   	.byte $00	
_var_write_str_char:   	.byte $00

.macro WriteString(x, y, length, address, colour)//Uses zp3-4 for string address, zp5-6 for bank address, zp7-8 for colour address
{
	.var char = x + y * 40
	.var bank = floor(char / 256)
	lda #bank
	sta _var_write_str_bank
	lda #char
	sta _var_write_str_char
	lda #length
	sta _var_write_str_length
	lda #colour
	sta _var_write_str_colour
	lda #<address
	sta $03
	lda #>address
	sta $04
	jsr _write_text
}
_write_text:
	lda _var_write_str_char
	sta $05//Char start
	sta $07//Colour start
	lda #$d8//Colour offset
	clc
	adc _var_write_str_bank                    
	sta $08
	lda #$04//Char offset
	clc
	adc _var_write_str_bank
	sta $06
	ldy #$00
	_write_text_loop:
		lda ($03), y
		sta ($05), y
		lda _var_write_str_colour
		sta ($07), y
		iny
		cpy _var_write_str_length
		bne _write_text_loop
		rts

		
