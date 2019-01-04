		
intro_start:
		lda #00               
		sta $d020
		sta $d021
		
		
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
		lda #00
		sta $d015	
		lda #01
		sta $d020
		sta $d021
		ClearScreen(0, 2);
		CycleDelay();
		jsr flash_black
		CycleDelay();
		jsr flash_white
		CycleDelay();
		jsr flash_black
		CycleDelay();
		jsr flash_white
		CycleDelay();
		jsr flash_black
		CycleDelay();
		jsr flash_white
		CycleDelay();
		jsr flash_black
		lda #02
		sta $d020
		sta $d021
		CycleDelay();
		CycleDelay();
		CycleDelay();
		WriteString(10, 1, 20, var_war_text_0, 0);
		CycleDelay();
		CycleDelay();
		CycleDelay();
		WriteString(13, 3, 13, var_war_stats_0, 0);
		CycleDelay();
		CycleDelay();
		CycleDelay();
		WriteString(9, 5, 22, var_war_text_1, 0);
		CycleDelay();
		CycleDelay();
		CycleDelay();
		WriteString(15, 7, 8, var_war_stats_1, 1);
		CycleDelay();
		CycleDelay();
		CycleDelay();
		CycleDelay();
		CycleDelay();
		CycleDelay();
		
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
