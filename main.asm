.pc=$0801
:BasicUpstart(main_start)

*=$2000
#import "char_map.asm"

*=$4000
main_start:
		InitSeededRandom();
		ClearSID();
		ConfigEnv0($0e, $00);
		ConfigEnv1($06, $00);
		ConfigEnv2($07, $00);
		// set screen memory ($0400) and charset bitmap offset ($2000)
		lda #$18//Lower byte controls the address, somehow
		sta $d018
		ClearScreen(0, 0);
		jsr intro_start
		jsr menu_start
		jmp *
		
		

#import "sound.asm"
#import "intro.asm"

*=$3000

sprite_1:
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $55,$55,$60,$6a,$55,$64,$6a,$55
.byte $65,$6a,$55,$67,$55,$55,$6c,$ff
.byte $ff,$e0,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$82

*=$3080

sprite_2:
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$25,$55,$5b,$65,$55
.byte $5b,$65,$55,$5b,$2f,$ff,$fb,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$86

*=$3100

sprite_3:
.byte $8a,$00,$20,$2a,$a0,$a0,$2a,$a8
.byte $a8,$0a,$aa,$aa,$0a,$aa,$aa,$0a
.byte $aa,$aa,$0a,$aa,$aa,$2a,$aa,$a8
.byte $2a,$aa,$a0,$2a,$aa,$a0,$2a,$aa
.byte $a0,$2a,$aa,$a0,$0a,$aa,$a8,$0a
.byte $aa,$a8,$0a,$aa,$a8,$2a,$aa,$a8
.byte $2a,$aa,$a0,$0a,$aa,$a0,$02,$aa
.byte $80,$00,$2a,$00,$00,$0a,$00,$85
                            
*=$3180
