.pc=$0801
:BasicUpstart(main_start)

*=$2000
#import "char_map.asm"

*=$4000
main_start:
		InitSeededRandom();
		
		ClearSID();
		ConfigEnv0($0e, $00);
		ConfigEnv1($06, $00);
		ConfigEnv2($07, $00);
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
var_intro_text_loc_2: .text "Ionosphere, Pacific Ocean"
										 
var_war_text_0: .text "Immediate Casualties"
var_war_stats_0: .text "2,734,532,342"              
var_war_text_1: .text "Civilisation Prospects"
var_war_stats_1: .text "FUCKED"

#import "sound.asm"
#import "intro.asm"

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

	PlayVoice(0, $01, $06, 0);
	ConfigEnv2($00, $00);
	ConfigEnv1($0c, $00);
	PlayVoice(1, $f1, $11, 0);
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
