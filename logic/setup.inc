.macro InitSystem
	sei        
	clc                     ; clear the carry flag
	xce                     ; switch the 65816 to native (16-bit mode)
	rep #$10                ; set X and Y to 16-bit
	sep #$20                ; set A to 8-bit
	lda #$8f                ; force v-blanking
	sta INIDISP
	stz NMITIMEN            ; disable NMI

	; set the stack pointer to $1fff
	ldx #$1fff              ; load X with $1fff
	txs      
	; load sprites into VRAM
	tsx                     ; save current stack pointer
	pea $0000               ; push VRAM destination address to stack
	pea SpriteData          ; push sprite source address to stack
	ldy #$0260                ; push number of bytes (128/$80) to transfer to stack
	phy
	jsr LoadVRAM            ; transfer VRAM data
	txs                     ; "delete" data on stack by restoring old stack pointer       

	; load color data into CGRAM
	tsx                     ; save current stack pointer
	lda #$80                ; push CGRAM destination address to stack
	pha
	pea ColorData           ; push color source address to stack
	lda #$20                ; push number of bytes (32/$20) to transfer to stack
	pha
	jsr LoadCGRAM           ; transfer color data into CGRAM
	txs                     ; "delete" data on stack by restoring old stack pointer      

	; Set Obj type (00 > 8x8 and 16x16)
	lda #$00 
	sta OBJSEL	
.endmacro



.macro InitializeValues
	; Set Initial Ball H and V Velocity
	lda #$01
	sta BALL_H_VEL    
	lda #$01
	sta BALL_V_VEL    

	; Set initial position of the ball
	lda #(SCREEN_RIGHT/2-4)
	sta BALL_H_POS
	lda #(SCREEN_BOTTOM/2-4)
	sta BALL_V_POS
	; Set Y to 0, will be used to index the sprites
	ldy #$00

	;--Setup Paddle 1 Sprites--
	lda #$00
	pha
	jsr SetupSprite
	txs
	lda #$00
	pha
	jsr SetupSprite
	txs
	;-------------------------

	;--Setup Paddle 2 Sprites--
	lda #$01
	pha
	jsr SetupSprite
	txs
	lda #$01
	pha
	jsr SetupSprite
	txs
	;--------------------------


	;----Setup Ball Sprites----
	lda #$0d
	pha
	jsr SetupSprite
	txs
	;--------------------------

	lda #$03
	pha
	jsr SetupSprite
	txs

	lda #$03
	pha
	jsr SetupSprite
	txs	

	lda #$00
    sta PLAYER_ONE_SCORE
    sta PLAYER_TWO_SCORE        
    sta BALL_RR
    lda #$0d
    sta BALL_CUR_SPRITE

    ; Set initial vertical position for the paddles
    lda #(SPRITE_SIZE+SPRITE_SIZE)
    sta VER_POS
    sta VER_POS_TWO
.endmacro

.macro ClearSprites index
	
	; move the other sprites off screen
    lda #$ff                ; set the coordinates to (255, 255), which is off screen                            
    ldx index

  OAMLoop:
	sta OAMMIRROR, X
	inx 
	cpx #OAMMIRROR_SIZE
	bne OAMLoop

	; correct extra OAM byte for first four sprites 
	ldx #$0200
	lda #$00
 forloop:
	sta OAMMIRROR, X 
	inx
	cpx #$300
	bne forloop

	; make Objects visible
	lda #$10
	sta TM
	; release forced blanking, set screen to full brightness
	lda #$0f
	sta INIDISP
	; enable NMI, turn on automatic joypad polling
	stz $4016

	lda #$81
	sta $4200

.endmacro