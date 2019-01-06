		
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
		WriteString(15, 7, 8, var_war_stats_1, 1);
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
	jsr fullscreen_explosion
	jsr fullscreen_explosion
	jsr fullscreen_explosion
}

var_static_colours: .byte $0f, $01, $0a, $0b

fullscreen_explosion:
		IncSeededRandom();
		and #$04
		tax
		lda var_static_colours, x
		sta $d020
		jmp fullscreen_explosion