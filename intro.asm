		
		
//Voice 0 - Misc notes
//Voice 1 - Beeps
//Voice 2 - Lead notes


var_intro_text_date_0: .text "Oct 04, 1986"
var_intro_text_date_1: .text "Oct 05, 1986"
var_intro_text_loc_0: .text "NORAD, Colorado, USA"
var_intro_text_loc_1: .text "PCBH, Moscow, Soviet Union"
var_intro_text_loc_2: .text "Ionosphere, Pacific Ocean"
var_intro_text_loc_3: .text "Harlow, Essex, UK"
										 
var_war_text_0: .text "Immediate Casualties"
var_war_stats_0: .text "2,734,532,342"              
var_war_text_1: .text "Civilisation Prospects"
var_war_stats_1: .text "FUCKED"
		
intro_start:	
		lda #00               
		sta $d020
		sta $d021
		
		ConfigEnv0($0e, $00);
		ConfigEnv1($06, $00);
		ConfigEnv2($07, $00);
		
		PlayVoice(0, $01, $06, 0);
		
		//PlayVoice(2, 37, 47, 0);
		
		
		
		CycleDelay($ff);
		CycleDelay($ff);
		WriteString(14, 1, 12, var_intro_text_date_0, 1);
		PlayVoice(2, $01, $18, 0);
		CycleDelay($ff);
		CycleDelay($ff);
		WriteString(10, 3, 20, var_intro_text_loc_0, 1);
		PlayVoice(2, $01, $18, 0);
		CycleDelay($ff);
		CycleDelay($ff);
		ClearScreen(0, 0);
		PlayVoice(2, $01, $18, 0);
		
		DrawLaunchedTextUSA();
		
		lda #00
		sta $20
		
		intro_flash_loop:
			CycleDelay($6f);
			PlayVoice(1, $01, $05, 1);
			SetCharColourWholeScreen(5);
			CycleDelay($6f);
			PlayVoice(1, $01, $05, 1);
			SetCharColourWholeScreen(0);
			
			ldx $20        
			inx
			stx $20
			cpx #6
			bne intro_flash_loop
			
			
		PlayVoice(0, $01, $07, 0);
			
		ClearScreen(0, 0);
		CycleDelay($ff);
		CycleDelay($ff);
		WriteString(14, 1, 12, var_intro_text_date_0, 1);
		PlayVoice(2, $01, $18, 0);
		CycleDelay($ff);
		CycleDelay($ff);
		WriteString(7, 3, 26, var_intro_text_loc_1, 1);
		PlayVoice(2, $01, $18, 0);
		CycleDelay($ff);
		CycleDelay($ff);
		SetCharColourWholeScreen(0);
		ClearScreen(0, 0);
		PlayVoice(2, $01, $18, 0);
		DrawLaunchedTextUSSR();
		lda #00
		sta $20
		
		
		ConfigEnv1($06, $00);
		
		intro_flash_loop_2:
			CycleDelay($6f);
			PlayVoice(1, $01, $18, 1);
			SetCharColourWholeScreen(2);
			CycleDelay($6f);
			PlayVoice(1, $01, $18, 1);
			SetCharColourWholeScreen(0);
			ldx $20
			inx
			stx $20
			cpx #6
			bne intro_flash_loop_2
			
			
		PlayVoice(0, $01, $06, 0);
		
		ClearScreen(0, 1);
		CycleDelay($ff);
		CycleDelay($ff)
		WriteString(14, 1, 12, var_intro_text_date_0, 1);
		PlayVoice(2, $01, $18, 0);
		CycleDelay($ff);
		CycleDelay($ff);
		WriteString(7, 3, 25, var_intro_text_loc_2, 1);
		PlayVoice(2, $01, $18, 0);
		CycleDelay($ff);
		CycleDelay($ff);
		
		PlayVoice(2, $01, $18, 0);
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
		
		
	
		CheckSatTick();//This method controls the timer on the satellite display
		
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
		
		
		ConfigEnv2($0f, $ff);
		PlayVoice(2, $01, $12, 3);
		FullscreenExplosion();
		PlayVoice(2, $00, $00, 0);
		
		
		ConfigEnv0($0e, $00);
		
		PlayVoice(0, $01, $06, 0);
		
		lda #02
		sta $d020
		sta $d021
		CycleDelay($ff);
		CycleDelay($ff);
		CycleDelay($ff);
		PlayVoice(2, $01, $18, 0);
		WriteString(10, 1, 20, var_war_text_0, 0);
		CycleDelay($ff);
		CycleDelay($ff);
		CycleDelay($ff);
		CycleDelay($ff);
		CycleDelay($ff);
		PlayVoice(2, $01, $11, 0);
		WriteString(13, 3, 13, var_war_stats_0, 1);
		CycleDelay($ff);
		CycleDelay($ff);
		CycleDelay($ff);
		PlayVoice(2, $01, $18, 0);
		WriteString(9, 5, 22, var_war_text_1, 0);
		CycleDelay($ff);
		CycleDelay($ff);
		CycleDelay($ff);
		CycleDelay($ff);
		CycleDelay($ff);
		PlayVoice(2, $01, $11, 0);
		WriteString(16, 7, 6, var_war_stats_1, 1);
		CycleDelay($ff);
		CycleDelay($ff);
		CycleDelay($ff);
		CycleDelay($ff);
		CycleDelay($ff);
		CycleDelay($ff);
		
		rts

