# MTC (MIDI Timecode)

Information on MIDI Timecode (part of the MIDI Specification).

MIDI Timecode is a device synchronization protocol that encodes SPMTE timecode using MIDI 1.0 (or MIDI 2.0) as transport.

This library does not implement MTC encoding or decoding directly.

Instead, [SwiftMIDI](https://github.com/orchetect/swift-midi) (an open-source Swift MIDI I/O package for all Apple platforms) implements MTC encoding/decoding.
It imports SwiftTimecode as a dependency and uses <doc://SwiftTimecode/SwiftTimecodeCore/Timecode-swift.struct> and <doc://SwiftTimecode/SwiftTimecodeCore/TimecodeFrameRate-swift.enum> as data structures.

## References

- [MIDI Timecode Specification](https://www.midi.org/specifications/midi1-specifications/midi-time-code) on midi.org (requires a free account to access)
- [MIDI Timecode](https://en.wikipedia.org/wiki/MIDI_timecode) on Wikipedia
