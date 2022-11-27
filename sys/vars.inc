;----- Aliases/Labels ----------------------------------------------------------
; these are aliases for the Memory Mapped Registers we will use
INIDISP     = $2100     ; inital settings for screen
OBJSEL      = $2101     ; object size $ object data area designation
OAMADDL     = $2102     ; address for accessing OAM
OAMADDH     = $2103
OAMDATA     = $2104     ; data for OAM write
VMAINC      = $2115     ; VRAM address increment value designation
VMADDL      = $2116     ; address for VRAM read and write
VMADDH      = $2117
VMDATAL     = $2118     ; data for VRAM write
VMDATAH     = $2119
CGADD       = $2121     ; address for CGRAM read and write
CGDATA      = $2122     ; data for CGRAM write
TM          = $212c     ; main screen designation
NMITIMEN    = $4200     ; enable flaog for v-blank
MDMAEN      = $420b     ; DMA enable register
RDNMI       = $4210     ; read the NMI flag status
DMAP0       = $4300     ; DMA control register, channel 0
BBAD0       = $4301     ; DMA destination register, channel 0
A1T0L       = $4302     ; DMA source address register low, channel 0
A1T0H       = $4303     ; DMA source address register high, channel 0
A1T0B       = $4304     ; DMA source address register bank, channel 0
DAS0L       = $4305     ; DMA size register low, channel 0
DAS0H       = $4306     ; DMA size register high, channel 0
;-------------------------------------------------------------------------------

;----- Memory Map WRAM ---------------------------------------------------------
VER_POS   = $0100     ; Vertical pos of paddle 1
VER_POS_TWO   = $0301 ; Vertical pos of paddle 2
BALL_H_POS 			= $0310    ; Horizontal pos for the ball
BALL_V_POS 			= $0311    ; Vertical pos for the ball
BALL_H_VEL 			= $0312    ; Horizontal speed for the ball
BALL_V_VEL 			= $0313    ; Vertical speed for the ball
OOB_IND    			= $0314    ; Flag for collisions checks
BALL_RR	  			= $0320	  ; Flag to set when resetting ball position
BALL_RTIMER			= $0321
BALL_CUR_SPRITE		= $0322
MUL_TEMP   			= $0323

OAMMIRROR   = $0400     ; location of OAMRAM mirror in WRAM


PLAYER_ONE_SCORE = $350
PLAYER_TWO_SCORE = $351
;-------------------------------------------------------------------------------

;----- Game Constants ----------------------------------------------------------
    ; we use these constants to check for collisions with the screen boundaries
SCREEN_LEFT     = $00   ; left screen boundary = 0
SCREEN_RIGHT    = $ff   ; right screen boundary = 255
SCREEN_TOP      = $00   ; top screen boundary = 0 
SCREEN_BOTTOM   = $df   ; bottom screen boundary = 223
PLAYER_ONE_X    = $00   ; X Position for the player 1 Paddle
PLAYER_TWO_X    = $f6   ; X Position for the player 2 Paddle
SPRITE_SIZE     = $08   ; sprites are 8 by 8 pixel
OAMMIRROR_SIZE  = $0220 ; OAMRAM can hold data for 128 sprites, 4 bytes each

PADDLEID_1_1 		= $00
PADDLEID_1_2		= $04
PADDLEID_2_1		= $08
PADDLEID_2_2		= $0c
BALLID				= $10
SCOREID_1			= $14
SCOREID_2			= $18


;-------------------------------------------------------------------------------


;----- Controller Flags --------------------------------------------------------
;$4218
Button_A        = $80
Button_X        = $40
Button_L        = $20
Button_R        = $10
;$4219
Button_B        = $80
Button_Y        = $40
Button_Select   = $20
Button_Start    = $10
Button_Up       = $08
Button_Down     = $04
Button_Left     = $02
Button_Right    = $01

JOY1L           = $4218
JOY1H           = $4219

JOY2L           = $421b
JOY2H           = $421c
;------------------------------------------------------------------------------
