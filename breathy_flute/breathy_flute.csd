<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

; Breathy flute instrument
instr 1
    ; Parameters
    iamp = p4
    ifreq = cpsmidinn(p5)  ; MIDI note number
    iatt = 0.05
    idec = 0.1
    isus = 0.7
    irel = 0.2
    
    ; Envelope
    kenv adsr iatt, idec, isus, irel
    
    ; Main tone - using a sine wave with some harmonics
    a1 oscili 0.6, ifreq, 1
    a2 oscili 0.3, ifreq * 2, 1
    a3 oscili 0.15, ifreq * 3, 1
    a4 oscili 0.08, ifreq * 4, 1
    
    ; Breath noise - key to flute character
    anoise rand 0.15
    
    ; Filter the noise to make it more realistic
    anoise_filt tone anoise, ifreq * 2
    
    ; Add slight vibrato
    kvib lfo 0.005, 5.5, 0
    avib oscili kvib * ifreq, 5.5, 1
    
    ; Combine harmonics
    atone_sum = a1 + a2 + a3 + a4
    
    ; Add vibrato to tone
    atone_vib oscili 0.7, ifreq + avib, 1
    
    ; Mix tone with breath noise (more breath = more realistic flute)
    amix = (atone_sum * 0.7 + atone_vib * 0.3 + anoise_filt * 0.4) * kenv * iamp
    
    ; Add slight reverb for space
    arev reverb amix, 1.5
    amix = amix * 0.85 + arev * 0.15
    
    ; Output stereo
    outs amix, amix
endin

; Instrument to render samples to files
instr 2
    ; Parameters
    iamp = p4
    imidi = p5
    ifreq = cpsmidinn(imidi)
    Sfilename sprintf "flute_note_%d.wav", imidi
    
    iatt = 0.05
    idec = 0.1
    isus = 0.7
    irel = 0.2
    
    ; Envelope
    kenv adsr iatt, idec, isus, irel
    
    ; Main tone
    a1 oscili 0.6, ifreq, 1
    a2 oscili 0.3, ifreq * 2, 1
    a3 oscili 0.15, ifreq * 3, 1
    a4 oscili 0.08, ifreq * 4, 1
    
    ; Breath noise
    anoise rand 0.15
    anoise_filt tone anoise, ifreq * 2
    
    ; Vibrato
    kvib lfo 0.005, 5.5, 0
    avib oscili kvib * ifreq, 5.5, 1
    
    ; Combine
    atone_sum = a1 + a2 + a3 + a4
    atone_vib oscili 0.7, ifreq + avib, 1
    
    ; Mix
    amix = (atone_sum * 0.7 + atone_vib * 0.3 + anoise_filt * 0.4) * kenv * iamp
    
    ; Reverb
    arev reverb amix, 1.5
    amix = amix * 0.85 + arev * 0.15
    
    ; Write to file
    fout Sfilename, 14, amix, amix
endin

</CsInstruments>
<CsScore>
f1 0 16384 10 1  ; Sine wave

; Generate samples for chromatic scale from C3 to C6
; Format: i instrument start duration amp midinote
; MIDI note 60 = Middle C (C4)

; Render samples (3 seconds each)
i2 0 3 0.7 48   ; C3
i2 0 3 0.7 50   ; D3
i2 0 3 0.7 52   ; E3
i2 0 3 0.7 53   ; F3
i2 0 3 0.7 55   ; G3
i2 0 3 0.7 57   ; A3
i2 0 3 0.7 59   ; B3
i2 0 3 0.7 60   ; C4 (Middle C)
i2 0 3 0.7 62   ; D4
i2 0 3 0.7 64   ; E4
i2 0 3 0.7 65   ; F4
i2 0 3 0.7 67   ; G4
i2 0 3 0.7 69   ; A4
i2 0 3 0.7 71   ; B4
i2 0 3 0.7 72   ; C5
i2 0 3 0.7 74   ; D5
i2 0 3 0.7 76   ; E5
i2 0 3 0.7 77   ; F5
i2 0 3 0.7 79   ; G5
i2 0 3 0.7 81   ; A5
i2 0 3 0.7 83   ; B5
i2 0 3 0.7 84   ; C6

e
</CsScore>
</CsoundSynthesizer>