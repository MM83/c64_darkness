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

		
_var_cycle_delay_lo: .byte $af



.macro CycleDelay(amount_hi)
{
	lda #amount_hi
	sta $40
	jsr _cycle_delay
}


_cycle_delay:
	ldx #00
	ldy #00
	_cycle_delay_x:
		inx
		cpx _var_cycle_delay_lo
		bne _cycle_delay_x
	ldx #00
	iny
	cpy $40
	bne _cycle_delay_x
	rts

.macro DrawLaunchedTextUSA()
{
		lda #<missile_launched_text_usa//Set zp pointer for graphics characters
		sta $02
		lda #>missile_launched_text_usa
		sta $03
		lda #<missile_launched_text_usa + 130
		sta $04
		lda #>missile_launched_text_usa + 130
		sta $05
		lda #<missile_launched_text_usa + 260
		sta $06
		lda #>missile_launched_text_usa + 260
		sta $07
		lda #<missile_launched_text_usa + 390
		sta $08
		lda #>missile_launched_text_usa + 390
		sta $09
	jsr draw_launched_text
}


.macro DrawLaunchedTextUSSR()
{
		lda #<missile_launched_text_ussr//Set zp pointer for graphics characters
		sta $02
		lda #>missile_launched_text_ussr
		sta $03
		lda #<missile_launched_text_ussr + 130
		sta $04
		lda #>missile_launched_text_ussr + 130
		sta $05
		lda #<missile_launched_text_ussr + 260
		sta $06
		lda #>missile_launched_text_ussr + 260
		sta $07
		lda #<missile_launched_text_ussr + 390
		sta $08
		lda #>missile_launched_text_ussr + 390
		sta $09
	jsr draw_launched_text
}
	
draw_launched_text://uses zp 2-9 for screen char address, ab for store address
		
		
		
		lda #$c8//Set zp pointer for screen memory
		sta $12
		lda #$04
		sta $13
		ldy #00
		
		lda #$4a//Set zp pointer for screen memory
		sta $14
		lda #$05
		sta $15
		ldy #00
		
		lda #$cc//Set zp pointer for screen memory
		sta $16
		lda #$05
		sta $17
		ldy #00
		
		lda #$4e//Set zp pointer for screen memory
		sta $18
		lda #$06
		sta $19
		ldy #00
		
	draw_launched_loop:
		lda ($02), y//Load and store character
		sta ($12), y
		
		lda ($04), y
		sta ($14), y
		
		lda ($06), y
		sta ($16), y
		
		lda ($08), y
		sta ($18), y
		iny
		cpy #130
		bne draw_launched_loop
		
		//Increment 
		
		rts
		
		
	
missile_launched_text_usa: 
.byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$60,$60,$64,$60,$60,$60,$64,$00,$00,$60,$64,$60,$64,$60,$64,$00,$00,$60,$64,$00,$00,$60,$64,$60,$64,$60,$60,$60,$60,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$60,$60,$00,$60,$60,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$60,$60,$00,$60,$00,$60,$60,$60,$60,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$60,$60,$00,$60,$60,$60,$00,$00,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$60,$60,$00,$00,$00,$60,$60,$60,$60,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$60,$60,$00,$60,$60,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$60,$60,$00,$60,$00,$60,$60,$60,$60,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$60,$60,$00,$00,$00,$60,$00,$60,$61,$60,$00,$00,$61,$60,$00,$60,$61,$60,$00,$00,$61,$60,$61,$60,$61,$60,$60,$60,$60,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
.byte $60,$60,$60,$00,$00,$63,$60,$64,$00,$00,$60,$64,$00,$00,$60,$64,$00,$00,$60,$64,$00,$00,$60,$64,$00,$00,$60,$64,$00,$61,$60,$00,$00,$63,$60,$60,$00,$60,$60,$60
.byte $60,$60,$60,$00,$60,$00,$60,$00,$60,$60,$60,$60,$00,$60,$60,$00,$60,$60,$60,$00,$60,$60,$60,$60,$00,$60,$60,$00,$60,$60,$60,$00,$60,$00,$60,$60,$00,$60,$60,$60
.byte $60,$60,$60,$00,$60,$00,$60,$00,$61,$60,$60,$60,$00,$60,$60,$00,$61,$60,$60,$00,$60,$60,$60,$60,$00,$60,$60,$00,$61,$60,$60,$00,$60,$00,$60,$60,$61,$60,$60,$60
.byte $60,$60,$60,$00,$60,$00,$60,$00,$60,$60,$60,$60,$00,$60,$60,$00,$60,$60,$60,$00,$60,$60,$60,$60,$00,$60,$60,$00,$60,$60,$60,$00,$60,$00,$60,$60,$60,$60,$60,$60
.byte $60,$60,$60,$00,$00,$61,$60,$00,$00,$61,$60,$60,$61,$60,$60,$00,$00,$61,$60,$00,$00,$61,$60,$60,$61,$60,$60,$00,$00,$61,$60,$00,$00,$61,$60,$60,$00,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60

