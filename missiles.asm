		
var_missile_vels: 	
.byte $05, $00, $07, $00, $06, $00, $08, $00
.byte $07, $00, $06, $00, $05, $00, $08, $00

.macro MoveMissiles()
{
	//Jump over the swap conditions for missile placement, at first
	jmp loop_missiles_start
	
	mor_switch:
	cpx #08
	beq loop_mor_sw_0
	cpx #10
	beq loop_mor_sw_1
	cpx #12
	beq loop_mor_sw_2
	cpx #14
	beq loop_mor_sw_3

	loop_mor_sw_0:
	ldy #%00010000
	jmp mor_switch_x
	
	loop_mor_sw_1:
	ldy #%00100000
	jmp mor_switch_x
	
	loop_mor_sw_2:
	ldy #%01000000
	jmp mor_switch_x
	
	loop_mor_sw_3:
	ldy #%10000000
	jmp mor_switch_x
	
	mor_switch_x:
	sty $04
	sta $10
	lda $d010
	eor $04
	sta $d010
	lda $10
	rts
	
	
	mol_switch:
	cpx #00
	beq loop_mol_sw_0
	cpx #02
	beq loop_mol_sw_1
	cpx #04
	beq loop_mol_sw_2
	cpx #06
	beq loop_mol_sw_3

	loop_mol_sw_0:
	ldy #%00000001
	jmp mol_switch_x
	
	loop_mol_sw_1:
	ldy #%00000010
	jmp mol_switch_x
	
	loop_mol_sw_2:
	ldy #%00000100
	jmp mol_switch_x
	
	loop_mol_sw_3:
	ldy #%00001000
	jmp mol_switch_x
	
	mol_switch_x:
	sty $04
	sta $10
	lda $d010
	eor $04
	sta $d010
	lda $10
	rts
	
	_mor_switch:
	jsr mor_switch
	jmp loop_mor_rtn
	
	_mol_switch:
	jsr mol_switch
	jmp loop_mol_rtn
	
	loop_missiles_start:
	//First sprite x is d000
	ldx #00
	loop_move_missiles_on_left:
		lda var_missile_vels, x//Load appropriate missile velocity
		sta $02//Store this in a zp register
		lda $d000, x//Load the missile position
		clc
		adc $02//Add the missile velocity
		bcs _mol_switch
		loop_mol_rtn:
		sta $d000, x
		inx//Add two to x (easier this way than xfer-adc)
		inx
		cpx #08
		bne loop_move_missiles_on_left
	
	loop_move_missiles_on_right:
		lda var_missile_vels, x//Load appropriate missile velocity
		sta $02//Store this in a zp register
		lda $d000, x//Load the missile position
		sec
		sbc $02//Add the missile velocity
		bcc _mor_switch
		loop_mor_rtn:
		sta $d000, x
		inx//Add two to x (easier this way than xfer-adc)
		inx
		cpx #16
		bne loop_move_missiles_on_right
	
}

		
.macro SetMissileSprites()
{

		//Set right missile x flag to true (past 256 x)
		lda #%11110000
		sta $d010

		// Sprites, turn on multicolour
		lda #%11111111
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
		sta $d029
		sta $d02a
		
		// USA
		lda #$06
		sta $d02b
		sta $d02c
		sta $d02d
		sta $d02e
		
		lda #$c0								// Sprite located at 3000 (v * $40)
		sta $07f8								// Store in sprite pointer 0
		sta $07f9								// Store in sprite pointer 1
		sta $07fa								// Store in sprite pointer 2
		sta $07fb								// Store in sprite pointer 3
		
		lda #$c2								// Sprite located at 3000 (v * $40)
		sta $07fc								// Store in sprite pointer 0
		sta $07fd								// Store in sprite pointer 1
		sta $07fe								// Store in sprite pointer 2
		sta $07ff								// Store in sprite pointer 3
		
		lda #%11111111							// Turn on sprites
		sta $d015
		
		
		lda #40
		sta $d000
		lda #40
		sta $d001
		
		lda #50
		sta $d002
		lda #50
		sta $d003
		
		lda #60
		sta $d004
		lda #60
		sta $d005
		
		lda #70
		sta $d006
		lda #70
		sta $d007
		
		lda #80
		sta $d008
		lda #80
		sta $d009
		
		lda #90
		sta $d00a
		lda #90
		sta $d00b
		
		lda #100
		sta $d00c
		lda #100
		sta $d00d
		
		lda #110
		sta $d00e
		lda #110
		sta $d00f	
}