var_sat_tick: .byte $00
var_sat_char: .byte $38

.macro CheckSatTick()
{
	jsr check_sat_tick
}
check_sat_tick:
	ldx var_sat_tick
	inx
	stx var_sat_tick
	cpx #40
	bne ret_sat_tick 
	
	ldx #00
	stx var_sat_tick
	ldx var_sat_char
	stx $0427
	inx
	jsr store_regs_zp
	PlayVoice(2, $01, $48, 0);
	jsr load_regs_zp
	stx var_sat_char
	rts	

ret_sat_tick:
	rts
	
store_regs_zp:
	sta $20
	stx $21
	sty $22
	rts
	
load_regs_zp:
	lda $20
	ldx $21
	ldy $22
	rts
		
.macro FullscreenExplosion(){

	lda #00
	sta $d015			// Turn off all sprites
	ClearScreen(0, 2);	// Empty screen
	jsr fullscreen_explosion
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
		

.macro SetSpace()
{
	ClearScreen(0, 1);
	SetCharColourWholeScreen(1);
	DrawStarfield();
	WriteString(0, 0, 40, var_basic_satellite_text, 13);
}      

var_basic_satellite_text: .text "SODSAT 01 LON 63.61 LAT -175.64 23:59:57"


// TODO - THIS IS APPROXIMATE, THERE MAY BE MORE
*=$3800
title_chars_start:

.byte $00,$60,$60,$62,$00,$61,$60,$60,$00,$61,$60,$60,$00,$61,$00,$61,$00,$61,$00,$62,$00,$61,$60,$62,$00,$60,$60,$64,$00,$60,$60,$64,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$64,$00,$60,$61,$64,$00,$60,$62,$60,$00,$60,$62,$00,$00,$63,$60,$62,$00,$63,$60,$62,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$60,$00,$60,$00,$60,$60,$60,$00,$60,$60,$62,$00,$60,$63,$62,$00,$60,$63,$60,$00,$60,$00,$00,$00,$00,$00,$60,$00,$00,$00,$60,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$60,$60,$64,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$63,$00,$60,$00,$60,$00,$60,$60,$64,$00,$61,$60,$64,$00,$61,$60,$64,$00,$00,$00,$00,$00,$00,$00,$00

title_text_0: .text "Fire to Start"
title_text_1: .text "2019 Chris Jones"

write_title_text:
	ldx #00
	write_title_text_loop:
		lda title_chars_start, x
		sta $0428, x
		inx
		cpx #160
		bne write_title_text_loop
		
		CycleDelay($ff);
		WriteString(1, 23, 16, title_text_1, 0);
		CycleDelay($ff);
		WriteString(1, 6, 13, title_text_0, 1);
		
		rts



menu_start:
	ConfigEnv0($0c, $00);
	ConfigEnv1($0e, $00);
	ConfigEnv2($cc, $00);
	PlayVoice(0, $01, $06, 0);
	PlayVoice(1, $f1, $11, 0);
	PlayVoice(2, $71, $11, 0);
	ClearScreen(0, 0);
	lda #00
	sta $d020
	lda #11
	sta $d021
	CycleDelay($ff)
	jsr write_title_text
	rts
