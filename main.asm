.pc=$0801
:BasicUpstart(main_start)

*=$2000
#import "char_map.asm"

*=$8000
main_start:
		InitSeededRandom();
		// set screen memory ($0400) and charset bitmap offset ($2000)
		lda #$18//Lower byte controls the address, somehow
		sta $d018
		ClearScreen(0, 0);
		jsr intro_start
		jsr menu_start
		jmp *
		
		
var_intro_text_date_0: .text "Oct 04, 1986"
var_intro_text_date_1: .text "Oct 05, 1986"
var_intro_text_loc_0: .text "NORAD, Colorado, USA"
var_intro_text_loc_1: .text "PCBH, Moscow, Soviet Union"
var_intro_text_loc_2: .text "Ionosphere, Atlantic Ocean"

var_war_text_0: .text "Immediate Casualties"
var_war_stats_0: .text "2,734,532,342"              
var_war_text_1: .text "Civilisation Prospects"
var_war_stats_1: .text "FUCKED"

//#import "intro.asm"
//================================================================================ INTRO





		
intro_start:	
		lda #00               
		sta $d020
		sta $d021
		
		CycleDelay($af);
		CycleDelay($af);
		WriteString(14, 1, 12, var_intro_text_date_0, 1);
		CycleDelay($af);
		CycleDelay($af);
		WriteString(10, 3, 20, var_intro_text_loc_0, 1);
		CycleDelay($af);
		CycleDelay($af);
		ClearScreen(0, 0);
		
		DrawLaunchedTextUSA();
		
		lda #00
		sta $20
		
		intro_flash_loop:
			CycleDelay($af);
			SetCharColourWholeScreen(5);
			CycleDelay($af);
			SetCharColourWholeScreen(0);
			
			ldx $20        
			inx
			stx $20
			cpx #3
			bne intro_flash_loop
			
		ClearScreen(0, 0);
		CycleDelay($af);
		CycleDelay($af);
		WriteString(14, 1, 12, var_intro_text_date_0, 1);
		CycleDelay($af);
		CycleDelay($af);
		WriteString(7, 3, 26, var_intro_text_loc_1, 1);
		CycleDelay($af);
		CycleDelay($af);
		SetCharColourWholeScreen(0);
		ClearScreen(0, 0);
		DrawLaunchedTextUSSR();
		lda #00
		sta $20
		intro_flash_loop_2:
			CycleDelay($af);
			SetCharColourWholeScreen(2);
			CycleDelay($af);
			SetCharColourWholeScreen(0);
			ldx $20
			inx
			stx $20
			cpx #3
			bne intro_flash_loop_2
		
		ClearScreen(0, 1);
		CycleDelay($af);
		CycleDelay($af)
		WriteString(14, 1, 12, var_intro_text_date_0, 1);
		CycleDelay($af);
		CycleDelay($af);
		WriteString(7, 3, 26, var_intro_text_loc_2, 1);
		CycleDelay($af);
		CycleDelay($af);
		SetSpace();
		SetMissileSprites();
		
		//Missile animation
		ldx #00
		ldy #00
		
		lda #00
		sta $30
		
		loop_missile_x:
			inx
			cpx #200                            
			bne loop_missile_x
			
		ldx #00
		iny
		cpy #20
		bne loop_missile_x
		
		ldy $30//Check if missiles have run out of time
		iny
		sty $30
		cpy #120
		beq end_missiles 
		
		ldy #00
		MoveMissiles();
		jmp loop_missile_x
		
			
		end_missiles:	
			
		//Turn off all sprites and make screen white
		
		
		
		FullscreenExplosion();
		
		lda #02
		sta $d020
		sta $d021
		CycleDelay($af);
		CycleDelay($af);
		CycleDelay($af);
		WriteString(10, 1, 20, var_war_text_0, 0);
		CycleDelay($af);
		CycleDelay($af);
		CycleDelay($af);
		WriteString(13, 3, 13, var_war_stats_0, 0);
		CycleDelay($af);
		CycleDelay($af);
		CycleDelay($af);
		WriteString(9, 5, 22, var_war_text_1, 0);
		CycleDelay($af);
		CycleDelay($af);
		CycleDelay($af);
		WriteString(17, 7, 6, var_war_stats_1, 1);
		CycleDelay($af);
		CycleDelay($af);
		CycleDelay($af);
		CycleDelay($af);
		CycleDelay($af);
		CycleDelay($af);
		
		rts

		
