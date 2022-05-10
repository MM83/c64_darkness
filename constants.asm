.const ZP_SPRITE_X = $30;//-37 
.const ZP_SPRITE_Y = $38;//-3f 
.const ZP_REGS = $40;//-4f

.const ZP_SPRITE_SCREEN_X = $50
.const ZP_SPRITE_SCREEN_Y = $58

//The char index as a 16-bit number in two bytes
.const ZP_SPRITE_SCREEN_16 = $60

//Cache the character last encountered by a sprite
.const ZP_SPRITE_SCREEN_CHAR = $70

.const ZP_TICKER_LO = $78
.const ZP_TICKER_HI = $79

.const SCRATCH_VARS = $100

.const SPRITE_PTR_0 = $07f8
.const SPRITE_PTR_1 = $07f9
.const SPRITE_PTR_2 = $07fa
.const SPRITE_PTR_3 = $07fb