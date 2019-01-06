.pc=$0801
:BasicUpstart(main_start)

#import "sound.asm"


*=$2000
main_start:
ClearSID();
//Set volume of 0(?) to max
lda #$0f
sta $d418

ConfigEnv0($88, $88);
ConfigEnv1($88, $88);
ConfigEnv2($88, $88);

PlayVoice(0, 17, 27, 0);
PlayVoice(1, 27, 37, 0);
PlayVoice(2, 37, 47, 0);

jmp *