.pc=$0801
:BasicUpstart(main_start)

*=$8000

main_start:
		lda #01
		sta $d020
main_loop:
		inc $d021
		jmp main_loop