<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

; Realistic Gong Instrument
instr 1
    ; Parameters
    iamp = p4
    ifreq = p5
    ipan = p6
    
    ; Multiple inharmonic partials for gong-like timbre
    ; Gongs have complex, non-integer harmonic relationships
    a1 oscili iamp * 0.4, ifreq * 1.0, 1
    a2 oscili iamp * 0.3, ifreq * 1.47, 1
    a3 oscili iamp * 0.25, ifreq * 2.13, 1
    a4 oscili iamp * 0.2, ifreq * 2.87, 1
    a5 oscili iamp * 0.15, ifreq * 3.51, 1
    a6 oscili iamp * 0.12, ifreq * 4.33, 1
    a7 oscili iamp * 0.1, ifreq * 5.21, 1
    a8 oscili iamp * 0.08, ifreq * 6.13, 1
    
    ; Sum partials
    amix = a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8
    
    ; Complex amplitude envelope with initial attack and very long decay
    kenv expseg 0.001, 0.002, 1.0, 0.05, 0.7, 0.2, 0.4, 2.0, 0.15, 6.0, 0.001
    
    ; High frequency shimmer that decays faster
    kshimmer expseg 0.001, 0.001, 1.0, 0.3, 0.1, 1.5, 0.001
    a9 oscili iamp * 0.15 * kshimmer, ifreq * 7.89, 1
    a10 oscili iamp * 0.12 * kshimmer, ifreq * 9.43, 1
    
    amix = amix + a9 + a10
    
    ; Apply envelope
    amix = amix * kenv
    
    ; Add subtle frequency modulation for shimmer
    klfo lfo 0.003, 0.7, 0
    amix = amix * (1 + klfo)
    
    ; Reverb for space and realistic decay
    arevL, arevR reverbsc amix, amix, 0.92, 8000
    
    ; Mix dry and wet
    amixL = amix * 0.4 + arevL * 0.6
    amixR = amix * 0.4 + arevR * 0.6
    
    ; Stereo panning
    aL = amixL * sqrt(1 - ipan)
    aR = amixR * sqrt(ipan)
    
    ; Output
    outs aL, aR
endin

</CsInstruments>
<CsScore>
; Function table: sine wave
f1 0 16384 10 1

; Pattern: p1=instr, p2=start, p3=duration, p4=amp, p5=freq, p6=pan
;         inst    start  dur   amp    freq     pan
i1        0      12     0.5    80     0.3    ; Low gong
i1        3      12     0.4    120    0.7    ; Mid gong
i1        5.5    12     0.45   65     0.5    ; Deep gong
i1        8      12     0.35   150    0.2    ; Higher gong

e
</CsScore>
</CsoundSynthesizer>