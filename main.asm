.pc=$0801
:BasicUpstart(main_start)

#import "sprites.asm"
*=$2000
#import "char_map.asm"

#import "utils.asm"          
#import "missiles.asm"

#import "page_sleep.asm"

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
		jmp start_game // REMOVE THIS, TEMP JMP TO START WITHOUT ALL THE FUCKING AROUND
		jsr intro_start
		jsr menu_start
		
		
	main_start_await_fire:
		lda $dc01
		and #$10//Test for fire button (isolate in this fashion)
		beq start_game
		jmp main_start_await_fire
		
start_game:
	CycleDelay($30);//TODO - This is only here because I'm skipping the intro
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

//#import "home.asm"
	
// =============================================================================== HOME	
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
	lda #96
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
	DrawBlankStatBars();
	DrawStatBar(0);
	DrawStatBar(1);
	DrawStatBar(2);
	DrawStatBar(3);
	DrawStatBar(4);
	DrawStatBar(5);
	rts
	
.macro DrawBlankStatBars(){
	jsr draw_blank_stat_bars
}

draw_blank_stat_bars:
	lda #$78
	ldx #00
	draw_blank_stat_bars_loop:
		sta $0457, x
		sta $046c, x
		sta $047f, x
		sta $0494, x
		sta $04a7, x
		sta $04bc, x
		inx
		cpx #12
		bne draw_blank_stat_bars_loop
	rts
	
.macro DrawStatBar(bar){                                  
	//ZP 3/4 USED TO STORE BAR ADDRESS, 5 used to store value
	.if(bar == 0)
	{
		lda #$56
		sta $03
		lda var_stat_health
		sta $05
		
	}
	.if(bar == 1)
	{
		lda #$6b
		sta $03
		lda var_stat_immune
		sta $05
	}
	.if(bar == 2)
	{
		lda #$7e
		sta $03
		lda var_stat_morale
		sta $05
	}
	.if(bar == 3)
	{
		lda #$93
		sta $03
		lda var_stat_hunger
		sta $05
	}
	.if(bar == 4)
	{
		lda #$a6
		sta $03
		lda var_stat_thirst
		sta $05
	}
	.if(bar == 5)
	{
		lda #$bb
		sta $03
		lda var_stat_energy
		sta $05
	}
	jsr draw_stat_bar
	
}

draw_stat_bar:
	//All bars have the same hi byte:
	lda #$04
	sta $04
	
	//Reset the counters
	ldy #00
	ldx #00
	
	draw_stat_bar_loop:
		// X counts up with the actual points
		
		//Get the character to print
		txa //Transfer the x register
		and #%00000111
		beq draw_stat_inc_y
		draw_stat_inc_y_rtn:
		sta $07 //Store this value in zp 7
		lda #$79//Load the base character into memory
		clc
		adc $07
		
		sta ($03), y
		inx
		cpx $05
		bne draw_stat_bar_loop
	rts

draw_stat_inc_y:
	iny
	jmp draw_stat_inc_y_rtn


	
.macro DrawHomeOptions()
{
	jsr draw_home_options
}	



var_last_joystick: .byte $00

var_home_selected_option: .byte $00


//Each of the guide text strings is of equal length, wastes a few bytes here but saves more by allowing for a single method to write
//Them all
var_hint_construct: 	.text "Protect home against raiders and rodents"
var_hint_nourish: 		.text "Eat, drink, medicate and intoxicate     "
var_hint_scavenge: 	.text "Venture outside for supplies and sundry "
var_hint_inventory: 	.text "Examine your current supply stash       "
var_hint_sleep: 		.text "Lower your guard and get some rest!     "
var_hint_exercise: 		.text "Keep your health up with some exercise  "


draw_home_options:
	//TODO - These strings are all the same length, this could be optimised
	ClearLowerScreen();
	WriteString(0, 6, 12, var_home_option_construct, 12);
	WriteString(0, 7, 12, var_home_option_nourish, 12);
	WriteString(0, 8, 12, var_home_option_scavenge, 12);
	WriteString(0, 9, 12, var_home_option_inventory, 12);
	WriteString(0, 10, 12, var_home_option_sleep, 12);
	
	//Now we've written out the fucking text, draw the selected option
	
	//Load the option offset
	ldx var_home_selected_option
	
	//Load left bracket character
	lda #$3e
	sta $04f0, x
	//Load left bracket character
	lda #$3c
	sta $04fa, x
	//Paint chars yellow
	lda #07
	sta $d8fa, x 
	sta $d8f0, x
	
	//Use the x offset to write the information text out (all strings are 40 chars, so the offset should work)
	
	
	ldy #<var_hint_construct//Load and store the address for the first hint in zprs
	sty $03
	ldy #>var_hint_construct
	sty $04
	
	txa	// Move x increment into y for addressing mode
	tay
	ldx #00 //Reset x to use as zero-start counter
	
	draw_hint_loop:
		lda ($03), y
		sta $05e0, x
		lda #07
		sta $d9e0, x
		inx
		iny
		cpx #40
		bne draw_hint_loop
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

		
// ===================================================================== END HOME	
	
home_next_option:
	//TODO - This is the point where we work out what the fuck to display next
	
	lda $dc01
	and #$10
	beq home_next_option//Prevent advance until player has released fire
	
	lda var_home_selected_option
	
	cmp #00
	beq jmp_home_page_construct
	cmp #40
	beq jmp_home_page_nourish
	cmp #80
	beq jmp_home_page_scavenge
	cmp #120
	beq jmp_home_page_inventory
	cmp #160
	beq jmp_home_page_sleep
	
