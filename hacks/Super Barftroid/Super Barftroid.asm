; Super Barftroid replaces every instrument and sound effect with barf from Barf Kraid.
; No screenshots because only the sounds are changed.
!SPCFreespace = $04BE ; put it in somewhere that mITroid's key off patches never touch
lorom

org $8B9282 ; just so it works with SMART
STZ $2133
REP #$20 : LDA #$8040 : STA $75
LDA #$9500 : BRA +
org $8B9296 : +

org $8B92EB ; load SPC engine + patches while displaying Nintendo logo
JSR $936B ; Add 'Nintendo' logo spritemap to OAM
JSL $80896E ; Finalise OAM
-
JSR $9100 ; Advance fast screen fade in
BCS + ; If not max brightness:
JSL $808338 : BRA - ; Wait for NMI and loop
+
JSL $808338 ; Wait for NMI
LDA $80845D : STA $00 : LDA $80845E : STA $01 : JSL $808024 ; Upload SPC engine to APU (gets repointed by SMART)
TDC : - : DEC : BNE - ; wait for SPC to be available for upload
JSL $80800A : dl Patches ; upload patches
-
JSR $90B8 ; Advance fast screen fade out
BCS + ; If not reached zero brightness:
JSL $808338 : BRA - ; Wait for NMI and loop
+
JSL $808338 ; Wait for NMI
PLB : PLP : RTL

org $808459 ; skip vanilla SPC upload
BRA +
org $808482
+

org $89AEFD ; freespace
Patches:
arch spc700

spcblock $6E00 nspc ; replace sample 0 with barf
	incbin "barf.brr"
endspcblock
spcblock $6C00 nspc ; instrument 0
	db $00,$FF,$E0,$B8,$06,$30
endspcblock

spcblock $18F9 nspc ; force every note to use barf instrument
	call SetBarfInstrument
	mov a,#$00 ; force every sound effect to use barf instrument
	bra + : skip 5 : +
endspcblock

spcblock !SPCFreespace nspc
SetBarfInstrument:
	mov a,#$00
	mov $0211+x,a ; restore from hijack
	ret
endspcblock execute $1500

arch 65816
