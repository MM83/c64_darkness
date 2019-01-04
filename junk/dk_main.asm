
#import "../libs/screen_clear_with_char.asm"
#import "../libs/write_string.asm"

.pc=$0801
:BasicUpstart($810)
.pc=$0810

lda #00
sta $d020
sta $d021

lda #%00011000
sta $d016
jsr draw_borders
jsr draw_map

jmp *

draw_borders:
	ClearScreen(32, 4);
	
	WriteString(11, 2, 18, text_title, 2);
	ldx #00
	ldy #00
	
	// ========== BORDER ROW 0 CHAR POS
	lda #$00
	sta $04
	lda #$04
	sta $05
	// ========== BORDER ROW 1 CHAR POS
	lda #$c0
	sta $06
	lda #$07
	sta $07
	
	// ========== BORDER ROW 0 COL POS
	lda #$00
	sta $08
	lda #$d8
	sta $09
	// ========== BORDER ROW 1 COL POS
	lda #$c0
	sta $0a
	lda #$db
	sta $0b
	
	draw_rows_loop:
		lda #67
		sta ($04), y
		sta ($06), y
		lda #13
		sta ($08), y
		sta ($0a), y
		iny
		cpy #40
		bne draw_rows_loop 
		
		
		
	// ========== BORDER COL 0 CHAR POS
	lda #$00
	sta $04
	lda #$04
	sta $05
	// ========== BORDER COL 1 CHAR POS
	lda #$c0
	sta $06
	lda #$07
	sta $07
	
	// ========== BORDER COL 0 COL POS
	lda #$00
	sta $08
	lda #$d8
	sta $09
	// ========== BORDER COL 1 COL POS
	lda #$c0
	sta $0a
	lda #$db
	sta $0b
		
		
		
	rts



draw_map:

	ldx #00
	ldy #00
	

	lda #$aa
	sta $04
	lda #$04
	sta $05
	lda #$aa
	sta $06
	lda #$d8
	sta $07
		
	loop_draw_map:
		lda #$80
		sta ($04), y
		lda #15
		sta ($06), y
		iny
		cpy #20
		bne loop_draw_map
		
		//If we've fallen through here, increment The memory position
		lda $04
		clc
		adc #40
		sta $04
		clc
		lda $06
		adc #40
		sta $06
		bcs draw_map_inc_hi
	draw_map_bcs_rtn:
		inx
		ldy #00
		cpx #19
		bne loop_draw_map
		rts
		
	draw_map_inc_hi:
		inc $05
		inc $07
		jmp draw_map_bcs_rtn

	
	
*=$9000

text_title: .text "shungro - the game"

map_x: .byte $00
map_y: .byte $00

map_defs:
.fill $30, 21