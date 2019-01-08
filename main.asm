.pc=$0801
:BasicUpstart(main_start)

#import "sprites.asm"
*=$2000
#import "char_map.asm"

#import "utils.asm"
#import "missiles.asm"

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
	
	CycleDelay($ff);
	CycleDelay($ff);
	WriteString(14, 1, 12, var_intro_text_date_1, 1);
	CycleDelay($ff);
	CycleDelay($ff);
	WriteString(12, 3, 17, var_intro_text_loc_3, 1);
	CycleDelay($ff);
	CycleDelay($ff);
	ClearScreen(0, 0);
	
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


//Each of the guide text strings is of equal length, wastes a few bytes here but saves more by allowing for a single method to write
//Them all
var_hint_construct: 	.text "Protect home against raiders and rodents"
var_hint_nourish: 		.text "Eat, drink, medicate and intoxicate     "
var_hint_scavenge: 	.text "Venture outside for supplies and sundry "
var_hint_inventory: 	.text "Examine your current supply stash       "
var_hint_sleep: 		.text "Lower your guard and get some rest!     "


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
	
//	CycleDelay($af);//Delay prevents the fire button from triggering, needs a better solution
	
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
	jmp *
home_page_nourish:
	ldx #<var_home_option_nourish
	ldy #>var_home_option_nourish
	jsr draw_next_page_title
	jmp *
home_page_scavenge:
	ldx #<var_home_option_scavenge
	ldy #>var_home_option_scavenge
	jsr draw_next_page_title
	jmp *
home_page_inventory:
	ldx #<var_home_option_inventory
	ldy #>var_home_option_inventory
	jsr draw_next_page_title
	jmp *
home_page_sleep:
	ldx #<var_home_option_sleep
	ldy #>var_home_option_sleep
	jsr draw_next_page_title
	jmp *
	
draw_next_page_title:		// This is used to draw the next title, assumes that A contains the start address of the text
	
	stx $03 //Store hi and lo of address in zero page registers
	sty $04
	ldy #00 // Set counter to zero
	ldx #01
	draw_next_page_title_loop:
		lda ($03), y
		sta $04ef, y
		txa
		sta $d8ef, y
		iny
		cpy #11
		bne draw_next_page_title_loop
	rts

