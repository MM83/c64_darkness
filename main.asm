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
		
		jsr intro_start
		jsr menu_start
		
	main_start_await_fire:
		lda $dc01
		and #$10//Test for fire button (isolate in this fashion)
		beq start_game
		jmp main_start_await_fire
		
start_game:
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
	HomeScreen();	
	jmp *

#import "sound.asm"
#import "intro.asm"

.macro HomeScreen(){
	jsr home_screen
}

home_screen:
	ClearScreen(0, 0);

	rts
