.pc=$0801
:BasicUpstart(main_start)

#import "sound.asm"

var_freq_table:

note_C0: .word $0115
note_Cs0: .word $0125
note_D0: .word $0137
note_Ds0: .word $0149
note_E0: .word $015d
note_F0: .word $0172
note_Fs0: .word $0188
note_G0: .word $019f

*=$2000                                         
main_start:
ClearSID();

		ConfigEnv0($0f, $00);
		PlayVoice(0, $01, $12, 3);


jmp *

