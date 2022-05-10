
seed: .byte $53, $21, $44

.macro Random()
{
	jsr galois24
}

galois24:
	ldy #8
	lda seed+0
g24_0:
	asl
	rol seed+1
	rol seed+2
	bcc g24_1
	eor #$1B
g24_1:
	dey
	bne g24_0
	sta seed+0
	cmp #0
	rts