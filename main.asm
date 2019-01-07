.pc=$0801
:BasicUpstart(main_start)

#import "sprites.asm"
*=$2000
#import "char_map.asm"
*=$4000
main_start:
		InitSeededRandom();
		ClearSID();
		// set screen memory ($0400) and charset bitmap offset ($2000)
		lda #$18//Lower byte controls the address, somehow
		sta $d018
		ClearScreen(0, 0);
		//Disable the keyboard, see if this makes the fucking joysticks work
		lda #$e0
		sta $dc02
		
		//NOTE - Make sure these are both called in the full game
	//	jsr intro_start
		jsr menu_start
		
	main_start_await_fire:
		lda $dc01
		and #$10//Test for fire button (isolate in this fashion)
		beq start_game
		jmp main_start_await_fire
		
start_game:
	jsr game_start_title
	ResetPlayerStats();
	HomeScreen();	
	jmp *
	
game_start_title:

	ClearScreen(0, 0);
	lda #00
	sta $d020
	sta $d021
	/*
	CycleDelay($ff);
	CycleDelay($ff);
	WriteString(14, 1, 12, var_intro_text_date_1, 1);
	CycleDelay($ff);
	CycleDelay($ff);
	WriteString(12, 3, 17, var_intro_text_loc_3, 1);
	CycleDelay($ff);
	CycleDelay($ff);
	ClearScreen(0, 0);
	*/
	rts

#import "sound.asm"
#import "intro.asm"

.macro HomeScreen(){
	jsr home_screen
}


home_screen:
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


var_home_selected_option: .byte $00


draw_home_options:
	WriteString(1, 7, 7, var_home_option_fortify, 12);
	WriteString(1, 8, 7, var_home_option_nourish, 12);
	WriteString(1, 9, 8, var_home_option_scavenge, 12);
	WriteString(1, 10, 9, var_home_option_inventory, 12);
	WriteString(1, 11, 5, var_home_option_sleep, 12);
	
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
	
var_last_joystick: .byte $00

home_runtime:
	lda $dc01					// Load joy values
	cmp var_last_joystick		// Compare to previous
	sta var_last_joystick		// Store values
	bne home_runtime_joy_update	// If changed, update
	home_runtime_rtn:
	jmp home_runtime
	
home_runtime_joy_update:
	inc $d020
	lda var_last_joystick
	and #01
	beq home_runtime_inc_option
	lda var_last_joystick
	and #02
	beq home_runtime_dec_option
	jmp home_runtime

home_runtime_inc_option:
	lda var_last_joystick
	clc
	adc #40
	sta var_last_joystick
	DrawHomeOptions();
	jmp home_runtime_rtn

home_runtime_dec_option:
	lda var_last_joystick
	clc
	adc #40
	sta var_last_joystick
	DrawHomeOptions();
	jmp home_runtime_rtn
