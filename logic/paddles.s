.include "paddles.inc"
.include "../sys/vars.inc"
.include "../sys/sprites.inc"

.segment "CODE"

.proc DrawPlayerScores  

		; 20-23
		; 24-27

	updspr SCOREID_1, #(SPRITE_SIZE+2), #$0f

        ; Let's calculate the sprite num 
        ; by adding the player score to the index of the 0 digit sprite
        lda PLAYER_ONE_SCORE
        clc
        adc #$03
        sta OAMMIRROR + $16 

	updspr SCOREID_2, #(SCREEN_RIGHT-SPRITE_SIZE-2), #$0f                

        lda PLAYER_TWO_SCORE
        clc
        adc #$03
        sta OAMMIRROR + $1a        
        rts
.endproc

.proc HandlePaddles
        lda $4219
        cmp #(Button_A)
        bne CheckDown        

  CheckDown:
        lda $4219
        cmp #$04
        bne CheckUp        
        lda VER_POS
        jsr MoveDown
        sta VER_POS

  CheckUp:
        lda $4219
        cmp #$08
        bne SetPos
        lda VER_POS
        jsr MoveUp 
        sta VER_POS       

  SetPos:               
        ; Update player one paddle
  	updspr PADDLEID_1_1, #(PLAYER_ONE_X), VER_POS
        updspr PADDLEID_1_2, #(PLAYER_ONE_X), VER_POS
        ; Offset second sprite
        lda VER_POS
        adc #(SPRITE_SIZE)
        sta OAMMIRROR + $05
       
        lda $421b
        cmp #$04
        bne CheckUpTwo
        
        lda VER_POS_TWO
        jsr MoveDown
        sta VER_POS_TWO

  CheckUpTwo:
        lda $421b
        cmp #$08
        bne SetPosTwo
        lda VER_POS_TWO
        jsr MoveUp
        sta VER_POS_TWO

  SetPosTwo:
        lda #(PLAYER_TWO_X)
        sta OAMMIRROR + $08
        sta OAMMIRROR + $0c
        lda VER_POS_TWO
        sta OAMMIRROR + $09
        clc
        adc #(SPRITE_SIZE)
        sta OAMMIRROR + $0d


.endproc

.proc MoveUp        
		
        clc
        sbc #$01        
        cmp #(SPRITE_SIZE+SPRITE_SIZE)
        bcs return
        lda #(SPRITE_SIZE+SPRITE_SIZE)
        ;lda #(SCREEN_BOTTOM +SPRITE_SIZE+SPRITE_SIZE)        
  return:
        rts
.endproc

.proc MoveDown                
        clc
        adc #$01

        cmp #(SCREEN_BOTTOM - SPRITE_SIZE - SPRITE_SIZE)
        bcc return
        lda #(SCREEN_BOTTOM-SPRITE_SIZE-SPRITE_SIZE)
        
  return:
        rts
.endproc

.export DrawPlayerScores
.export HandlePaddles
.export MoveUp
.export MoveDown