;
; File generated by cc65 v 2.17 - Git 2ad1850
;
	.fopt		compiler,"cc65 v 2.17 - Git 2ad1850"
	.setcpu		"6502"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.forceimport	__STARTUP__
	.export		_NMI_flag
	.export		_Frame_Count
	.export		_index
	.export		_Text_Position
	.export		_TEXT
	.export		_PALETTE
	.export		_Load_Text
	.export		_All_Off
	.export		_All_On
	.export		_Reset_Scroll
	.export		_Load_Palette
	.export		_main

.segment	"RODATA"

_TEXT:
	.byte	$48,$65,$6C,$6C,$6F,$20,$57,$6F,$72,$6C,$64,$21,$00
_PALETTE:
	.byte	$1F
	.byte	$00
	.byte	$10
	.byte	$20

.segment	"BSS"

_NMI_flag:
	.res	1,$00
_Frame_Count:
	.res	1,$00
_index:
	.res	1,$00
_Text_Position:
	.res	1,$00

; ---------------------------------------------------------------
; void __near__ Load_Text (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_Load_Text: near

.segment	"CODE"

;
; if (Text_Position < sizeof(TEXT)){
;
	lda     _Text_Position
	cmp     #$0D
	bcs     L0071
;
; PPU_ADDRESS = 0x21;    // set an address in the PPU of 0x21ca
;
	lda     #$21
	sta     $2006
;
; PPU_ADDRESS = 0xca + Text_Position; // about the middle of the screen
;
	lda     _Text_Position
	clc
	adc     #$CA
	sta     $2006
;
; PPU_DATA = TEXT[Text_Position];
;
	ldy     _Text_Position
	lda     _TEXT,y
	sta     $2007
;
; ++Text_Position; 
;
	inc     _Text_Position
;
; else {
;
	rts
;
; Text_Position = 0;
;
L0071:	lda     #$00
	sta     _Text_Position
;
; PPU_ADDRESS = 0x21;
;
	lda     #$21
	sta     $2006
;
; PPU_ADDRESS = 0xca;
;
	lda     #$CA
	sta     $2006
;
; for ( index = 0; index < sizeof(TEXT); ++index ){
;
	lda     #$00
	sta     _index
L0072:	lda     _index
	cmp     #$0D
	bcs     L0036
;
; PPU_DATA = 0; // clear the text by putting tile #0 in its place
;
	lda     #$00
	sta     $2007
;
; for ( index = 0; index < sizeof(TEXT); ++index ){
;
	inc     _index
	jmp     L0072
;
; }
;
L0036:	rts

.endproc

; ---------------------------------------------------------------
; void __near__ All_Off (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_All_Off: near

.segment	"CODE"

;
; PPU_CTRL = 0;
;
	lda     #$00
	sta     $2000
;
; PPU_MASK = 0; 
;
	sta     $2001
;
; }
;
	rts

.endproc

; ---------------------------------------------------------------
; void __near__ All_On (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_All_On: near

.segment	"CODE"

;
; PPU_CTRL = 0x90; // screen is on, NMI on
;
	lda     #$90
	sta     $2000
;
; PPU_MASK = 0x1e; 
;
	lda     #$1E
	sta     $2001
;
; }
;
	rts

.endproc

; ---------------------------------------------------------------
; void __near__ Reset_Scroll (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_Reset_Scroll: near

.segment	"CODE"

;
; PPU_ADDRESS = 0;
;
	lda     #$00
	sta     $2006
;
; PPU_ADDRESS = 0;
;
	sta     $2006
;
; SCROLL = 0;
;
	sta     $2005
;
; SCROLL = 0;
;
	sta     $2005
;
; }
;
	rts

.endproc

; ---------------------------------------------------------------
; void __near__ Load_Palette (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_Load_Palette: near

.segment	"CODE"

;
; PPU_ADDRESS = 0x3f;
;
	lda     #$3F
	sta     $2006
;
; PPU_ADDRESS = 0x00;
;
	lda     #$00
	sta     $2006
;
; for( index = 0; index < sizeof(PALETTE); ++index ){
;
	sta     _index
L0073:	lda     _index
	cmp     #$04
	bcs     L0064
;
; PPU_DATA = PALETTE[index];
;
	ldy     _index
	lda     _PALETTE,y
	sta     $2007
;
; for( index = 0; index < sizeof(PALETTE); ++index ){
;
	inc     _index
	jmp     L0073
;
; }
;
L0064:	rts

.endproc

; ---------------------------------------------------------------
; void __near__ main (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_main: near

.segment	"CODE"

;
; All_Off();
;
	jsr     _All_Off
;
; Load_Palette();
;
	jsr     _Load_Palette
;
; Reset_Scroll();
;
	jsr     _Reset_Scroll
;
; All_On();
;
	jsr     _All_On
;
; while (NMI_flag == 0); // wait till NMI
;
L0074:	lda     _NMI_flag
	beq     L0074
;
; NMI_flag = 0;
;
	lda     #$00
	sta     _NMI_flag
;
; if (Frame_Count == 30){ // wait 30 frames = 0.5 seconds
;
	lda     _Frame_Count
	cmp     #$1E
	bne     L0074
;
; Load_Text();
;
	jsr     _Load_Text
;
; Reset_Scroll();
;
	jsr     _Reset_Scroll
;
; Frame_Count = 0;
;
	lda     #$00
	sta     _Frame_Count
;
; while (1){ // infinite loop
;
	jmp     L0074

.endproc

