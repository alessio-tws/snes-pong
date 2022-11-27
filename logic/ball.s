.include "../sys/vars.inc"
.include "../sys/sprites.inc"
.include "ball.inc"

.segment "CODE"

.proc CheckVCollision
        
        lda BALL_V_POS
        clc
        cmp #(SPRITE_SIZE+2)
        bcs CheckBottom
        jsr InvertBallVerticalVel
        lda BALL_V_POS
        adc #$01
        sta BALL_V_POS
        bra done

  CheckBottom:
        clc
        cmp #(SCREEN_BOTTOM-SPRITE_SIZE)
        bcc done
        jsr InvertBallVerticalVel
        lda BALL_V_POS
        sbc #$01
        sta BALL_V_POS

  done:
        rts

.endproc

.proc CheckHCollision

        lda #$00
        sta OOB_IND

        lda BALL_H_POS        
        clc
        cmp #(PLAYER_ONE_X+$01)
        bne CheckRight
        ;else        

        lda BALL_V_POS ; Get ball v_pos   
        adc #(SPRITE_SIZE-$01)     
        clc 
        cmp VER_POS 
        bcc done ; if 
        lda VER_POS
        clc
        adc #(SPRITE_SIZE+SPRITE_SIZE)
        cmp BALL_V_POS
        bcc done
        jsr InvertBallVel
        lda #$01
        sta OOB_IND
        bra done

  CheckRight:
        cmp #(PLAYER_TWO_X-$01)
        bne done

        lda BALL_V_POS
        adc #(SPRITE_SIZE-$01)
        clc
        cmp VER_POS_TWO
        bcc done
        lda VER_POS_TWO
        clc
        adc #(SPRITE_SIZE+SPRITE_SIZE)
        cmp BALL_V_POS
        bcc done
        jsr InvertBallVel
        lda #$01
        sta OOB_IND

  done:

        lda OOB_IND
        clc
        cmp #$00
        bne Return
        lda BALL_H_POS
        clc
        cmp #(SCREEN_RIGHT)
        bne CheckBoundLeft
        lda PLAYER_ONE_SCORE
        inc
        cmp #$0a
        bcc IncreaseScoreOne
        lda #$00
  IncreaseScoreOne:        
        sta PLAYER_ONE_SCORE
        stz BALL_RTIMER
        lda #$01
        sta BALL_RR
        bra Return

  CheckBoundLeft:
        cmp #$00
        bne Return
        lda PLAYER_TWO_SCORE
        inc
        cmp #$0a
        bcc IncreaseScoreTwo
        lda #$00
  IncreaseScoreTwo:
        sta PLAYER_TWO_SCORE
        stz BALL_RTIMER
        lda #$01
        sta BALL_RR

  Return:
        rts
.endproc

.proc RepositionBall
        lda #(SCREEN_RIGHT/2-4)
        sta BALL_H_POS
        lda #(SCREEN_BOTTOM/2-4)
        sta BALL_V_POS

        rts
.endproc
.proc InvertBallVerticalVel
        lda BALL_V_VEL
        eor #$ff
        clc
        adc #$01
        sta BALL_V_VEL
        rts
.endproc
.proc InvertBallVel
        lda BALL_H_VEL
        eor #$ff
        clc
        adc #$01
        sta BALL_H_VEL
        rts
.endproc

.proc UpdateBall
        lda BALL_H_POS
        clc
        adc BALL_H_VEL
        sta BALL_H_POS
        
        lda BALL_V_POS
        clc
        adc BALL_V_VEL
        sta BALL_V_POS

        jsr CheckHCollision
        jsr CheckVCollision

  SetBallPos:
        updspr BALLID, BALL_H_POS, BALL_V_POS
        
        lda BALL_CUR_SPRITE
        sta OAMMIRROR + BALLID + $02
        inc
        cmp #$12
        bne done
        lda #$0d

  done:
        sta BALL_CUR_SPRITE                        
        rts
.endproc

.export UpdateBall
.export InvertBallVel
.export InvertBallVerticalVel
.export CheckHCollision
.export CheckVCollision
.export RepositionBall