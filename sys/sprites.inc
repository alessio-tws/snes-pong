.global UpdateSpritePos

.macro updspr Index, XPos, YPos

	tsx		
	lda #Index
	pha
	lda XPos
	pha
	lda YPos
	pha
	jsr UpdateSpritePos
	txs

.endmacro