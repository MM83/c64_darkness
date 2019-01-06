.macro ClearSID(){
  // clear all sid registers to 0
		ldx #$00
		lda #$00
		jsr clear_sid_loop
}
clear_sid_loop:
		// SID registers start at $d400
		sta $d400
		inc clear_sid_loop+1 
		inx
		cpx #$29 // and there are 29 of them
		bne clear_sid_loop
		// set master volume and turn filter off
		lda #%00000011 
		sta $d418
		rts
		
		
		
	
		
.macro ConfigFilterVolume(filter_volume){
		lda #filter_volume
		sta $d418
}
.macro ConfigEnv0(att_dec, sus_rel){
		lda #att_dec			
		sta $d405
		lda #sus_rel			
		sta $d406
}
.macro ConfigEnv1(att_dec, sus_rel){
		lda #att_dec			
		sta $d40c
		lda #sus_rel			
		sta $d40d
}
.macro ConfigEnv2(att_dec, sus_rel){
		lda #att_dec			
		sta $d413
		lda #sus_rel			
		sta $d414
}



.macro PlayVoice(voice, lo, hi, wave){
	//17, 33, 65, 129
	.if(wave == 0){
		.eval wave = 17;
	}
	.if(wave == 1){
		.eval wave = 33;
	}
	.if(wave == 2){
		.eval wave = 65;
	}
	.if(wave == 3){
		.eval wave = 129;
	}
	ldx #lo
	ldy #hi
	lda #wave
	.if(voice == 0){
		jsr play_note_0
	}
	.if(voice == 1){
		jsr play_note_1
	}
	.if(voice == 2){
		jsr play_note_2
	}
}


.macro PlayNote(voice, note, wave){
	//17, 33, 65, 129
	.if(wave == 0){
		.eval wave = 17;
	}
	.if(wave == 1){
		.eval wave = 33;
	}
	.if(wave == 2){
		.eval wave = 65;
	}
	.if(wave == 3){
		.eval wave = 129;
	}
	ldx note + 1
	ldy note
	lda #wave
	.if(voice == 0){
		jsr play_note_0
	}
	.if(voice == 1){
		jsr play_note_1
	}
	.if(voice == 2){
		jsr play_note_2
	}
}

play_note_0:
	sta $10		//Store the desired waveform
	lda #00		//Load 0 (no waveform)
	sta $d404	//Store waveform (resets)
	stx $d400	//Store lo and hi
	sty $d401
	lda $10		//Reload waveform
	sta $d404	//Store waveform
	rts


play_note_1:
	sta $10		//Store the desired waveform
	lda #00		//Load 0 (no waveform)
	sta $d40b	//Store waveform (resets)
	stx $d407	//Store lo and hi
	sty $d408
	lda $10		//Reload waveform
	sta $d40b	//Store waveform
	rts
	
play_note_2:
	sta $10		//Store the desired waveform
	lda #00		//Load 0 (no waveform)
	sta $d412	//Store waveform (resets)
	stx $d40e	//Store lo and hi
	sty $d40f
	lda $10		//Reload waveform
	sta $d412	//Store waveform
	rts
