.pc=$0801
:BasicUpstart(main_start)

*=$8000
main_start:
	ldx #00
	stx $d020
	stx $d021
	
	
clear_screen_loop:
	lda #10
	sta $0400, x
	sta $0500, x
	sta $0600, x
	sta $0700, x
	lda #1
	sta $d800, x
	sta $d900, x
	sta $da00, x
	sta $db00, x
	inx
	cpx #00
	bne clear_screen_loop
	jmp * 