.macro FullscreenExplosion(){

	lda #00
	sta $d015			// Turn off all sprites
	ClearScreen(0, 2);	// Empty screen
	jsr fullscreen_explosion
}

var_static_colours: .byte $00, $01, $0b, $0c



fullscreen_explosion:
		lda #$00
		sta $10 // count_lo
		sta $11 // count_hi
		fullscreen_explosion_loop:
		IncSeededRandom();
		
		and #%00000011
		tax
		lda var_static_colours, x
		sta $d020
		sta $d021
		ldy $10
		iny
		sty $10
		cpy #$40
		beq inc_fs_exp_hi
		jmp fullscreen_explosion_loop

inc_fs_exp_hi:
		ldy $11
		iny
		sty $11
		cpy #$40
		bne fullscreen_explosion_loop
		rts
		




//================================================================================ END INTRO

*=$3000

sprite_1:
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $55,$55,$60,$6a,$55,$64,$6a,$55
.byte $65,$6a,$55,$67,$55,$55,$6c,$ff
.byte $ff,$e0,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$82

*=$3080

sprite_2:
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$25,$55,$5b,$65,$55
.byte $5b,$65,$55,$5b,$2f,$ff,$fb,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$86

*=$3100

sprite_3:
.byte $8a,$00,$20,$2a,$a0,$a0,$2a,$a8
.byte $a8,$0a,$aa,$aa,$0a,$aa,$aa,$0a
.byte $aa,$aa,$0a,$aa,$aa,$2a,$aa,$a8
.byte $2a,$aa,$a0,$2a,$aa,$a0,$2a,$aa
.byte $a0,$2a,$aa,$a0,$0a,$aa,$a8,$0a
.byte $aa,$a8,$0a,$aa,$a8,$2a,$aa,$a8
.byte $2a,$aa,$a0,$0a,$aa,$a0,$02,$aa
.byte $80,$00,$2a,$00,$00,$0a,$00,$85
                            
*=$3180
menu_start:
	ClearScreen(0, 0);
	lda #00
	sta $d020
	lda #11
	sta $d021
	CycleDelay($ff)
	jsr write_title_text
	rts

#import "utils.asm"
#import "missiles.asm"

// TODO - THIS IS APPROXIMATE, THERE MAY BE MORE
*=$3800
title_chars_start:

.byte $00,$60,$60,$62,$00,$61,$60,$60,$00,$61,$60,$60,$00,$61,$00,$61,$00,$61,$00,$62,$00,$61,$60,$62,$00,$60,$60,$64,$00,$60,$60,$64,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$64,$00,$60,$61,$64,$00,$60,$62,$60,$00,$60,$62,$00,$00,$63,$60,$62,$00,$63,$60,$62,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$60,$00,$60,$00,$60,$60,$60,$00,$60,$60,$62,$00,$60,$63,$62,$00,$60,$63,$60,$00,$60,$00,$00,$00,$00,$00,$60,$00,$00,$00,$60,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$60,$60,$64,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$63,$00,$60,$00,$60,$00,$60,$60,$64,$00,$61,$60,$64,$00,$61,$60,$64,$00,$00,$00,$00,$00,$00,$00,$00

title_text_0: .text "Fire to Start"
title_text_1: .text "2019 Nick Stone"

write_title_text:
	ldx #00
	write_title_text_loop:
		lda title_chars_start, x
		sta $0428, x
		inx
		cpx #160
		bne write_title_text_loop
		
		CycleDelay($ff);
		WriteString(1, 23, 15, title_text_1, 0);
		CycleDelay($ff);
		WriteString(1, 6, 13, title_text_0, 1);
		
		rts
