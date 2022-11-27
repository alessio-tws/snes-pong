.include "../sys/vars.inc"
.include "sprites.inc"

SPRITES_COUNT	= $0500
SPRITES_ADDR	= $0520	; Start address for sprite data
; Sprite Data: $xx $yy $name $flip&palette

.segment "CODE"

.proc UpdateSprite
	phx
	phd
	tsc
	tcd

	FlipPal	= $07
	Name	= $08
	YPos	= $09
	XPos	= $0a
	Index	= $0b

	ldx Index

	lda XPos
	sta OAMMIRROR, X
	inx
	lda YPos
	sta OAMMIRROR, X
	inx
	lda Name
	sta OAMMIRROR, X
	inx
	lda FlipPal
	sta OAMMIRROR, X	
	
	rts
.endproc

.proc UpdateSpritePos
	phx
	phd
	tsc
	tcd

	YPos	= $07
	XPos	= $08
	Index	= $09
	sep #$30

	ldy #0
	ldy Index
	
	lda XPos
	sta OAMMIRROR, Y; + $14
	iny
	lda YPos
	sta OAMMIRROR, Y; + $15
	rep #$10
	pld
	plx
	rts
.endproc

.export UpdateSpritePos
.export UpdateSprite