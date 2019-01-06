
		
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


