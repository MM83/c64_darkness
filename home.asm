.macro HomeScreen(){
	jsr home_screen
}


home_screen:
	ConfigEnv0($06, $00);
	ClearScreen(0, 0);
	DrawStatsHeader();
	DrawPlayerStats();
	DrawHomeOptions();
	HomeRuntime();
	rts

.macro ResetPlayerStats()
{
	jsr reset_player_stats
}

reset_player_stats:
	//lda #96
	lda #53
	sta var_stat_health
	sta var_stat_immune
	sta var_stat_morale
	sta var_stat_hunger
	sta var_stat_thirst
	sta var_stat_energy
	rts

.macro DrawPlayerStats()
{
	jsr draw_player_stats
}

draw_player_stats:
	rts
	
	
.macro DrawHomeOptions()
{
	jsr draw_home_options
}	


var_last_joystick: .byte $00

var_home_selected_option: .byte $00

var_home_instr_text: .text "UP/DOWN to choose option, FIRE to select"


draw_home_options:
	//TODO - These strings are all the same length, this could be optimised
	ClearLowerScreen();
	WriteString(0, 7, 12, var_home_option_construct, 12);
	WriteString(0, 8, 12, var_home_option_nourish, 12);
	WriteString(0, 9, 12, var_home_option_scavenge, 12);
	WriteString(0, 10, 12, var_home_option_inventory, 12);
	WriteString(0, 11, 12, var_home_option_sleep, 12);
	WriteString(0, 13, 40, var_home_instr_text, 7);
	
	//Now we've written out the fucking text, draw the selected option
	
	//Load the option offset
	ldx var_home_selected_option
	
	//Load left bracket character
	lda #$3e
	sta $0518, x
	//Load left bracket character
	lda #$3c
	sta $0522, x
	//Paint chars yellow
	lda #07
	sta $d922, x 
	sta $d918, x
	
	rts
	
.macro HomeRuntime(){
	jmp home_runtime
}
	

home_runtime:
	lda $dc01					// Load joy values
	cmp var_last_joystick		// Compare to previous
	sta var_last_joystick		// Store values
	bne home_runtime_joy_update	// If changed, update
	jmp home_runtime

home_runtime_joy_update:
	lda $dc01
	and #$02 					// Down
	beq home_inc_option
	lda $dc01
	and #$01 					// Up
	beq home_dec_option
	lda $dc01
	and #$10 					// Fire
	beq home_select_option
	jmp home_runtime

home_select_option:
	ClearLowerScreen();
	PlayVoice(0, $01, $10, 0);
	jmp home_next_option

// Increment the home option

home_option_change_finish:
	sta var_home_selected_option
	DrawHomeOptions();
	jmp home_runtime


home_inc_option:
	PlayVoice(0, $01, $08, 0);
	lda var_home_selected_option
	clc
	adc #40
	cmp #200
	beq reset_home_inc_option
	jmp home_option_change_finish
	
reset_home_inc_option:
	lda #00
	jmp home_option_change_finish
	
// Decrement the home option
	
home_dec_option:
	PlayVoice(0, $01, $08, 0);
	lda var_home_selected_option
	sec
	sbc #40
	bcc reset_home_dec_option
	jmp home_option_change_finish
	
reset_home_dec_option:
	lda #160
	jmp home_option_change_finish
	
.macro ClearLowerScreen(){
	jsr clear_lower_screen
}

clear_lower_screen:
	ldx #00
	txa
	clear_lower_screen_loop:
	sta $0500, x
	sta $0600, x
	sta $0700, x
	inx
	cpx #00
	bne clear_lower_screen_loop
	rts