# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal library of Csound sound synthesis files for creating sample libraries (targeting MPC, EMAX-II, Kontakt formats). The repository contains various `.csd` (Csound Document) files that define synthesized instruments and sound generation algorithms.

## Repository Structure

The repository is organized into directories by sound type or example collection:
- `gong/` - Realistic gong instrument with inharmonic partials
- `breathy_flute/` - Breathy flute instrument with sample rendering capability
- `BainRissetArpeggioEx/` - Collection of Risset Arpeggio examples from Csound Journal Issue 17

## Csound File Format (.csd)

Each `.csd` file is a unified Csound document with three main sections:
1. `<CsOptions>` - Command-line options (e.g., `-odac` for real-time audio output, `-o filename` for file output)
2. `<CsInstruments>` - Orchestra code defining instruments and synthesis algorithms
3. `<CsScore>` - Score data defining when and how instruments are triggered

## Running Csound Files

To run a Csound file in real-time:
```bash
csound path/to/file.csd
```

To render to a file (if not already specified in CsOptions):
```bash
csound -o output.wav path/to/file.csd
```

## Instrument Architecture Patterns

### Two-Instrument Pattern (breathy_flute/breathy_flute.csd)
- Instrument 1: Real-time playback instrument for testing/performance
- Instrument 2: File rendering instrument that writes samples to disk
  - Uses `fout` opcode to write audio files
  - Generates chromatic scale samples for sampler use
  - Filename generation: `sprintf "flute_note_%d.wav", imidi`

### Single-Instrument Pattern (gong/gong.csd)
- Single instrument for real-time playback with complex synthesis
- Multiple oscillators for inharmonic partials (characteristic of metallic sounds)
- Complex envelopes for realistic decay characteristics
- Integrated reverb for spatial characteristics

## Key Synthesis Techniques Used

### Inharmonic Partials (gong.csd:21-28)
Metallic/percussive sounds use non-integer frequency ratios rather than harmonic series.

### Additive Synthesis
Multiple oscillators summed together with different frequencies, amplitudes, and envelopes.

### Envelope Shaping
- `adsr` - Attack, Decay, Sustain, Release envelope
- `linen` - Linear envelope with attack and release
- `expseg` - Exponential segment envelope for realistic decays

### Noise Generation (breathy_flute.csd:32-35)
Breath noise using `rand` opcode, filtered with `tone` for realistic breathy character.

## Sample Rate and Audio Settings

Standard settings across instruments:
- `sr = 44100` - Sample rate (44.1 kHz)
- `ksmps = 32` or `10` - Control rate samples per audio sample
- `nchnls = 2` or `1` - Number of output channels (stereo/mono)
- `0dbfs = 1` - 0 dB full scale = 1.0 (normalized amplitude)

## Score Parameter Format

Score lines follow the pattern:
```
i[instrument] [start_time] [duration] [p4] [p5] [p6] ...
```

Where p4, p5, p6, etc. are instrument-specific parameters (typically amplitude, frequency/pitch, pan).
