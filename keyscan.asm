/*

;$00	Inst/Del	$10	5	$20	9	$30	£
;$01	Return		$11	R	$21	I	$31	*
;$02	Crsr ←→		$12	D	$22	J	$32	]
;$03	F7/F8		$13	6	$23	0	$33	Clr/Home
;$04	F1/F2		$14	C	$24	M	$34	R.Shift
;$05	F3/F4		$15	F	$25	K	$35	=
;$06	F5/F6		$16	T	$26	O	$36	↑
;$07	Crsr ↑↓		$17	X	$27	N	$37	?
;$08	3		$18	7	$28	+	$38	1
;$09	W		$19	Y	$29	P	$39	←
;$0A	A		$1A	G	$2A	L	$3A	Ctrl
;$0B	4		$1B	8	$2B	−	$3B	2
;$0C	Z		$1C	B	$2C	>	$3C	Space
;$0D	S		$1D	H	$2D	[	$3D	Commodore
;$0E	E		$1E	U	$2E	@	$3E	Q
;$0F	L.Shift		$1F	V	$2F	<	$3F	Run/Stop

*/


keys_down: // L U R D
kd_l:
.byte $00
kd_u:
.byte $00
kd_r:
.byte $00
kd_d:
.byte $0

.macro RunKeys()
{
	jsr run_keys
}

run_keys:

		
		LoadKeyRow($fd);
		
		ldx #00
		ldy #01 // Use these to copy true/false values
		
		lda ZP_REGS
		
		cmp #$ff
		bne keyc_jmp_0// NO KEYS
		stx kd_l
		stx kd_u
		stx kd_d
		jmp keyc_jmp_5
		keyc_jmp_0:
		
		cmp #$df
		bne keyc_jmp_1// S KEY ONLY
		stx kd_l
		stx kd_u
		sty kd_d
		keyc_jmp_1:
		
		cmp #$fd
		bne keyc_jmp_2// W KEY ONLY
		stx kd_l
		sty kd_u
		stx kd_d
		keyc_jmp_2:
		
		cmp #$fb
		bne keyc_jmp_3// A KEY ONLY
		sty kd_l
		stx kd_u
		stx kd_d
		keyc_jmp_3:
		
		
		cmp #$db
		bne keyc_jmp_4// A + S KEYS
		sty kd_l
		stx kd_u
		sty kd_d
		keyc_jmp_4:
		
		cmp #$f9
		bne keyc_jmp_5// A + W KEYS
		sty kd_l
		sty kd_u
		stx kd_d
		keyc_jmp_5:
		
		
		LoadKeyRow($fb);
		
		ldx #00
		ldy #01 // Use these to copy true/false values
		
		lda ZP_REGS
		
		cmp #$ff
		bne keyc_jmp_6// NO KEYS
		stx kd_r
		jmp keyc_jmp_7
		keyc_jmp_6:
		
		cmp #$fb
		bne keyc_jmp_7// A KEY ONLY
		sty kd_r
		keyc_jmp_7:
		
		lda kd_u
		sta $d802
		lda kd_l
		sta $d829
		lda kd_d
		sta $d82a
		lda kd_r
		sta $d82b
		
		
		rts


.macro LoadKeyRow(row)
{
	lda #row
	jsr load_key_row
}

load_key_row:
		//lda #$fd // You need to give it a row to read from, there's a table (it's weird)
		sta $dc00 // You store it here...
		lda $dc01 // Then you read what it says here to interpret the keys
		sta $0400
		sta ZP_REGS
		
		// Then you do this to keep the OS happy
		lda $7f
		sta $dc00
		lda $ff
		sta $d02f
		rts