missile_launched_text_ussr: 
.byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$64,$00,$00,$60,$60,$64,$00,$60,$64,$00,$61,$60,$64,$00,$00,$60,$64,$60,$00,$60,$64,$60,$60,$60,$64,$60,$64,$67,$64,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$00,$60,$00,$60,$60,$00,$00,$60,$00,$60,$60,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$60,$60,$00,$60,$00,$60,$00,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$62,$00,$00,$60,$64,$00,$00,$60,$00,$00,$60,$60,$00,$00,$61,$60,$00,$00,$00,$60,$00,$00,$00,$60,$00,$60,$00,$64,$00,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$64,$00,$00,$60,$00,$60,$00,$60,$00,$60,$60,$60,$00,$60,$60,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$61,$00,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$00,$60,$00,$60,$61,$00,$62,$60,$00,$00,$61,$60,$00,$60,$60,$60,$00,$60,$61,$60,$00,$00,$61,$60,$00,$60,$00,$60,$00,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$60,$60,$00,$00,$00,$60,$64,$00,$00,$60,$64,$00,$00,$60,$00,$60,$00,$60,$64,$00,$00,$60,$00,$60,$64,$60,$00,$60,$60,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$60,$60,$00,$60,$00,$60,$00,$60,$60,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$00,$00,$60,$00,$00,$00,$60,$00,$60,$00,$60,$00,$00,$00,$60,$00,$60,$60,$60,$00,$00,$60,$60,$61,$60,$60,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$60,$60,$00,$60,$00,$60,$60,$60,$00,$60,$00,$60,$60,$60,$60,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$60,$60,$00,$00,$61,$60,$00,$60,$61,$60,$00,$60,$61,$60,$00,$00,$61,$60,$00,$00,$61,$60,$00,$60,$61,$60,$00,$60,$60,$60,$60,$60,$60,$60
.byte $60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60,$60


init_seed_0: .byte $fa
init_seed_1: .byte $ae
init_seed_2: .byte $34
init_seed_3: .byte $1f
init_seed_4: .byte $92
seed0: .byte $fa
seed1: .byte $ae
seed2: .byte $34
seed3: .byte $34
seed4: .byte $34

seeded_random: .byte $00
.macro InitSeededRandomFromA()
{
	jsr init_seeded_rnd
}
init_seeded_rnd:
	adc init_seed_0
	sta seed2
	ror
	sbc init_seed_1
	sta seed1
	rol
	adc init_seed_2
	sta seed0
	ror
	asl
	sec
	sbc init_seed_3
	sta seed4
	eor init_seed_4
	sta seed3
	sta seeded_random
	rts
inc_seeded_rnd:
	lda seeded_random
	adc seed1
	eor seed3
	sta seed2
	ror
	sec
	sbc seed1
	clc
	adc seed2
	sta seed4
	adc seed4
	eor seed2
	sta seed0
	clc
	adc seed1
	sec
	sbc seed0
	sta seed3
	adc seed4
	eor seed3
	clc
	adc seed1
	sta seed1
	ror
	sta seeded_random
	rts
	
.macro InitSeededRandom(){
	jsr init_seeded_rnd
}
	
.macro IncSeededRandom(){
	jsr inc_seeded_rnd
}



_sub_inc_set_rnd:
	IncSeededRandom();
	and #%00000111
	clc
	adc #112
	rts


.macro DrawStarfield()
{
	ldx #00
	loop_draw_starfield:
		jsr _sub_inc_set_rnd
		sta $0400, x
		jsr _sub_inc_set_rnd
		sta $0500, x
		jsr _sub_inc_set_rnd
		sta $0600, x
		inx
		cpx #00
		bne loop_draw_starfield
		
		//40 long loops for the earth
		ldx #00
		
		loop_draw_cloud_char:
			lda #$60
			sta $0720, x
			lda #$06
			sta $db20, x
			inx
			cpx #202
			bne loop_draw_cloud_char
		
		//Draw the individual curve parts
		
		ldx #00
		ldy #39
		loop_draw_curve_0:
			lda #$6d
			sta $0720, x
			sta $0720, y
			inx
			dey
			cpx #02
			bne loop_draw_curve_0
			
		ldx #00
		ldy #35
		loop_draw_curve_1:
			lda #$6c
			sta $0722, x
			sta $0722, y
			inx
			dey
			cpx #03
			bne loop_draw_curve_1
			
		ldx #00
		ldy #29
		loop_draw_curve_2:
			lda #$6b
			sta $0725, x
			sta $0725, y
			inx
			dey
			cpx #04
			bne loop_draw_curve_2
			
		ldx #00
		ldy #21
		loop_draw_curve_3:
			lda #$6a
			sta $0729, x
			sta $0729, y
			inx
			dey
			cpx #05
			bne loop_draw_curve_3		
}

