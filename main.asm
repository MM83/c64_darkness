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
var_war_stats_1: .text "DARKNESS"

//#import "intro.asm"

		
intro_start:
		lda #00               
		sta $d020
		sta $d021
		
		/*
		
		
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
		*/
		
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
		WriteString(15, 7, 8, var_war_stats_1, 1);
		CycleDelay($af);
		CycleDelay($af);
		CycleDelay($af);
		CycleDelay($af);
		CycleDelay($af);
		CycleDelay($af);
		
		rts

		
.macro FullscreenExplosion(){
	jsr fullscreen_explosion
}

explosion_colours: .byte $00, $01, $02, $07

fullscreen_explosion:

	lda #00
	sta $d015	
	lda #01
	sta $d020
	sta $d021
	ClearScreen(0, 2);
	CycleDelay($5f);
	jsr flash_black
	CycleDelay($5f);
	jsr flash_white
	CycleDelay($5f);
	jsr flash_black
	CycleDelay($5f);
	jsr flash_white
	CycleDelay($5f);
	jsr flash_black
	CycleDelay($5f);
	jsr flash_white
	CycleDelay($5f);
	jsr flash_black

	rts
	
			
flash_black:
		lda #00
		sta $d020
		sta $d021
		rts
flash_white:
		lda #01
		sta $d020
		sta $d021
		rts


// =================================================== END INTRO.ASM

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
	lda #04
	sta $d020
	sta $d021
	rts



#import "utils.asm"
//#import "missiles.asm"

		
var_missile_0_vel: .byte $19
var_missile_1_vel: .byte $08
var_missile_2_vel: .byte $16
var_missile_3_vel: .byte $0a


.macro MoveMissiles()
{
	jsr move_missile_0
	jsr move_missile_1
	jsr move_missile_2
	jsr move_missile_3
}

//MISSILE 0

move_missile_0:
	lda $d000
	clc
	adc var_missile_0_vel
	sta $d000
	bcs missile_0_switch
	move_missile_0_rtn:
	rts
missile_0_switch:
	lda $d010
	eor #%00000001
	sta $d010
	jmp move_missile_0_rtn

missile_0_new_y:
	jmp move_missile_0_rtn



//MISSILE 1

move_missile_1:
	lda $d002
	clc
	adc var_missile_1_vel
	sta $d002
	bcs missile_1_switch
	move_missile_1_rtn:
	rts
missile_1_switch:
	lda $d010
	eor #%00000010
	sta $d010
	jmp move_missile_1_rtn

//MISSILE 2

move_missile_2:
	lda $d004
	sec
	sbc var_missile_2_vel
	sta $d004
	bcc missile_2_switch
	move_missile_2_rtn:
	rts
missile_2_switch:
	lda $d010
	eor #%00000100
	sta $d010
	jmp move_missile_2_rtn

//MISSILE 3

move_missile_3:
	lda $d006
	sec
	sbc var_missile_3_vel
	sta $d006
	bcc missile_3_switch
	move_missile_3_rtn:
	rts
missile_3_switch:
	lda $d010
	eor #%00001000
	sta $d010
	jmp move_missile_3_rtn


	
.macro SetMissileSprites()
{

		//Set right missile x flag to true (past 256 x)
		lda #%00001100
		sta $d010

		// Sprites, turn on multicolour
		lda #%00111111
		sta $d01c
		
		// Extra colours for sprites (white and light grey)
		lda #$01
		sta $d025
		lda #$0f
		sta $d026
		
		// Colours
		
		// USSR
		lda #$02
		sta $d027
		sta $d028
		
		// USA
		lda #$06
		sta $d029
		sta $d02a
		
		
		// LAND
		lda #$05
		sta $d02b
		sta $d02c
		
		lda #$c0								// Sprite located at 3000 (v * $40)
		sta $07f8								// Store in sprite pointer 0
		sta $07f9								// Store in sprite pointer 1
		lda #$c2								// Sprite located at 3000 (v * $40)
		sta $07fa								// Store in sprite pointer 2
		sta $07fb								// Store in sprite pointer 3
		lda #$c4								// Sprite located at 3000 (v * $40)
		sta $07fc								// Store in sprite pointer 2
		sta $07fd								// Store in sprite pointer 3
		
		
		lda #%00111111							// Turn on sprites
		sta $d015
		
		
		lda #80//sprite 0 y
		sta $d001
		
		lda #140//sprite 1 y
		sta $d003
		
		lda #20//sprite 2 x, y
		sta $d004
		lda #120
		sta $d005
		
		lda #20//sprite 3 x, y
		sta $d006
		lda #160
		sta $d007
		
		lda #16//sprite 4 x, y
		sta $d008
		lda #220
		sta $d009
		
		lda #254//sprite 7 x, y
		sta $d00a
		lda #235
		sta $d00b
		
		//set the land sprites and two missiles to be twice the size:
		lda #%00110101
		sta $d01d
		sta $d017
		
		//put the last land sprite at the far end
			
			
}


