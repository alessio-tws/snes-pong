;----- Assembler Directives ----------------------------------------------------
.p816                           ; tell the assembler this is 65816 code
;-------------------------------------------------------------------------------

.include "sys/vars.inc"

;----- Includes ----------------------------------------------------------------
.segment "SPRITEDATA"
SpriteData: .incbin "pong.spr"
ColorData:  .incbin "debug.pal"
;-------------------------------------------------------------------------------

.segment "CODE"

.include "sys/sys.inc"
.include "logic/setup.inc"
.include "logic/paddles.inc"
.include "logic/ball.inc"

;-------------------------------------------------------------------------------
;   This is the entry point of the demo
;-------------------------------------------------------------------------------
.proc   ResetHandler
        
        InitSystem              ; Initialize snes (logic/setup.inc)
        InitializeValues        ; Initialize game values (logic/setup.inc)
        ClearSprites #$a0       ; Move all sprites from specified index
                                ; outside the screen (logic/setup.inc)

        jmp GameLoop            ; all initialization is done
.endproc
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   After the ResetHandler will jump to here
;-------------------------------------------------------------------------------

.proc   GameLoop
        wai                     ; wait for NMI / V-Blank

        .byte $42, $00          ; debugger breakpoint

        jsr DrawPlayerScores

        jsr HandlePaddles       
        lda BALL_RR     ; Load Ball reset routine flag
        cmp #$00        ; is it 0?
        beq UpdateBallPos ; if yes, just update the position

        ; else, reposition ball in the center
        jsr RepositionBall 
                
        lda OAMMIRROR + $13 ; Get ball sprite last byte in OAM
        eor #$01            ; Invert it    
        sta OAMMIRROR + $13 ; Store the new value       
        lda BALL_RTIMER     ; Load the ball routine timer value
        inc                 ; increase it by 1    
        sta BALL_RTIMER     ; Store the new value
        cmp #$1a            ; Is it == 26?
        beq FinishBallReset ; If yes, finish the reset routine
        bra UpdateBallPos   ; else, jump to the end of the loop

  FinishBallReset:
        lda #$00            ; Load $00 in A
        sta OAMMIRROR + $13 ; Store it in the ball sprite last bye in oam        
        sta BALL_RR         ; Reset the reset routine flag       
        
  UpdateBallPos:
        jsr UpdateBall

        jmp GameLoop

.endproc
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Will be called during V-Blank every frame
;-------------------------------------------------------------------------------
.proc   NMIHandler
        lda RDNMI               ; read NMI status, acknowledge NMI
        

        ; this is where we would do graphics update
        tsx                     ; save old stack pointer 
        pea OAMMIRROR           ; push mirror address to stack 
        jsr UpdateOAMRAM        ; update OAMRAM 
        txs                     ; restore old stack pointer

        rti
.endproc
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
;   Is not used in this program
;-------------------------------------------------------------------------------
.proc   IRQHandler
        ; code
        rti
.endproc
;-------------------------------------------------------------------------------


.proc UpdateSpritePosition
        phx
        phd
        tsc
        tcd

        SpriteIndex = $09
        SpriteX = $08
        SpriteY = $07
        
        ldx SpriteIndex
        
        lda SpriteX
        sta OAMMIRROR, X
        inx
        lda SpriteY
        sta OAMMIRROR, X

        pld
        plx
        rts                
.endproc

;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Interrupt and Reset vectors for the 65816 CPU
;-------------------------------------------------------------------------------
.segment "VECTOR"
; native mode   COP,        BRK,        ABT,
.addr           $0000,      $0000,      $0000
;               NMI,        RST,        IRQ
.addr           NMIHandler, $0000,      $0000

.word           $0000, $0000    ; four unused bytes

; emulation m.  COP,        BRK,        ABT,
.addr           $0000,      $0000,      $0000
;               NMI,        RST,        IRQ
.addr           $0000,      ResetHandler, $0000