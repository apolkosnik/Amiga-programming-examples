*************************************************
* Raw picture viewer in 320x256x8 (256 col.)	*
* Example written by Flops 09.01.2016		*
* It can be freely use (if is not used	to harm	*
* anybody).					*
*************************************************

	Section code,code_P

Zab_sys:
	movem.l d0-a6,-(sp)
	move.w $dff01c,d0
	ori.w #$8000,d0
	move.w d0,Old_prz
	move.w #$7fff,$dff09a
	move.w $dff002,d0
	ori.w #$8000,d0
	move.w d0,Old_dma
	move.w #$7fff,$dff096
	move.w #$83c0,$dff096
	move.l 4.w,a6
	move.l 156(a6),a1
	move.l 38(a1),Old_copper
	move.l a7,Old_stack
Wstep:
	move.l #COPPER,$dff080
	move.l #7,d0		;liczba bitplanow -1
	move.l #40,d1		;szerokosc obrazka (w bajtach)
	move.l #256,d2		;wysokosc obrazka (w pixelach)
	mulu.l d2,d1
	move.l #Obraz,d2
	lea Rejestry,a1
Init:
	swap d2
	move.w d2,2(a1)
	swap d2
	move.w d2,6(a1)
	addq.l #8,a1
	add.l d1,d2
	dbf d0,Init
Stop:
	btst #6,$bfe001
	bne Stop
	Lea Obraz,a6	;Init obraz do skasowania.

Czyszczenie:			; Przykladowe czyszczenie ekreanu uzywajac Blittera
	btst #14,$dff002
	bne Czyszczenie

	move.l a6,$dff054	;Blitterem
	move.w #0,$dff066
	move.w #$0100,$dff040
	move.w #0,$dff042
	move.w #256*8,$dff05c
	move.w #20,$dff05e
Stop2:
	btst #2,$dff016
	bne Stop2
	
	move.l Old_stack,a7
	move.l Old_copper,$dff080
	move.w Old_dma,$dff096
	movem.l (sp)+,d0-a6
	move.w Old_prz,$dff09a
	rts	

Old_prz:
	dc.w 0
Old_dma:
	dc.w 0
Old_copper:
	dc.l 0
Old_stack:
	dc.l 0

	Section data,data_c

COPPER:
	
	DC.L $01000210,$01020000
	DC.L $01040000,$01060000
	DC.L $008e2c81,$00902cc1
	DC.L $00920038,$009400d0
	DC.L $01fc0000
	DC.L $01080000,$010a0000
Rejestry:
	DC.L $00e00000,$00e20000
	DC.L $00e40000,$00e60000
	DC.L $00e80000,$00ea0000
	DC.L $00ec0000,$00ee0000
	DC.L $00f00000,$00f20000
	DC.L $00f40000,$00f60000
	DC.L $00f80000,$00fa0000
	DC.L $00fc0000,$00fe0000
	DC.L $01fc0000
Paletea:
;	incbin 'ram:raw/bmw540iSportM.pal'	; Paleta stworzona w piccon (trzeba wejsc w opcje - settings -> PalleteFormat i zaznaczyc Copperlist) 
	incbin 'ram:raw/Zima2014.pal'
	DC.L $fffffffe

Obraz:
;	incbin 'ram:raw/bmw540iSportM.raw'
	incbin "ram:raw/Zima2014.raw"
