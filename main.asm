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
		jmp *
		
		
var_intro_text_date_0: .text "Oct 04, 1986"
var_intro_text_date_1: .text "Oct 05, 1986"
var_intro_text_loc_0: .text "NORAD, Colorado, USA"
var_intro_text_loc_1: .text "PCBH, Moscow, Soviet Union"
var_intro_text_loc_2: .text "Ionosphere, Atlantic Ocean"

		
intro_start:
		lda #00               
		sta $d020
		sta $d021
		/*
		CycleDelay();
		CycleDelay();
		WriteString(14, 1, 12, var_intro_text_date_0, 1);
		CycleDelay();
		CycleDelay();
		WriteString(10, 3, 20, var_intro_text_loc_0, 1);
		CycleDelay();
		CycleDelay();
		ClearScreen(0, 0);
		DrawLaunchedTextUSA();
		lda #00
		sta $20
		intro_flash_loop:
			CycleDelay();
			SetCharColourWholeScreen(5);
			CycleDelay();
			SetCharColourWholeScreen(0);
			
			ldx $20        
			inx
			stx $20
			cpx #3
			bne intro_flash_loop
			
		ClearScreen(0, 0);
		CycleDelay();
		CycleDelay();
		WriteString(14, 1, 12, var_intro_text_date_0, 1);
		CycleDelay();
		CycleDelay();
		WriteString(7, 3, 26, var_intro_text_loc_1, 1);
		CycleDelay();
		CycleDelay();
		SetCharColourWholeScreen(0);
		ClearScreen(0, 0);
		DrawLaunchedTextUSSR();
		lda #00
		sta $20
		intro_flash_loop_2:
			CycleDelay();
			SetCharColourWholeScreen(2);
			CycleDelay();
			SetCharColourWholeScreen(0);
			ldx $20
			inx
			stx $20
			cpx #3
			bne intro_flash_loop_2
		
			*/
		ClearScreen(0, 1);
		CycleDelay();
		CycleDelay()
		WriteString(14, 1, 12, var_intro_text_date_0, 1);
		CycleDelay();
		CycleDelay();
		WriteString(7, 3, 26, var_intro_text_loc_2, 1);
		CycleDelay();
		CycleDelay();
		SetSpace();
		SetMissileSprites();
		
		//Missile animation
		ldx #00
		ldy #00
		
		loop_missile_x:
			inx
			cpx #200
			bne loop_missile_x
			
		ldx #00
		iny
		cpy #20
		bne loop_missile_x
		ldy #00
		MoveMissiles();
		jmp loop_missile_x
			
		rts


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


#import "utils.asm"
#import "missiles.asm"
