# ``SwiftTimecodeUI``

UI controls and tools for formatting and displaying timecode, including user-editable timecode fields.

![SwiftTimecode](swift-timecode-banner.png)

## Topics

### AppKit

- ``SwiftTimecodeCore/Timecode/TextField``
- ``SwiftTimecodeCore/Timecode/TextFieldCell``

### SwiftUI

- ``TimecodeField``
- ``TimecodeText``

### SwiftUI View Modifiers

- ``SwiftUICore/View/timecodeFormat(_:)``
- ``SwiftUICore/View/timecodeFieldHighlightStyle(_:)-(ShapeStyle)``
- ``SwiftUICore/View/timecodeFieldHighlightStyle(_:)-8k1sm``
- ``SwiftUICore/View/timecodeFieldInputStyle(_:)``
- ``SwiftUICore/View/timecodeFieldInputWrapping(_:)``
- ``SwiftUICore/View/timecodeFieldEscapeAction(_:)``
- ``SwiftUICore/View/timecodeFieldReturnAction(_:)``
- ``SwiftUICore/View/timecodeFieldValidationPolicy(_:)``
- ``SwiftUICore/View/timecodeFieldInputRejectionFeedback(_:)``
- ``SwiftUICore/View/timecodeSeparatorStyle(_:)-(ShapeStyle)``
- ``SwiftUICore/View/timecodeSeparatorStyle(_:)-5cwmi``
- ``SwiftUICore/View/timecodeSubFramesStyle(_:)-(ShapeStyle)``
- ``SwiftUICore/View/timecodeSubFramesStyle(_:)-4p9lf``
- ``SwiftUICore/View/timecodeSubFramesStyle(scale:)``
- ``SwiftUICore/View/timecodeSubFramesStyle(_:scale:)-(ShapeStyle,_)``
- ``SwiftUICore/View/timecodeSubFramesStyle(_:scale:)-7fidz``
- ``SwiftUICore/View/timecodeValidationStyle(_:)-(ShapeStyle)``
- ``SwiftUICore/View/timecodeValidationStyle(_:)-2me4o``

### SwiftUI State

- ``TimecodeState``
- ``SwiftUICore/Binding/option(_:)``

### AttributedString

- ``Foundation/AttributedString/init(_:format:separatorStyle:subFramesStyle:validationStyle:)``

### NSAttributedString

- ``Foundation/NSAttributedString/init(_:format:defaultAttributes:separatorAttributes:subFramesAttributes:invalidAttributes:)``
- ``SwiftTimecodeCore/Timecode/nsAttributedString(format:defaultAttributes:separatorAttributes:subFramesAttributes:invalidAttributes:)``

### Formatter

- ``SwiftTimecodeCore/Timecode/TextFormatter``
