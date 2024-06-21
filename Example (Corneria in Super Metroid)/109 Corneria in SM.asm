; Use asar 1.91 to compile it without a rom and rename .sfc to .nspc, then it can be inserted to SM using SMART (https://edit-sm.art/download.html).
; I used BRR-GUI (https://www.romhacking.net/utilities/1561/) to extract the .BRR samples and VGMTrans and HxD to extract the instruments.
!Instrument18 = $18
!Instrument1A = $19
!Instrument1B = $1A
!Instrument21 = $1B
!Instrument23 = $1C
!Instrument24 = $1D
!Instrument25 = $1E
!Instrument26 = $1F
!InstrumentCA = $20 ; 28
!InstrumentCB = $21 ; 29
lorom

org $808000
spcblock $6D60 nspc ; sample table
	dw Sample18,48*9/16+Sample18,
	   Sample1A,Sample1A,
	   Sample1B,Sample1B,
	   Sample21,320*9/16+Sample21,
	   Sample23,2304*9/16+Sample23,
	   Sample24,96*9/16+Sample24,
	   Sample25,1776*9/16+Sample25,
	   Sample26,1504*9/16+Sample26,
	   SampleCA,272*9/16+SampleCA,
	   SampleCB,SampleCB
endspcblock
spcblock $B210 nspc ; sample data
	Sample18: incbin "109 Corneria_18-loop48.brr"
	Sample1A: incbin "109 Corneria_1a-noloop.brr"
	Sample1B: incbin "109 Corneria_1b-noloop.brr"
	Sample21: incbin "109 Corneria_21-loop320.brr"
	Sample23: incbin "109 Corneria_23-loop2304.brr"
	Sample24: incbin "109 Corneria_24-loop96.brr"
	Sample25: incbin "109 Corneria_25-loop1776.brr"
	Sample26: incbin "109 Corneria_26-loop1504.brr"
	SampleCA: incbin "109 Corneria_28-loop272.brr"
	SampleCB: incbin "109 Corneria_29-noloop.brr"
endspcblock
spcblock $6C90 nspc ; instruments
	db !Instrument18,$FF,$E0,$B8,$03,$00,
	   !Instrument1A,$FF,$E0,$B8,$01,$B0,
	   !Instrument1B,$FF,$E0,$B8,$03,$90,
	   !Instrument21,$FF,$F0,$B8,$03,$80,
	   !Instrument23,$FF,$E0,$B8,$03,$00,
	   !Instrument24,$FF,$F8,$B8,$01,$50,
	   !Instrument25,$FF,$E0,$B8,$1D,$F0,
	   !Instrument26,$FF,$F2,$B8,$06,$F0,
	   !InstrumentCA,$FF,$E0,$B8,$01,$00,
	   !InstrumentCB,$FF,$E0,$B8,$07,$A0
endspcblock
spcblock $5828 nspc ; trackers
dw DestinationE600
; Tracker commands
DestinationE600:     dw PatternE62E,
                        PatternE6BE,
                        PatternE63E
DestinationE606:     dw PatternE65E,
                        PatternE65E,
                        PatternE64E,
                        PatternE66E,
                        PatternE65E,
                        PatternE65E,
                        PatternE64E,
                        PatternE68E,
                        PatternE67E,
                        PatternE6BE,
                        PatternE63E,
                        PatternE69E,
                        PatternE6AE,
                        PatternE69E,
                        PatternE6AE,
                        PatternE6BE,
                        PatternE63E,
                        $0083,DestinationE606,
                        $0000

; Track pointers
PatternE62E:         dw TrackE6CE, $0000, $0000, $0000, $0000, $0000, $0000, $0000
PatternE63E:         dw TrackE6DD, TrackE70A, TrackE78A, TrackE792, TrackE809, TrackE822, $0000, $0000
PatternE64E:         dw TrackE83E, TrackE856, TrackE874, TrackE8A0, TrackE8DD, $0000, $0000, $0000
PatternE65E:         dw TrackE900, TrackE918, TrackE975, TrackE981, TrackE9DC, TrackEA24, $0000, $0000
PatternE66E:         dw TrackEA54, TrackEA7E, TrackEA9B, TrackEAB5, TrackEAC8, TrackEADF, $0000, $0000
PatternE67E:         dw TrackEAF7, TrackEB44, TrackEB8C, TrackEBB1, TrackEBD6, TrackEBFB, $0000, $0000
PatternE68E:         dw TrackEC17, TrackEC46, TrackEC4E, TrackEC74, TrackECAB, $0000, $0000, $0000
PatternE69E:         dw TrackECBC, TrackECD8, TrackECF4, TrackED31, TrackED6C, TrackED8E, $0000, $0000
PatternE6AE:         dw TrackEDB6, TrackEDEB, TrackEE07, TrackEE40, TrackEE79, TrackEEBF, $0000, $0000
PatternE6BE:         dw TrackEEDA, TrackEEF1, TrackEF7C, TrackEF87, TrackF00D, TrackF046, $0000, $0000

; Track set $E62E, track 0 commands
{
TrackE6CE:           db $FA,$28,       ; Percussion instruments base index = 28h
                        $E7,$23,       ; Music tempo = 68.359375 tics per second
                        $E5,$DC,       ; Music volume multiplier = DCh / 100h
                        $F5,$3F,$32,$32, ; Static echo on voices 0/1/2/3/4/5 with echo volume left = 32h and echo volume right = 32h
                        $F7,$02,$28,$03, ; Set echo parameters: echo delay = 2, echo feedback volume = 28h, echo FIR filter index = 3
                        $00
}

; Track set $E63E, track 0 commands
{
TrackE6DD:           db $E0,!Instrument1A,       ; Select instrument 1Ah
                        $ED,$FA,       ; Volume multiplier = FAh / 100h
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $0C,          ; Note length = Ch tics
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $18,          ; Note length = 18h tics
                        $A4,          ; Note C_4
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $0C,          ; Note length = Ch tics
                        $A4,          ; Note C_4
                        $E0,!Instrument1A,       ; Select instrument 1Ah
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $A4,          ; Note C_4
                        $E0,!Instrument1A,       ; Select instrument 1Ah
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $06,          ; Note length = 6 tics
                        $A4,          ; Note C_4
                        $A4,          ; Note C_4
                        $E0,!Instrument1A,       ; Select instrument 1Ah
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $0C,          ; Note length = Ch tics
                        $A4,          ; Note C_4
                        $06,          ; Note length = 6 tics
                        $A4,          ; Note C_4
                        $A4,          ; Note C_4
                        $00
}

; Track set $E63E, track 1 commands
{
TrackE70A:           db $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AE,          ; Note Bb_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AE,          ; Note Bb_4
                        $E1,$0A,       ; Panning bias = Ah / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AD,          ; Note A_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AD,          ; Note A_4
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $A9,          ; Note F_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $A9,          ; Note F_4
                        $E1,$05,       ; Panning bias = 5 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $A6,          ; Note D_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $A6,          ; Note D_4
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $A9,          ; Note F_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $A9          ; Note F_4
}

; Track set $E63E, track 2 commands
{
TrackE78A:           db $E0,!Instrument21,       ; Select instrument 21h
                        $ED,$DC,       ; Volume multiplier = DCh / 100h
                        $EF : dw TrackF05A : db $01  ; Play subsection $F05A 1 times
}

; Track set $E63E, track 3 commands
{
TrackE792:           db $11,          ; Note length = 11h tics
                        $C9,          ; Rest
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AE,          ; Note Bb_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AE,          ; Note Bb_4
                        $E1,$0A,       ; Panning bias = Ah / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AD,          ; Note A_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AD,          ; Note A_4
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $A9,          ; Note F_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $A9,          ; Note F_4
                        $E1,$05,       ; Panning bias = 5 / 14h with no phase inversion
                        $07,$6F,       ; Note length = 7 tics, note volume multiplier = FCh / 100h, note ring length multiplier = E5h / 100h
                        $A6          ; Note D_4
}

; Track set $E63E, track 4 commands
{
TrackE809:           db $E0,!Instrument1B,       ; Select instrument 1Bh
                        $ED,$64,       ; Volume multiplier = 64h / 100h
                        $50,          ; Note length = 50h tics
                        $C9,          ; Rest
                        $10,$7F,       ; Note length = 10h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $A5,          ; Note Db_4
                        $E0,!Instrument26,       ; Select instrument 26h
                        $ED,$C8,       ; Volume multiplier = C8h / 100h
                        $E1,$00,       ; Panning bias = 0 / 14h with no phase inversion
                        $0C,          ; Note length = Ch tics
                        $9D,          ; Note F_3
                        $9D,          ; Note F_3
                        $E1,$14,       ; Panning bias = 14h / 14h with no phase inversion
                        $98,          ; Note C_3
                        $98,          ; Note C_3
                        $18,          ; Note length = 18h tics
                        $C9,          ; Rest
                        $C9          ; Rest
}

; Track set $E63E, track 5 commands
{
TrackE822:           db $E0,!Instrument1B,       ; Select instrument 1Bh
                        $ED,$50,       ; Volume multiplier = 50h / 100h
                        $53,          ; Note length = 53h tics
                        $C9,          ; Rest
                        $0D,$7F,       ; Note length = Dh tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $A5,          ; Note Db_4
                        $E0,!Instrument26,       ; Select instrument 26h
                        $ED,$B4,       ; Volume multiplier = B4h / 100h
                        $E1,$00,       ; Panning bias = 0 / 14h with no phase inversion
                        $03,          ; Note length = 3 tics
                        $C9,          ; Rest
                        $0C,          ; Note length = Ch tics
                        $9D,          ; Note F_3
                        $9D,          ; Note F_3
                        $E1,$14,       ; Panning bias = 14h / 14h with no phase inversion
                        $98,          ; Note C_3
                        $98,          ; Note C_3
                        $18,          ; Note length = 18h tics
                        $C9,          ; Rest
                        $15,          ; Note length = 15h tics
                        $C9          ; Rest
}

; Track set $E64E, track 0 commands
{
TrackE83E:           db $E0,!Instrument1A,       ; Select instrument 1Ah
                        $ED,$FA,       ; Volume multiplier = FAh / 100h
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $A4,          ; Note C_4
                        $E0,!Instrument1A,       ; Select instrument 1Ah
                        $0C,          ; Note length = Ch tics
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $18,          ; Note length = 18h tics
                        $A4,          ; Note C_4
                        $EF : dw TrackF06D : db $03,  ; Play subsection $F06D 3 times
                        $00
}

; Track set $E64E, track 1 commands
{
TrackE856:           db $E0,!Instrument21,       ; Select instrument 21h
                        $ED,$DC,       ; Volume multiplier = DCh / 100h
                        $F4,$00,       ; Set subtranspose of 0 / 100h semitones
                        $E1,$0A,       ; Panning bias = Ah / 14h with no phase inversion
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $EF : dw TrackF07D : db $01  ; Play subsection $F07D 1 times
}

; Track set $E64E, track 2 commands
{
TrackE874:           db $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $E1,$0F,       ; Panning bias = Fh / 14h with no phase inversion
                        $F4,$1E,       ; Set subtranspose of 1Eh / 100h semitones
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $8F,          ; Note Eb_2
                        $E0,!Instrument23,       ; Select instrument 23h
                        $ED,$A0,       ; Volume multiplier = A0h / 100h
                        $E3,$0C,$1E,$28, ; Static vibrato after Ch tics at rate 1Eh with extent 28h
                        $E1,$0C,       ; Panning bias = Ch / 14h with no phase inversion
                        $F4,$00,       ; Set subtranspose of 0 / 100h semitones
                        $A7,          ; Note Eb_4
                        $B2,          ; Note D_5
                        $A7,          ; Note Eb_4
                        $B0,          ; Note C_5
                        $A7,          ; Note Eb_4
                        $AE,          ; Note Bb_4
                        $A7,          ; Note Eb_4
                        $EF : dw TrackF08E : db $01,  ; Play subsection $F08E 1 times
                        $18,          ; Note length = 18h tics
                        $B0,          ; Note C_5
                        $0C,          ; Note length = Ch tics
                        $B2,          ; Note D_5
                        $24,$5F,       ; Note length = 24h tics, note volume multiplier = FCh / 100h, note ring length multiplier = CBh / 100h
                        $B2,          ; Note D_5
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B2          ; Note D_5
}

; Track set $E64E, track 3 commands
{
TrackE8A0:           db $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $E1,$05,       ; Panning bias = 5 / 14h with no phase inversion
                        $F4,$1E,       ; Set subtranspose of 1Eh / 100h semitones
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $83,          ; Note Eb_1
                        $E0,!Instrument23,       ; Select instrument 23h
                        $ED,$96,       ; Volume multiplier = 96h / 100h
                        $E3,$0C,$1E,$28, ; Static vibrato after Ch tics at rate 1Eh with extent 28h
                        $E1,$08,       ; Panning bias = 8 / 14h with no phase inversion
                        $F4,$00,       ; Set subtranspose of 0 / 100h semitones
                        $A2,          ; Note Bb_3
                        $AE,          ; Note Bb_4
                        $A2,          ; Note Bb_3
                        $AD,          ; Note A_4
                        $A2,          ; Note Bb_3
                        $AB,          ; Note G_4
                        $A2,          ; Note Bb_3
                        $0E,          ; Note length = Eh tics
                        $A9,          ; Note F_4
                        $05,          ; Note length = 5 tics
                        $AB,          ; Note G_4
                        $A9,          ; Note F_4
                        $0C,          ; Note length = Ch tics
                        $A7,          ; Note Eb_4
                        $A9,          ; Note F_4
                        $C9,          ; Rest
                        $A6,          ; Note D_4
                        $A7,          ; Note Eb_4
                        $A9,          ; Note F_4
                        $18,          ; Note length = 18h tics
                        $AD,          ; Note A_4
                        $0C,          ; Note length = Ch tics
                        $AB,          ; Note G_4
                        $A9,          ; Note F_4
                        $C9,          ; Rest
                        $A9,          ; Note F_4
                        $AB,          ; Note G_4
                        $AD,          ; Note A_4
                        $18,          ; Note length = 18h tics
                        $AD,          ; Note A_4
                        $0C,          ; Note length = Ch tics
                        $AE,          ; Note Bb_4
                        $24,$5F,       ; Note length = 24h tics, note volume multiplier = FCh / 100h, note ring length multiplier = CBh / 100h
                        $AE,          ; Note Bb_4
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AE          ; Note Bb_4
}

; Track set $E64E, track 4 commands
{
TrackE8DD:           db $0C,          ; Note length = Ch tics
                        $C9,          ; Rest
                        $11,$7F,       ; Note length = 11h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $8F,          ; Note Eb_2
                        $E0,!Instrument23,       ; Select instrument 23h
                        $ED,$64,       ; Volume multiplier = 64h / 100h
                        $E3,$0C,$1E,$28, ; Static vibrato after Ch tics at rate 1Eh with extent 28h
                        $0C,          ; Note length = Ch tics
                        $A7,          ; Note Eb_4
                        $B2,          ; Note D_5
                        $A7,          ; Note Eb_4
                        $B0,          ; Note C_5
                        $A7,          ; Note Eb_4
                        $AE,          ; Note Bb_4
                        $A7,          ; Note Eb_4
                        $EF : dw TrackF08E : db $01,  ; Play subsection $F08E 1 times
                        $18,          ; Note length = 18h tics
                        $B0,          ; Note C_5
                        $0C,          ; Note length = Ch tics
                        $B2,          ; Note D_5
                        $24,$5F,       ; Note length = 24h tics, note volume multiplier = FCh / 100h, note ring length multiplier = CBh / 100h
                        $B2,          ; Note D_5
                        $07,$7F,       ; Note length = 7 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B2          ; Note D_5
}

; Track set $E65E, track 0 commands
{
TrackE900:           db $E0,!Instrument1A,       ; Select instrument 1Ah
                        $ED,$FA,       ; Volume multiplier = FAh / 100h
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $A4,          ; Note C_4
                        $E0,!Instrument1A,       ; Select instrument 1Ah
                        $0C,          ; Note length = Ch tics
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $18,          ; Note length = 18h tics
                        $A4,          ; Note C_4
                        $EF : dw TrackF06D : db $03,  ; Play subsection $F06D 3 times
                        $00
}

; Track set $E65E, track 1 commands
{
TrackE918:           db $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $E1,$0D,       ; Panning bias = Dh / 14h with no phase inversion
                        $F4,$00,       ; Set subtranspose of 0 / 100h semitones
                        $E3,$06,$1E,$1E, ; Static vibrato after 6 tics at rate 1Eh with extent 1Eh
                        $01,          ; Note length = 1 tics
                        $C9,          ; Rest
                        $17,$7F,       ; Note length = 17h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $E0,!Instrument25,       ; Select instrument 25h
                        $ED,$AA,       ; Volume multiplier = AAh / 100h
                        $18,          ; Note length = 18h tics
                        $87,          ; Note G_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $87,          ; Note G_1
                        $18,$2F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = 7Fh / 100h
                        $87,          ; Note G_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $87,          ; Note G_1
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $87,          ; Note G_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $87,          ; Note G_1
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $87,          ; Note G_1
                        $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $93,          ; Note G_2
                        $18,          ; Note length = 18h tics
                        $95,          ; Note A_2
                        $0C,          ; Note length = Ch tics
                        $96,          ; Note Bb_2
                        $01,          ; Note length = 1 tics
                        $C9,          ; Rest
                        $17,          ; Note length = 17h tics
                        $8F,          ; Note Eb_2
                        $E0,!Instrument25,       ; Select instrument 25h
                        $ED,$AA,       ; Volume multiplier = AAh / 100h
                        $18,          ; Note length = 18h tics
                        $83,          ; Note Eb_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $83,          ; Note Eb_1
                        $18,$2F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = 7Fh / 100h
                        $83,          ; Note Eb_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $83,          ; Note Eb_1
                        $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $91,          ; Note F_2
                        $E0,!Instrument25,       ; Select instrument 25h
                        $ED,$AA,       ; Volume multiplier = AAh / 100h
                        $85,          ; Note F_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $85,          ; Note F_1
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $85,          ; Note F_1
                        $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $18,          ; Note length = 18h tics
                        $91          ; Note F_2
}

; Track set $E65E, track 2 commands
{
TrackE975:           db $E0,!Instrument21,       ; Select instrument 21h
                        $ED,$DC,       ; Volume multiplier = DCh / 100h
                        $EF : dw TrackF05A : db $01,  ; Play subsection $F05A 1 times
                        $EF : dw TrackF0A4 : db $02  ; Play subsection $F0A4 2 times
}

; Track set $E65E, track 3 commands
{
TrackE981:           db $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $E1,$07,       ; Panning bias = 7 / 14h with no phase inversion
                        $F4,$00,       ; Set subtranspose of 0 / 100h semitones
                        $E3,$06,$1E,$1E, ; Static vibrato after 6 tics at rate 1Eh with extent 1Eh
                        $19,$7F,       ; Note length = 19h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $87,          ; Note G_1
                        $E0,!Instrument25,       ; Select instrument 25h
                        $ED,$8C,       ; Volume multiplier = 8Ch / 100h
                        $18,          ; Note length = 18h tics
                        $87,          ; Note G_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $87,          ; Note G_1
                        $18,$2F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = 7Fh / 100h
                        $87,          ; Note G_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $87,          ; Note G_1
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $87,          ; Note G_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $87,          ; Note G_1
                        $0B,$7F,       ; Note length = Bh tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $87,          ; Note G_1
                        $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $0C,          ; Note length = Ch tics
                        $87,          ; Note G_1
                        $18,          ; Note length = 18h tics
                        $89,          ; Note A_1
                        $0C,          ; Note length = Ch tics
                        $8A,          ; Note Bb_1
                        $19,          ; Note length = 19h tics
                        $83,          ; Note Eb_1
                        $E0,!Instrument25,       ; Select instrument 25h
                        $ED,$8C,       ; Volume multiplier = 8Ch / 100h
                        $18,          ; Note length = 18h tics
                        $83,          ; Note Eb_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $83,          ; Note Eb_1
                        $18,$2F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = 7Fh / 100h
                        $83,          ; Note Eb_1
                        $0B,$1F,       ; Note length = Bh tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $83,          ; Note Eb_1
                        $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $19,$7F,       ; Note length = 19h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $85,          ; Note F_1
                        $E0,!Instrument25,       ; Select instrument 25h
                        $ED,$8C,       ; Volume multiplier = 8Ch / 100h
                        $18,          ; Note length = 18h tics
                        $85,          ; Note F_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $85,          ; Note F_1
                        $0B,$7F,       ; Note length = Bh tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $85,          ; Note F_1
                        $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $18,          ; Note length = 18h tics
                        $85          ; Note F_1
}

; Track set $E65E, track 4 commands
{
TrackE9DC:           db $EF : dw TrackF0AD : db $01,  ; Play subsection $F0AD 1 times
                        $48,          ; Note length = 48h tics
                        $C9,          ; Rest
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $95,          ; Note A_2
                        $0C,          ; Note length = Ch tics
                        $C9,          ; Rest
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $8F,          ; Note Eb_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$79,       ; Note length = Ch tics, note volume multiplier = B2h / 100h, note ring length multiplier = FCh / 100h
                        $8F,          ; Note Eb_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $8F,          ; Note Eb_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$75,       ; Note length = Ch tics, note volume multiplier = 7Fh / 100h, note ring length multiplier = FCh / 100h
                        $8F,          ; Note Eb_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $8F,          ; Note Eb_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$72,       ; Note length = Ch tics, note volume multiplier = 4Ch / 100h, note ring length multiplier = FCh / 100h
                        $8F,          ; Note Eb_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $8F,          ; Note Eb_2
                        $C9,          ; Rest
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $91,          ; Note F_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$79,       ; Note length = Ch tics, note volume multiplier = B2h / 100h, note ring length multiplier = FCh / 100h
                        $91,          ; Note F_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $0C,$75,       ; Note length = Ch tics, note volume multiplier = 7Fh / 100h, note ring length multiplier = FCh / 100h
                        $91,          ; Note F_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $91,          ; Note F_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $0C,$72,       ; Note length = Ch tics, note volume multiplier = 4Ch / 100h, note ring length multiplier = FCh / 100h
                        $91,          ; Note F_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $91,          ; Note F_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $91          ; Note F_2
}

; Track set $E65E, track 5 commands
{
TrackEA24:           db $E0,!InstrumentCA,       ; Select percussion instrument 0
                        $ED,$64,       ; Volume multiplier = 64h / 100h
                        $E1,$14,       ; Panning bias = 14h / 14h with no phase inversion
                        $E2,$C0,$00,    ; Dynamic panning over C0h tics with target panning bias 0 / 14h
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $AB,          ; Note G_4
                        $B5,          ; Note F_5
                        $B7,          ; Note G_5
                        $AB,          ; Note G_4
                        $B7,          ; Note G_5
                        $AB,          ; Note G_4
                        $B5,          ; Note F_5
                        $B7,          ; Note G_5
                        $AB,          ; Note G_4
                        $B5,          ; Note F_5
                        $B7,          ; Note G_5
                        $AE,          ; Note Bb_4
                        $AD,          ; Note A_4
                        $A9,          ; Note F_4
                        $A6,          ; Note D_4
                        $A9,          ; Note F_4
                        $E2,$B4,$14,    ; Dynamic panning over B4h tics with target panning bias 14h / 14h
                        $AB,          ; Note G_4
                        $B5,          ; Note F_5
                        $B7,          ; Note G_5
                        $AB,          ; Note G_4
                        $B7,          ; Note G_5
                        $AB,          ; Note G_4
                        $B5,          ; Note F_5
                        $B7,          ; Note G_5
                        $AB,          ; Note G_4
                        $B5,          ; Note F_5
                        $B7,          ; Note G_5
                        $AE,          ; Note Bb_4
                        $AD,          ; Note A_4
                        $A9,          ; Note F_4
                        $A6,          ; Note D_4
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $A9          ; Note F_4
}

; Track set $E66E, track 0 commands
{
TrackEA54:           db $E0,!Instrument1A,       ; Select instrument 1Ah
                        $ED,$FA,       ; Volume multiplier = FAh / 100h
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $A4,          ; Note C_4
                        $E0,!Instrument1A,       ; Select instrument 1Ah
                        $0C,          ; Note length = Ch tics
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $18,          ; Note length = 18h tics
                        $A4,          ; Note C_4
                        $EF : dw TrackF06D : db $03,  ; Play subsection $F06D 3 times
                        $E0,!Instrument1A,       ; Select instrument 1Ah
                        $0C,          ; Note length = Ch tics
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $A4,          ; Note C_4
                        $E0,!Instrument1A,       ; Select instrument 1Ah
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $06,          ; Note length = 6 tics
                        $A4,          ; Note C_4
                        $A4,          ; Note C_4
                        $A4,          ; Note C_4
                        $A4,          ; Note C_4
                        $00
}

; Track set $E66E, track 1 commands
{
TrackEA7E:           db $EF : dw TrackF0D5 : db $01,  ; Play subsection $F0D5 1 times
                        $8E,          ; Note D_2
                        $8E,          ; Note D_2
                        $8E,          ; Note D_2
                        $8E,          ; Note D_2
                        $8E,          ; Note D_2
                        $8E,          ; Note D_2
                        $8E,          ; Note D_2
                        $8E,          ; Note D_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $94,          ; Note Ab_2
                        $94,          ; Note Ab_2
                        $94,          ; Note Ab_2
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $96,          ; Note Bb_2
                        $96,          ; Note Bb_2
                        $96,          ; Note Bb_2
                        $06,          ; Note length = 6 tics
                        $97,          ; Note B_2
                        $98,          ; Note C_3
                        $99,          ; Note Db_3
                        $9A          ; Note D_3
}

; Track set $E66E, track 2 commands
{
TrackEA9B:           db $EF : dw TrackF0EE : db $01,  ; Play subsection $F0EE 1 times
                        $EF : dw TrackF100 : db $01,  ; Play subsection $F100 1 times
                        $0C,          ; Note length = Ch tics
                        $B7,          ; Note G_5
                        $B2,          ; Note D_5
                        $B7,          ; Note G_5
                        $B8,          ; Note Ab_5
                        $B3,          ; Note Eb_5
                        $B8,          ; Note Ab_5
                        $B9,          ; Note A_5
                        $B4,          ; Note E_5
                        $B9,          ; Note A_5
                        $BA,          ; Note Bb_5
                        $B5,          ; Note F_5
                        $BA,          ; Note Bb_5
                        $06,          ; Note length = 6 tics
                        $BB,          ; Note B_5
                        $BC,          ; Note C_6
                        $BD,          ; Note Db_6
                        $BE          ; Note D_6
}

; Track set $E66E, track 3 commands
{
TrackEAB5:           db $EF : dw TrackF10F : db $01,  ; Play subsection $F10F 1 times
                        $0C,          ; Note length = Ch tics
                        $B2,          ; Note D_5
                        $AF,          ; Note B_4
                        $B2,          ; Note D_5
                        $B3,          ; Note Eb_5
                        $B0,          ; Note C_5
                        $B3,          ; Note Eb_5
                        $B4,          ; Note E_5
                        $B1,          ; Note Db_5
                        $B4,          ; Note E_5
                        $B5,          ; Note F_5
                        $B2,          ; Note D_5
                        $B5,          ; Note F_5
                        $18,          ; Note length = 18h tics
                        $C9          ; Rest
}

; Track set $E66E, track 4 commands
{
TrackEAC8:           db $EF : dw TrackF12F : db $01,  ; Play subsection $F12F 1 times
                        $EF : dw TrackF100 : db $01,  ; Play subsection $F100 1 times
                        $0C,          ; Note length = Ch tics
                        $B7,          ; Note G_5
                        $B2,          ; Note D_5
                        $B7,          ; Note G_5
                        $B8,          ; Note Ab_5
                        $B3,          ; Note Eb_5
                        $B8,          ; Note Ab_5
                        $B9,          ; Note A_5
                        $B4,          ; Note E_5
                        $B9,          ; Note A_5
                        $BA,          ; Note Bb_5
                        $B5,          ; Note F_5
                        $BA,          ; Note Bb_5
                        $07,          ; Note length = 7 tics
                        $BB          ; Note B_5
}

; Track set $E66E, track 5 commands
{
TrackEADF:           db $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $E1,$0A,       ; Panning bias = Ah / 14h with no phase inversion
                        $F4,$1E,       ; Set subtranspose of 1Eh / 100h semitones
                        $60,          ; Note length = 60h tics
                        $C9,          ; Rest
                        $C9,          ; Rest
                        $C9,          ; Rest
                        $C9,          ; Rest
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $95,          ; Note A_2
                        $96,          ; Note Bb_2
                        $91,          ; Note F_2
                        $96,          ; Note Bb_2
                        $06,          ; Note length = 6 tics
                        $97,          ; Note B_2
                        $98,          ; Note C_3
                        $99,          ; Note Db_3
                        $9A          ; Note D_3
}

; Track set $E67E, track 0 commands
{
TrackEAF7:           db $E0,!Instrument26,       ; Select instrument 26h
                        $ED,$FA,       ; Volume multiplier = FAh / 100h
                        $F8,$01,$64,$64, ; Dynamic echo volume after 1 tics with target echo volume left = 64h and target echo volume right = 64h
                        $E1,$02,       ; Panning bias = 2 / 14h with no phase inversion
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $98,          ; Note C_3
                        $E1,$12,       ; Panning bias = 12h / 14h with no phase inversion
                        $93,          ; Note G_2
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $E1,$0A,       ; Panning bias = Ah / 14h with no phase inversion
                        $18,          ; Note length = 18h tics
                        $A3,          ; Note B_3
                        $A3,          ; Note B_3
                        $E0,!Instrument26,       ; Select instrument 26h
                        $E1,$02,       ; Panning bias = 2 / 14h with no phase inversion
                        $0C,          ; Note length = Ch tics
                        $98,          ; Note C_3
                        $E1,$12,       ; Panning bias = 12h / 14h with no phase inversion
                        $93,          ; Note G_2
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $E1,$0A,       ; Panning bias = Ah / 14h with no phase inversion
                        $18,          ; Note length = 18h tics
                        $A4,          ; Note C_4
                        $E0,!Instrument26,       ; Select instrument 26h
                        $E1,$02,       ; Panning bias = 2 / 14h with no phase inversion
                        $0C,          ; Note length = Ch tics
                        $98,          ; Note C_3
                        $E1,$12,       ; Panning bias = 12h / 14h with no phase inversion
                        $93,          ; Note G_2
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $E1,$0A,       ; Panning bias = Ah / 14h with no phase inversion
                        $18,          ; Note length = 18h tics
                        $A4,          ; Note C_4
                        $A4,          ; Note C_4
                        $E0,!Instrument26,       ; Select instrument 26h
                        $E1,$02,       ; Panning bias = 2 / 14h with no phase inversion
                        $0C,          ; Note length = Ch tics
                        $98,          ; Note C_3
                        $E1,$12,       ; Panning bias = 12h / 14h with no phase inversion
                        $93,          ; Note G_2
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $E1,$0A,       ; Panning bias = Ah / 14h with no phase inversion
                        $F8,$01,$32,$32, ; Dynamic echo volume after 1 tics with target echo volume left = 32h and target echo volume right = 32h
                        $06,          ; Note length = 6 tics
                        $A4,          ; Note C_4
                        $A4,          ; Note C_4
                        $A4,          ; Note C_4
                        $A4,          ; Note C_4
                        $00
}

; Track set $E67E, track 1 commands
{
TrackEB44:           db $E0,!Instrument21,       ; Select instrument 21h
                        $ED,$FA,       ; Volume multiplier = FAh / 100h
                        $F4,$00,       ; Set subtranspose of 0 / 100h semitones
                        $E3,$0C,$28,$28, ; Static vibrato after Ch tics at rate 28h with extent 28h
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $E0,!Instrument18,       ; Select instrument 18h
                        $ED,$78,       ; Volume multiplier = 78h / 100h
                        $18,$5F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = CBh / 100h
                        $B5,          ; Note F_5
                        $B5,          ; Note F_5
                        $E0,!Instrument21,       ; Select instrument 21h
                        $ED,$FA,       ; Volume multiplier = FAh / 100h
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $E0,!Instrument18,       ; Select instrument 18h
                        $ED,$78,       ; Volume multiplier = 78h / 100h
                        $18,$5F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = CBh / 100h
                        $B5,          ; Note F_5
                        $E0,!Instrument21,       ; Select instrument 21h
                        $ED,$FA,       ; Volume multiplier = FAh / 100h
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $E0,!Instrument18,       ; Select instrument 18h
                        $ED,$78,       ; Volume multiplier = 78h / 100h
                        $18,$5F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = CBh / 100h
                        $B5,          ; Note F_5
                        $B5,          ; Note F_5
                        $E0,!Instrument21,       ; Select instrument 21h
                        $ED,$FA,       ; Volume multiplier = FAh / 100h
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $E0,!Instrument18,       ; Select instrument 18h
                        $ED,$78,       ; Volume multiplier = 78h / 100h
                        $F1,$10,$08,$F3, ; Slide out after 10h tics for 8 tics by F3h semitones
                        $18,$5F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = CBh / 100h
                        $B5          ; Note F_5
}

; Track set $E67E, track 2 commands
{
TrackEB8C:           db $E0,!Instrument18,       ; Select instrument 18h
                        $ED,$78,       ; Volume multiplier = 78h / 100h
                        $E3,$0C,$23,$28, ; Static vibrato after Ch tics at rate 23h with extent 28h
                        $19,          ; Note length = 19h tics
                        $C9,          ; Rest
                        $18,$5F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = CBh / 100h
                        $AB,          ; Note G_4
                        $AB,          ; Note G_4
                        $18,$55,       ; Note length = 18h tics, note volume multiplier = 7Fh / 100h, note ring length multiplier = CBh / 100h
                        $AB,          ; Note G_4
                        $18,$5F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = CBh / 100h
                        $AB,          ; Note G_4
                        $18,$55,       ; Note length = 18h tics, note volume multiplier = 7Fh / 100h, note ring length multiplier = CBh / 100h
                        $AB,          ; Note G_4
                        $18,$5F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = CBh / 100h
                        $AB,          ; Note G_4
                        $AB,          ; Note G_4
                        $18,$55,       ; Note length = 18h tics, note volume multiplier = 7Fh / 100h, note ring length multiplier = CBh / 100h
                        $AB,          ; Note G_4
                        $F1,$10,$08,$F3, ; Slide out after 10h tics for 8 tics by F3h semitones
                        $17,$5F,       ; Note length = 17h tics, note volume multiplier = FCh / 100h, note ring length multiplier = CBh / 100h
                        $AB          ; Note G_4
}

; Track set $E67E, track 3 commands
{
TrackEBB1:           db $E0,!Instrument23,       ; Select instrument 23h
                        $ED,$78,       ; Volume multiplier = 78h / 100h
                        $E3,$0C,$28,$28, ; Static vibrato after Ch tics at rate 28h with extent 28h
                        $18,          ; Note length = 18h tics
                        $C9,          ; Rest
                        $18,$5D,       ; Note length = 18h tics, note volume multiplier = E5h / 100h, note ring length multiplier = CBh / 100h
                        $B0,          ; Note C_5
                        $B0,          ; Note C_5
                        $18,$57,       ; Note length = 18h tics, note volume multiplier = 98h / 100h, note ring length multiplier = CBh / 100h
                        $B0,          ; Note C_5
                        $18,$5D,       ; Note length = 18h tics, note volume multiplier = E5h / 100h, note ring length multiplier = CBh / 100h
                        $B0,          ; Note C_5
                        $18,$57,       ; Note length = 18h tics, note volume multiplier = 98h / 100h, note ring length multiplier = CBh / 100h
                        $B0,          ; Note C_5
                        $18,$5D,       ; Note length = 18h tics, note volume multiplier = E5h / 100h, note ring length multiplier = CBh / 100h
                        $B0,          ; Note C_5
                        $B0,          ; Note C_5
                        $18,$57,       ; Note length = 18h tics, note volume multiplier = 98h / 100h, note ring length multiplier = CBh / 100h
                        $B0,          ; Note C_5
                        $F1,$10,$08,$F3, ; Slide out after 10h tics for 8 tics by F3h semitones
                        $18,$5D,       ; Note length = 18h tics, note volume multiplier = E5h / 100h, note ring length multiplier = CBh / 100h
                        $B0          ; Note C_5
}

; Track set $E67E, track 4 commands
{
TrackEBD6:           db $E0,!Instrument23,       ; Select instrument 23h
                        $ED,$64,       ; Volume multiplier = 64h / 100h
                        $E3,$0C,$28,$28, ; Static vibrato after Ch tics at rate 28h with extent 28h
                        $1C,          ; Note length = 1Ch tics
                        $C9,          ; Rest
                        $18,$5D,       ; Note length = 18h tics, note volume multiplier = E5h / 100h, note ring length multiplier = CBh / 100h
                        $B5,          ; Note F_5
                        $B5,          ; Note F_5
                        $18,$57,       ; Note length = 18h tics, note volume multiplier = 98h / 100h, note ring length multiplier = CBh / 100h
                        $B5,          ; Note F_5
                        $18,$5D,       ; Note length = 18h tics, note volume multiplier = E5h / 100h, note ring length multiplier = CBh / 100h
                        $B5,          ; Note F_5
                        $18,$57,       ; Note length = 18h tics, note volume multiplier = 98h / 100h, note ring length multiplier = CBh / 100h
                        $B5,          ; Note F_5
                        $18,$5D,       ; Note length = 18h tics, note volume multiplier = E5h / 100h, note ring length multiplier = CBh / 100h
                        $B5,          ; Note F_5
                        $B5,          ; Note F_5
                        $18,$57,       ; Note length = 18h tics, note volume multiplier = 98h / 100h, note ring length multiplier = CBh / 100h
                        $B5,          ; Note F_5
                        $F1,$10,$08,$F3, ; Slide out after 10h tics for 8 tics by F3h semitones
                        $14,$5D,       ; Note length = 14h tics, note volume multiplier = E5h / 100h, note ring length multiplier = CBh / 100h
                        $B5          ; Note F_5
}

; Track set $E67E, track 5 commands
{
TrackEBFB:           db $E0,!Instrument26,       ; Select instrument 26h
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $E1,$12,       ; Panning bias = 12h / 14h with no phase inversion
                        $F4,$1E,       ; Set subtranspose of 1Eh / 100h semitones
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $90,          ; Note E_2
                        $18,          ; Note length = 18h tics
                        $90,          ; Note E_2
                        $24,          ; Note length = 24h tics
                        $C9,          ; Rest
                        $0C,          ; Note length = Ch tics
                        $90,          ; Note E_2
                        $90,          ; Note E_2
                        $18,          ; Note length = 18h tics
                        $C9,          ; Rest
                        $0C,          ; Note length = Ch tics
                        $90,          ; Note E_2
                        $3C,          ; Note length = 3Ch tics
                        $90,          ; Note E_2
                        $0C,          ; Note length = Ch tics
                        $90,          ; Note E_2
                        $24,          ; Note length = 24h tics
                        $90          ; Note E_2
}

; Track set $E68E, track 0 commands
{
TrackEC17:           db $E0,!Instrument1A,       ; Select instrument 1Ah
                        $ED,$FA,       ; Volume multiplier = FAh / 100h
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $A4,          ; Note C_4
                        $E0,!Instrument1A,       ; Select instrument 1Ah
                        $0C,          ; Note length = Ch tics
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $18,          ; Note length = 18h tics
                        $A4,          ; Note C_4
                        $EF : dw TrackF06D : db $02,  ; Play subsection $F06D 2 times
                        $0C,          ; Note length = Ch tics
                        $A4,          ; Note C_4
                        $E0,!Instrument1A,       ; Select instrument 1Ah
                        $A4,          ; Note C_4
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $A4,          ; Note C_4
                        $E0,!Instrument1A,       ; Select instrument 1Ah
                        $A4,          ; Note C_4
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $A4,          ; Note C_4
                        $E0,!Instrument1A,       ; Select instrument 1Ah
                        $A4,          ; Note C_4
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $A4,          ; Note C_4
                        $E0,!Instrument1A,       ; Select instrument 1Ah
                        $A4,          ; Note C_4
                        $00
}

; Track set $E68E, track 1 commands
{
TrackEC46:           db $EF : dw TrackF0D5 : db $01,  ; Play subsection $F0D5 1 times
                        $EF : dw TrackF07D : db $01  ; Play subsection $F07D 1 times
}

; Track set $E68E, track 2 commands
{
TrackEC4E:           db $EF : dw TrackF0EE : db $01,  ; Play subsection $F0EE 1 times
                        $EF : dw TrackF100 : db $01,  ; Play subsection $F100 1 times
                        $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$F0,       ; Volume multiplier = F0h / 100h
                        $E1,$0F,       ; Panning bias = Fh / 14h with no phase inversion
                        $F4,$00,       ; Set subtranspose of 0 / 100h semitones
                        $E3,$06,$1E,$1E, ; Static vibrato after 6 tics at rate 1Eh with extent 1Eh
                        $01,          ; Note length = 1 tics
                        $C9,          ; Rest
                        $0B,          ; Note length = Bh tics
                        $93,          ; Note G_2
                        $E0,!Instrument23,       ; Select instrument 23h
                        $ED,$A0,       ; Volume multiplier = A0h / 100h
                        $E1,$0C,       ; Panning bias = Ch / 14h with no phase inversion
                        $0C,          ; Note length = Ch tics
                        $B7,          ; Note G_5
                        $B2,          ; Note D_5
                        $B0,          ; Note C_5
                        $AB,          ; Note G_4
                        $A6,          ; Note D_4
                        $A4,          ; Note C_4
                        $9F          ; Note G_3
}

; Track set $E68E, track 3 commands
{
TrackEC74:           db $EF : dw TrackF10F : db $01,  ; Play subsection $F10F 1 times
                        $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$F0,       ; Volume multiplier = F0h / 100h
                        $E1,$05,       ; Panning bias = 5 / 14h with no phase inversion
                        $F4,$00,       ; Set subtranspose of 0 / 100h semitones
                        $E3,$06,$1E,$1E, ; Static vibrato after 6 tics at rate 1Eh with extent 1Eh
                        $0C,          ; Note length = Ch tics
                        $87,          ; Note G_1
                        $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $E1,$0F,       ; Panning bias = Fh / 14h with no phase inversion
                        $F4,$1E,       ; Set subtranspose of 1Eh / 100h semitones
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $93,          ; Note G_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$79,       ; Note length = Ch tics, note volume multiplier = B2h / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $93,          ; Note G_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$75,       ; Note length = Ch tics, note volume multiplier = 7Fh / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $93,          ; Note G_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$72,       ; Note length = Ch tics, note volume multiplier = 4Ch / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $E1,$08,       ; Panning bias = 8 / 14h with no phase inversion
                        $0C,$71,       ; Note length = Ch tics, note volume multiplier = 32h / 100h, note ring length multiplier = FCh / 100h
                        $93          ; Note G_2
}

; Track set $E68E, track 4 commands
{
TrackECAB:           db $EF : dw TrackF12F : db $01,  ; Play subsection $F12F 1 times
                        $EF : dw TrackF100 : db $01,  ; Play subsection $F100 1 times
                        $0C,          ; Note length = Ch tics
                        $C9,          ; Rest
                        $B7,          ; Note G_5
                        $B2,          ; Note D_5
                        $B0,          ; Note C_5
                        $AB,          ; Note G_4
                        $A6,          ; Note D_4
                        $07,          ; Note length = 7 tics
                        $A4          ; Note C_4
}

; Track set $E69E, track 0 commands
{
TrackECBC:           db $E0,!Instrument1A,       ; Select instrument 1Ah
                        $ED,$FA,       ; Volume multiplier = FAh / 100h
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $0C,          ; Note length = Ch tics
                        $93,          ; Note G_2
                        $9F,          ; Note G_3
                        $93,          ; Note G_2
                        $9F,          ; Note G_3
                        $93,          ; Note G_2
                        $9F,          ; Note G_3
                        $93,          ; Note G_2
                        $9F,          ; Note G_3
                        $00
}

; Track set $E69E, track 1 commands
{
TrackECD8:           db $E0,!Instrument21,       ; Select instrument 21h
                        $ED,$FA,       ; Volume multiplier = FAh / 100h
                        $E1,$0A,       ; Panning bias = Ah / 14h with no phase inversion
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $91,          ; Note F_2
                        $91,          ; Note F_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $96,          ; Note Bb_2
                        $8E,          ; Note D_2
                        $93,          ; Note G_2
                        $EF : dw TrackF141 : db $02,  ; Play subsection $F141 2 times
                        $C8,          ; Tie
                        $91,          ; Note F_2
                        $91,          ; Note F_2
                        $93,          ; Note G_2
                        $99,          ; Note Db_3
                        $93,          ; Note G_2
                        $98,          ; Note C_3
                        $95          ; Note A_2
}

; Track set $E69E, track 2 commands
{
TrackECF4:           db $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $E1,$0F,       ; Panning bias = Fh / 14h with no phase inversion
                        $F4,$00,       ; Set subtranspose of 0 / 100h semitones
                        $E3,$06,$1E,$1E, ; Static vibrato after 6 tics at rate 1Eh with extent 1Eh
                        $01,          ; Note length = 1 tics
                        $C9,          ; Rest
                        $17,$7F,       ; Note length = 17h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $E0,!Instrument25,       ; Select instrument 25h
                        $ED,$BE,       ; Volume multiplier = BEh / 100h
                        $18,          ; Note length = 18h tics
                        $87,          ; Note G_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $87,          ; Note G_1
                        $18,$2F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = 7Fh / 100h
                        $87,          ; Note G_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $87,          ; Note G_1
                        $EF : dw TrackF14A : db $01,  ; Play subsection $F14A 1 times
                        $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $9A,          ; Note D_3
                        $E0,!Instrument25,       ; Select instrument 25h
                        $ED,$BE,       ; Volume multiplier = BEh / 100h
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $87,          ; Note G_1
                        $87,          ; Note G_1
                        $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $99,          ; Note Db_3
                        $98,          ; Note C_3
                        $0C,          ; Note length = Ch tics
                        $95          ; Note A_2
}

; Track set $E69E, track 3 commands
{
TrackED31:           db $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $E1,$05,       ; Panning bias = 5 / 14h with no phase inversion
                        $F4,$00,       ; Set subtranspose of 0 / 100h semitones
                        $E3,$06,$1E,$1E, ; Static vibrato after 6 tics at rate 1Eh with extent 1Eh
                        $19,$7F,       ; Note length = 19h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $87,          ; Note G_1
                        $E0,!Instrument25,       ; Select instrument 25h
                        $ED,$A0,       ; Volume multiplier = A0h / 100h
                        $18,          ; Note length = 18h tics
                        $87,          ; Note G_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $87,          ; Note G_1
                        $18,$2F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = 7Fh / 100h
                        $87,          ; Note G_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $87,          ; Note G_1
                        $EF : dw TrackF14A : db $01,  ; Play subsection $F14A 1 times
                        $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $8E,          ; Note D_2
                        $E0,!Instrument25,       ; Select instrument 25h
                        $ED,$A0,       ; Volume multiplier = A0h / 100h
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $87,          ; Note G_1
                        $87,          ; Note G_1
                        $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $8D,          ; Note Db_2
                        $8C,          ; Note C_2
                        $0B,          ; Note length = Bh tics
                        $89          ; Note A_1
}

; Track set $E69E, track 4 commands
{
TrackED6C:           db $EF : dw TrackF0AD : db $01,  ; Play subsection $F0AD 1 times
                        $60,          ; Note length = 60h tics
                        $C9,          ; Rest
                        $C9,          ; Rest
                        $0C,          ; Note length = Ch tics
                        $C9,          ; Rest
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $0C,$79,       ; Note length = Ch tics, note volume multiplier = B2h / 100h, note ring length multiplier = FCh / 100h
                        $9A,          ; Note D_3
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$75,       ; Note length = Ch tics, note volume multiplier = 7Fh / 100h, note ring length multiplier = FCh / 100h
                        $9A,          ; Note D_3
                        $C9,          ; Rest
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $0C,$79,       ; Note length = Ch tics, note volume multiplier = B2h / 100h, note ring length multiplier = FCh / 100h
                        $99,          ; Note Db_3
                        $C9,          ; Rest
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $98,          ; Note C_3
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $0C,$75,       ; Note length = Ch tics, note volume multiplier = 7Fh / 100h, note ring length multiplier = FCh / 100h
                        $98          ; Note C_3
}

; Track set $E69E, track 5 commands
{
TrackED8E:           db $E0,!Instrument24,       ; Select instrument 24h
                        $ED,$D2,       ; Volume multiplier = D2h / 100h
                        $E1,$00,       ; Panning bias = 0 / 14h with no phase inversion
                        $E2,$60,$14,    ; Dynamic panning over 60h tics with target panning bias 14h / 14h
                        $18,$0F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = 32h / 100h
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $12,          ; Note length = 12h tics
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $0C,          ; Note length = Ch tics
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $18,          ; Note length = 18h tics
                        $93,          ; Note G_2
                        $E2,$60,$00,    ; Dynamic panning over 60h tics with target panning bias 0 / 14h
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $12,          ; Note length = 12h tics
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $0C,          ; Note length = Ch tics
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $18,          ; Note length = 18h tics
                        $93          ; Note G_2
}

; Track set $E6AE, track 0 commands
{
TrackEDB6:           db $E0,!Instrument1A,       ; Select instrument 1Ah
                        $ED,$FA,       ; Volume multiplier = FAh / 100h
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $18,          ; Note length = 18h tics
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $06,          ; Note length = 6 tics
                        $A4,          ; Note C_4
                        $A4,          ; Note C_4
                        $0C,          ; Note length = Ch tics
                        $A4,          ; Note C_4
                        $E0,!Instrument1A,       ; Select instrument 1Ah
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $E0,!Instrument26,       ; Select instrument 26h
                        $E1,$00,       ; Panning bias = 0 / 14h with no phase inversion
                        $06,          ; Note length = 6 tics
                        $98,          ; Note C_3
                        $98,          ; Note C_3
                        $E1,$0A,       ; Panning bias = Ah / 14h with no phase inversion
                        $0C,          ; Note length = Ch tics
                        $93,          ; Note G_2
                        $E1,$14,       ; Panning bias = 14h / 14h with no phase inversion
                        $90,          ; Note E_2
                        $E1,$0A,       ; Panning bias = Ah / 14h with no phase inversion
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $06,          ; Note length = 6 tics
                        $A4,          ; Note C_4
                        $A4,          ; Note C_4
                        $00
}

; Track set $E6AE, track 1 commands
{
TrackEDEB:           db $E0,!Instrument21,       ; Select instrument 21h
                        $ED,$FA,       ; Volume multiplier = FAh / 100h
                        $F4,$00,       ; Set subtranspose of 0 / 100h semitones
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $98,          ; Note C_3
                        $90,          ; Note E_2
                        $95,          ; Note A_2
                        $EF : dw TrackF16A : db $02,  ; Play subsection $F16A 2 times
                        $9C,          ; Note E_3
                        $9C,          ; Note E_3
                        $9B,          ; Note Eb_3
                        $9B,          ; Note Eb_3
                        $9A,          ; Note D_3
                        $90,          ; Note E_2
                        $91,          ; Note F_2
                        $92          ; Note Gb_2
}

; Track set $E6AE, track 2 commands
{
TrackEE07:           db $E0,!Instrument25,       ; Select instrument 25h
                        $ED,$BE,       ; Volume multiplier = BEh / 100h
                        $0C,          ; Note length = Ch tics
                        $C9,          ; Rest
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $89,          ; Note A_1
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $89,          ; Note A_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $89,          ; Note A_1
                        $18,$2F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = 7Fh / 100h
                        $89,          ; Note A_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $89,          ; Note A_1
                        $EF : dw TrackF173 : db $01,  ; Play subsection $F173 1 times
                        $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $F4,$50,       ; Set subtranspose of 50h / 100h semitones
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $9C,          ; Note E_3
                        $9C,          ; Note E_3
                        $9C,          ; Note E_3
                        $E0,!Instrument25,       ; Select instrument 25h
                        $ED,$BE,       ; Volume multiplier = BEh / 100h
                        $06,$1F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $89,          ; Note A_1
                        $0C,          ; Note length = Ch tics
                        $89,          ; Note A_1
                        $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $F4,$00,       ; Set subtranspose of 0 / 100h semitones
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $90,          ; Note E_2
                        $91,          ; Note F_2
                        $0C,          ; Note length = Ch tics
                        $92          ; Note Gb_2
}

; Track set $E6AE, track 3 commands
{
TrackEE40:           db $E0,!Instrument25,       ; Select instrument 25h
                        $ED,$A0,       ; Volume multiplier = A0h / 100h
                        $0D,          ; Note length = Dh tics
                        $C9,          ; Rest
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $89,          ; Note A_1
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $89,          ; Note A_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $89,          ; Note A_1
                        $18,$2F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = 7Fh / 100h
                        $89,          ; Note A_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $89,          ; Note A_1
                        $EF : dw TrackF173 : db $01,  ; Play subsection $F173 1 times
                        $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $F4,$50,       ; Set subtranspose of 50h / 100h semitones
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $90,          ; Note E_2
                        $90,          ; Note E_2
                        $90,          ; Note E_2
                        $E0,!Instrument25,       ; Select instrument 25h
                        $ED,$A0,       ; Volume multiplier = A0h / 100h
                        $06,$1F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $89,          ; Note A_1
                        $0C,          ; Note length = Ch tics
                        $89,          ; Note A_1
                        $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$E6,       ; Volume multiplier = E6h / 100h
                        $F4,$00,       ; Set subtranspose of 0 / 100h semitones
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $84,          ; Note E_1
                        $85,          ; Note F_1
                        $0B,          ; Note length = Bh tics
                        $86          ; Note Gb_1
}

; Track set $E6AE, track 4 commands
{
TrackEE79:           db $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$C8,       ; Volume multiplier = C8h / 100h
                        $F4,$1E,       ; Set subtranspose of 1Eh / 100h semitones
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $95,          ; Note A_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$79,       ; Note length = Ch tics, note volume multiplier = B2h / 100h, note ring length multiplier = FCh / 100h
                        $95,          ; Note A_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $95,          ; Note A_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$75,       ; Note length = Ch tics, note volume multiplier = 7Fh / 100h, note ring length multiplier = FCh / 100h
                        $95,          ; Note A_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $95,          ; Note A_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$72,       ; Note length = Ch tics, note volume multiplier = 4Ch / 100h, note ring length multiplier = FCh / 100h
                        $95,          ; Note A_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $95,          ; Note A_2
                        $E1,$02,       ; Panning bias = 2 / 14h with no phase inversion
                        $0C,$71,       ; Note length = Ch tics, note volume multiplier = 32h / 100h, note ring length multiplier = FCh / 100h
                        $95,          ; Note A_2
                        $60,          ; Note length = 60h tics
                        $C9,          ; Rest
                        $C9,          ; Rest
                        $0C,          ; Note length = Ch tics
                        $C9,          ; Rest
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $0C,$79,       ; Note length = Ch tics, note volume multiplier = B2h / 100h, note ring length multiplier = FCh / 100h
                        $9C,          ; Note E_3
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$75,       ; Note length = Ch tics, note volume multiplier = 7Fh / 100h, note ring length multiplier = FCh / 100h
                        $9C,          ; Note E_3
                        $C9,          ; Rest
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $0C,$79,       ; Note length = Ch tics, note volume multiplier = B2h / 100h, note ring length multiplier = FCh / 100h
                        $90,          ; Note E_2
                        $C9,          ; Rest
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $91,          ; Note F_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $0C,$75,       ; Note length = Ch tics, note volume multiplier = 7Fh / 100h, note ring length multiplier = FCh / 100h
                        $91          ; Note F_2
}

; Track set $E6AE, track 5 commands
{
TrackEEBF:           db $E2,$60,$14,    ; Dynamic panning over 60h tics with target panning bias 14h / 14h
                        $18,$0F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = 32h / 100h
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $12,          ; Note length = 12h tics
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $0C,          ; Note length = Ch tics
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $18,          ; Note length = 18h tics
                        $95,          ; Note A_2
                        $E2,$60,$00,    ; Dynamic panning over 60h tics with target panning bias 0 / 14h
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $60,          ; Note length = 60h tics
                        $C9          ; Rest
}

; Track set $E6BE, track 0 commands
{
TrackEEDA:           db $E0,!Instrument1A,       ; Select instrument 1Ah
                        $ED,$FA,       ; Volume multiplier = FAh / 100h
                        $E1,$0A,       ; Panning bias = Ah / 14h with no phase inversion
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $0C,          ; Note length = Ch tics
                        $A4,          ; Note C_4
                        $E0,!Instrument1A,       ; Select instrument 1Ah
                        $9F,          ; Note G_3
                        $00
}

; Track set $E6BE, track 1 commands
{
TrackEEF1:           db $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$F0,       ; Volume multiplier = F0h / 100h
                        $E1,$0F,       ; Panning bias = Fh / 14h with no phase inversion
                        $F3,          ; End slide
                        $F4,$32,       ; Set subtranspose of 32h / 100h semitones
                        $01,          ; Note length = 1 tics
                        $C9,          ; Rest
                        $0B,$7F,       ; Note length = Bh tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $E0,!InstrumentCA,       ; Select percussion instrument 0
                        $ED,$8C,       ; Volume multiplier = 8Ch / 100h
                        $F4,$00,       ; Set subtranspose of 0 / 100h semitones
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,          ; Note length = 6 tics
                        $B5,          ; Note F_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AE,          ; Note Bb_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AE,          ; Note Bb_4
                        $E1,$0A,       ; Panning bias = Ah / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AD,          ; Note A_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AD,          ; Note A_4
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $A9,          ; Note F_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $A9,          ; Note F_4
                        $E1,$05,       ; Panning bias = 5 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $A6,          ; Note D_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $A6,          ; Note D_4
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $A9,          ; Note F_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $A9          ; Note F_4
}

; Track set $E6BE, track 2 commands
{
TrackEF7C:           db $E0,!Instrument21,       ; Select instrument 21h
                        $ED,$DC,       ; Volume multiplier = DCh / 100h
                        $F3,          ; End slide
                        $E1,$0A,       ; Panning bias = Ah / 14h with no phase inversion
                        $EF : dw TrackF05A : db $01  ; Play subsection $F05A 1 times
}

; Track set $E6BE, track 3 commands
{
TrackEF87:           db $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$D2,       ; Volume multiplier = D2h / 100h
                        $E1,$05,       ; Panning bias = 5 / 14h with no phase inversion
                        $F3,          ; End slide
                        $F4,$32,       ; Set subtranspose of 32h / 100h semitones
                        $11,$7F,       ; Note length = 11h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $87,          ; Note G_1
                        $E0,!InstrumentCA,       ; Select percussion instrument 0
                        $ED,$78,       ; Volume multiplier = 78h / 100h
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $F4,$00,       ; Set subtranspose of 0 / 100h semitones
                        $06,          ; Note length = 6 tics
                        $AB,          ; Note G_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AB,          ; Note G_4
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B5,          ; Note F_5
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $B7,          ; Note G_5
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AE,          ; Note Bb_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AE,          ; Note Bb_4
                        $E1,$0A,       ; Panning bias = Ah / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AD,          ; Note A_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $AD,          ; Note A_4
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $06,$7F,       ; Note length = 6 tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $A9,          ; Note F_4
                        $06,$77,       ; Note length = 6 tics, note volume multiplier = 98h / 100h, note ring length multiplier = FCh / 100h
                        $A9,          ; Note F_4
                        $E1,$05,       ; Panning bias = 5 / 14h with no phase inversion
                        $07,$6F,       ; Note length = 7 tics, note volume multiplier = FCh / 100h, note ring length multiplier = E5h / 100h
                        $A6          ; Note D_4
}

; Track set $E6BE, track 4 commands
{
TrackF00D:           db $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$C8,       ; Volume multiplier = C8h / 100h
                        $E1,$0F,       ; Panning bias = Fh / 14h with no phase inversion
                        $F4,$32,       ; Set subtranspose of 32h / 100h semitones
                        $F3,          ; End slide
                        $0C,          ; Note length = Ch tics
                        $C9,          ; Rest
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$79,       ; Note length = Ch tics, note volume multiplier = B2h / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $93,          ; Note G_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$75,       ; Note length = Ch tics, note volume multiplier = 7Fh / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $93,          ; Note G_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$72,       ; Note length = Ch tics, note volume multiplier = 4Ch / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $93,          ; Note G_2
                        $E0,!Instrument26,       ; Select instrument 26h
                        $ED,$C8,       ; Volume multiplier = C8h / 100h
                        $E1,$00,       ; Panning bias = 0 / 14h with no phase inversion
                        $3C,          ; Note length = 3Ch tics
                        $C9,          ; Rest
                        $14,$7F,       ; Note length = 14h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $98,          ; Note C_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $ED,$64,       ; Volume multiplier = 64h / 100h
                        $10,          ; Note length = 10h tics
                        $A5          ; Note Db_4
}

; Track set $E6BE, track 5 commands
{
TrackF046:           db $E0,!Instrument26,       ; Select instrument 26h
                        $ED,$B4,       ; Volume multiplier = B4h / 100h
                        $E1,$14,       ; Panning bias = 14h / 14h with no phase inversion
                        $60,          ; Note length = 60h tics
                        $C9,          ; Rest
                        $3F,          ; Note length = 3Fh tics
                        $C9,          ; Rest
                        $14,$7F,       ; Note length = 14h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $98,          ; Note C_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $ED,$50,       ; Volume multiplier = 50h / 100h
                        $0D,          ; Note length = Dh tics
                        $A5,          ; Note Db_4
                        $00
}

; Repeated subsection
{
TrackF05A:           db $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $00
}

; Repeated subsection
{
TrackF06D:           db $E0,!Instrument1A,       ; Select instrument 1Ah
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $A4,          ; Note C_4
                        $E0,!Instrument1A,       ; Select instrument 1Ah
                        $0C,          ; Note length = Ch tics
                        $9F,          ; Note G_3
                        $9F,          ; Note G_3
                        $E0,!Instrument1B,       ; Select instrument 1Bh
                        $18,          ; Note length = 18h tics
                        $A4,          ; Note C_4
                        $00
}

; Repeated subsection
{
TrackF07D:           db $8E,          ; Note D_2
                        $8E,          ; Note D_2
                        $8E,          ; Note D_2
                        $8E,          ; Note D_2
                        $8E,          ; Note D_2
                        $8E,          ; Note D_2
                        $8E,          ; Note D_2
                        $8E,          ; Note D_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $00
}

; Repeated subsection
{
TrackF08E:           db $0E,          ; Note length = Eh tics
                        $AD,          ; Note A_4
                        $05,          ; Note length = 5 tics
                        $AE,          ; Note Bb_4
                        $AD,          ; Note A_4
                        $0C,          ; Note length = Ch tics
                        $AB,          ; Note G_4
                        $AD,          ; Note A_4
                        $C9,          ; Rest
                        $A9,          ; Note F_4
                        $AB,          ; Note G_4
                        $AD,          ; Note A_4
                        $18,          ; Note length = 18h tics
                        $B0,          ; Note C_5
                        $0C,          ; Note length = Ch tics
                        $AE,          ; Note Bb_4
                        $AD,          ; Note A_4
                        $C9,          ; Rest
                        $AD,          ; Note A_4
                        $AE,          ; Note Bb_4
                        $B0,          ; Note C_5
                        $00
}

; Repeated subsection
{
TrackF0A4:           db $93,          ; Note G_2
                        $91,          ; Note F_2
                        $91,          ; Note F_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $96,          ; Note Bb_2
                        $96,          ; Note Bb_2
                        $93,          ; Note G_2
                        $00
}

; Repeated subsection
{
TrackF0AD:           db $E0,!InstrumentCB,       ; Select percussion instrument 1
                        $ED,$C8,       ; Volume multiplier = C8h / 100h
                        $E1,$0F,       ; Panning bias = Fh / 14h with no phase inversion
                        $F4,$1E,       ; Set subtranspose of 1Eh / 100h semitones
                        $0C,          ; Note length = Ch tics
                        $C9,          ; Rest
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$79,       ; Note length = Ch tics, note volume multiplier = B2h / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $93,          ; Note G_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$75,       ; Note length = Ch tics, note volume multiplier = 7Fh / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $93,          ; Note G_2
                        $E1,$01,       ; Panning bias = 1 / 14h with no phase inversion
                        $0C,$72,       ; Note length = Ch tics, note volume multiplier = 4Ch / 100h, note ring length multiplier = FCh / 100h
                        $93,          ; Note G_2
                        $E1,$13,       ; Panning bias = 13h / 14h with no phase inversion
                        $93,          ; Note G_2
                        $00
}

; Repeated subsection
{
TrackF0D5:           db $E0,!Instrument21,       ; Select instrument 21h
                        $ED,$DC,       ; Volume multiplier = DCh / 100h
                        $F4,$00,       ; Set subtranspose of 0 / 100h semitones
                        $0C,$7F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $8F,          ; Note Eb_2
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $00
}

; Repeated subsection
{
TrackF0EE:           db $ED,$A0,       ; Volume multiplier = A0h / 100h
                        $E3,$0C,$1E,$28, ; Static vibrato after Ch tics at rate 1Eh with extent 28h
                        $E1,$0C,       ; Panning bias = Ch / 14h with no phase inversion
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B3,          ; Note Eb_5
                        $0C,          ; Note length = Ch tics
                        $AE,          ; Note Bb_4
                        $24,          ; Note length = 24h tics
                        $AE,          ; Note Bb_4
                        $18,          ; Note length = 18h tics
                        $B3,          ; Note Eb_5
                        $00
}

; Repeated subsection
{
TrackF100:           db $B5,          ; Note F_5
                        $0C,          ; Note length = Ch tics
                        $B0,          ; Note C_5
                        $24,          ; Note length = 24h tics
                        $B0,          ; Note C_5
                        $18,          ; Note length = 18h tics
                        $B5,          ; Note F_5
                        $B6,          ; Note Gb_5
                        $0C,          ; Note length = Ch tics
                        $B1,          ; Note Db_5
                        $24,          ; Note length = 24h tics
                        $B1,          ; Note Db_5
                        $18,          ; Note length = 18h tics
                        $B6,          ; Note Gb_5
                        $00
}

; Repeated subsection
{
TrackF10F:           db $ED,$96,       ; Volume multiplier = 96h / 100h
                        $E3,$0C,$1E,$28, ; Static vibrato after Ch tics at rate 1Eh with extent 28h
                        $E1,$08,       ; Panning bias = 8 / 14h with no phase inversion
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $AE,          ; Note Bb_4
                        $0C,          ; Note length = Ch tics
                        $AB,          ; Note G_4
                        $24,          ; Note length = 24h tics
                        $AB,          ; Note G_4
                        $18,          ; Note length = 18h tics
                        $AE,          ; Note Bb_4
                        $B0,          ; Note C_5
                        $0C,          ; Note length = Ch tics
                        $AD,          ; Note A_4
                        $24,          ; Note length = 24h tics
                        $AD,          ; Note A_4
                        $18,          ; Note length = 18h tics
                        $B0,          ; Note C_5
                        $B1,          ; Note Db_5
                        $0C,          ; Note length = Ch tics
                        $AE,          ; Note Bb_4
                        $24,          ; Note length = 24h tics
                        $AE,          ; Note Bb_4
                        $18,          ; Note length = 18h tics
                        $B1,          ; Note Db_5
                        $00
}

; Repeated subsection
{
TrackF12F:           db $ED,$78,       ; Volume multiplier = 78h / 100h
                        $E3,$0C,$1E,$28, ; Static vibrato after Ch tics at rate 1Eh with extent 28h
                        $11,          ; Note length = 11h tics
                        $C9,          ; Rest
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $B3,          ; Note Eb_5
                        $0C,          ; Note length = Ch tics
                        $AE,          ; Note Bb_4
                        $24,          ; Note length = 24h tics
                        $AE,          ; Note Bb_4
                        $18,          ; Note length = 18h tics
                        $B3,          ; Note Eb_5
                        $00
}

; Repeated subsection
{
TrackF141:           db $C8,          ; Tie
                        $91,          ; Note F_2
                        $91,          ; Note F_2
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $96,          ; Note Bb_2
                        $8E,          ; Note D_2
                        $93,          ; Note G_2
                        $00
}

; Repeated subsection
{
TrackF14A:           db $18,$3F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = 98h / 100h
                        $87,          ; Note G_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $87,          ; Note G_1
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $87,          ; Note G_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $87,          ; Note G_1
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $87,          ; Note G_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $87,          ; Note G_1
                        $87,          ; Note G_1
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $87,          ; Note G_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $87,          ; Note G_1
                        $18,$4F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = B2h / 100h
                        $87,          ; Note G_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $87,          ; Note G_1
                        $00
}

; Repeated subsection
{
TrackF16A:           db $C8,          ; Tie
                        $93,          ; Note G_2
                        $93,          ; Note G_2
                        $95,          ; Note A_2
                        $95,          ; Note A_2
                        $98,          ; Note C_3
                        $90,          ; Note E_2
                        $95,          ; Note A_2
                        $00
}

; Repeated subsection
{
TrackF173:           db $18,$3F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = 98h / 100h
                        $89,          ; Note A_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $89,          ; Note A_1
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $89,          ; Note A_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $89,          ; Note A_1
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $89,          ; Note A_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $89,          ; Note A_1
                        $89,          ; Note A_1
                        $18,$7F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = FCh / 100h
                        $89,          ; Note A_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $89,          ; Note A_1
                        $18,$4F,       ; Note length = 18h tics, note volume multiplier = FCh / 100h, note ring length multiplier = B2h / 100h
                        $89,          ; Note A_1
                        $0C,$1F,       ; Note length = Ch tics, note volume multiplier = FCh / 100h, note ring length multiplier = 65h / 100h
                        $89,          ; Note A_1
                        $00
}
endspcblock execute $1500