// jmp -> to get around the address diff limit for branch instructions	

jmp_home_page_construct:
	jsr home_page_construct
jmp_home_page_nourish:
	jsr home_page_nourish
jmp_home_page_scavenge:
	jsr home_page_scavenge
jmp_home_page_inventory:
	jsr home_page_inventory
jmp_home_page_sleep:
	jsr home_page_sleep
	
	
home_page_construct:
	ldx #<var_home_option_construct
	ldy #>var_home_option_construct
	jsr draw_next_page_title
	jsr draw_page_sleep
	HomeScreen();
home_page_nourish:
	ldx #<var_home_option_nourish
	ldy #>var_home_option_nourish
	jsr draw_next_page_title
	jsr draw_page_sleep
	HomeScreen();
	jmp *
home_page_scavenge:
	ldx #<var_home_option_scavenge
	ldy #>var_home_option_scavenge
	jsr draw_next_page_title
	jsr draw_page_sleep
	HomeScreen();
	jmp *
home_page_inventory:
	ldx #<var_home_option_inventory
	ldy #>var_home_option_inventory
	jsr draw_next_page_title
	jsr draw_page_sleep
	HomeScreen();
	jmp *
home_page_sleep:
	ldx #<var_home_option_sleep
	ldy #>var_home_option_sleep
	jsr draw_next_page_title
	jsr draw_page_sleep
	HomeScreen();
	jmp *
	
draw_next_page_title:		// This is used to draw the next title, assumes that A contains the start address of the text
	
	stx $03 //Store hi and lo of address in zero page registers
	sty $04
	ldy #00 // Set counter to zero
	ldx #07
	draw_next_page_title_loop:
		lda ($03), y
		sta $04ef, y
		txa
		sta $d8ef, y
		iny
		cpy #11
		bne draw_next_page_title_loop
	rts




//TODO - PUT IN CORRECT FILE, THIS IS ONLY FOR CONVENIENCE!

sleep_page_text_0: .text "For how many hours should you sleep?"
sleep_page_text_1: .text "1hrs  3hrs  5hrs  7hrs  9hrs  cancel"
sleep_page_current_time: .byte $00


sleep_cancel:
	rts
	
	
sleep_and_calculate:
	cpx #05 // Cancel
	beq sleep_cancel
	//x2-1 to get hour value
	inx
	txa
	asl//x2
	sec
	sbc #01
	sta $0400
	lda #01
	sta $d800
	jmp *

draw_page_sleep:
	lda #02
	sta sleep_page_current_time
	WriteString(2, 8, 36, sleep_page_text_0, 1);
	WriteString(2, 10, 36, sleep_page_text_1, 11);
	jsr draw_selected_sleep_time
	draw_page_sleep_loop_0:
		lda $dc01					// Load joy values
		cmp var_last_joystick		// Compare to previous
		sta var_last_joystick		// Store values
		bne sleep_runtime_joy_update	// If changed, update
		jmp draw_page_sleep_loop_0
	rts


sleep_runtime_joy_update:
	lda $dc01
	ldx sleep_page_current_time
	and #$02 					// Down
	beq sleep_inc_option
	lda $dc01
	and #$01 					// Up
	beq sleep_dec_option
	lda $dc01
	and #$10 					// Fire
	beq sleep_select_option
	jmp draw_page_sleep_loop_0

sleep_select_option:
	lda $dc01
	and #$10
	beq sleep_select_option//Prevent advance until player has released fire
	ldx sleep_page_current_time
	jsr sleep_and_calculate
	jmp *
	//rts
	
	
	
	
sleep_dec_option:
	cpx #00
	beq sleep_dec_zero
	txa
	sec
	sbc #01
	sta sleep_page_current_time
	jmp draw_page_sleep_loop_0
	
sleep_inc_option:
	cpx #00
	beq sleep_dec_zero
	txa
	clc
	adc #01
	sta sleep_page_current_time
	jmp draw_page_sleep_loop_0
	
sleep_dec_zero:
	ldx #05
	stx sleep_page_current_time
	jmp draw_page_sleep_loop_0
	
sleep_inc_five:
	ldx #00
	stx sleep_page_current_time
	jmp draw_page_sleep_loop_0

draw_selected_sleep_time:
	//First, colour the whole bar
	ldx #00
	lda #09
	
	draw_selected_sleep_time_loop_0:
		sta $d990, x
		inx
		cpx #38
		bne draw_selected_sleep_time_loop_0
		
		//Draw the selected option	
		ldx #05
		ldy sleep_page_current_time
		cpy #05//If it's cancel, needs to be a little longer
		beq draw_selected_sleep_time_extend_cancel
		
		draw_selected_sleep_time_loop_0_rtn:
			stx $10//Store the final character count in zp10
			// Work out the offset
			clc
			lda #00//The eventual value			
			ldx #00//The counter
			draw_selected_sleep_time_loop_1:
				cpx sleep_page_current_time//Check first off, in case it's zero
				beq draw_selected_colour
				adc #06
				inx
				jmp draw_selected_sleep_time_loop_1
				
	draw_selected_colour:
			tax
			adc $10//Add the length to the start position
			sta $10//Overwrite 
			lda #10
			draw_selected_colour_loop:
				sta $d990, x
				inx
				cpx $10
				bne draw_selected_colour_loop
			
	rts
		
draw_selected_sleep_time_extend_cancel:
	ldx #7
	jmp draw_selected_sleep_time_loop_0_rtn
	
	rts

